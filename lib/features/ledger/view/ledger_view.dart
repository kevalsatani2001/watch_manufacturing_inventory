import 'dart:ui';
import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_event.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_state.dart';

class LedgerView extends StatefulWidget {
  const LedgerView({super.key});

  @override
  State<LedgerView> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<LedgerView> {
  final _service = StockLedgerHiveService.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<LedgerBloc>().add(const LedgerLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 220;
    if (_scrollController.position.pixels >= threshold) {
      context.read<LedgerBloc>().add(const LedgerLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LedgerBloc, LedgerState>(
      builder: (context, state) {
        final groupedWidgets = _buildDateGroupedWidgets(state.entries);
        return ResponsiveScaffold(
          appBar: AppAppBar(
            backgroundColor: AppColors.obsidianMidnight,
            title: const AppText(AppStrings.ledgerTitle),
            actions: <Widget>[
              IconButton(
                onPressed: state.isExportingPdf
                    ? null
                    : () => context.read<LedgerBloc>().add(const LedgerPdfExportRequested()),
                icon: state.isExportingPdf
                    ? const SizedBox(
                        height: AppSizes.lg,
                        width: AppSizes.lg,
                        child: AppLoader(size: AppSizes.lg, strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_rounded, color: AppColors.champagneGold),
                tooltip: AppStrings.exportPdf,
              ),
              IconButton(
                onPressed: () => _openFilters(context, state),
                icon: const Icon(Icons.tune_rounded, color: AppColors.champagneGold),
                tooltip: AppStrings.openFilters,
              ),
            ],
          ),
          backgroundColor: AppColors.obsidianMidnight,
          body: _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _premiumHeading(context, AppStrings.latestTenEntries),
                AppSpacing.vMd,
                Expanded(
                  child: state.entries.isEmpty
                      ? const Center(child: AppText(AppStrings.noLedgerTransactions))
                      : AnimationLimiter(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: groupedWidgets.length + (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= groupedWidgets.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                                  child: Center(child: AppLoader()),
                                );
                              }
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 360),
                                child: SlideAnimation(
                                  verticalOffset: AppSizes.md,
                                  curve: Curves.easeOutExpo,
                                  child: FadeInAnimation(child: groupedWidgets[index]),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                if (state.isExportingPdf)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSizes.sm),
                    child: Row(
                      children: <Widget>[
                        AppLoader(size: AppSizes.lg, strokeWidth: 2),
                        SizedBox(width: AppSizes.sm),
                        AppText(AppStrings.exportingPdf),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFilters(BuildContext context, LedgerState state) async {
    final ledgerBloc = context.read<LedgerBloc>();
    String draftItem = state.item;
    String draftTx = state.tx;
    String draftReason = state.reason;
    DateTime? draftFrom = state.from;
    DateTime? draftTo = state.to;
    final items = <String>[AppStrings.filterAll, ..._service.supportedItems()];

    await AppBottomSheet.show<void>(
      context: context,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          final reasons = _reasonsForTx(draftTx);
          if (!reasons.contains(draftReason)) draftReason = AppStrings.filterAll;

          return ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardLuxury.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppSizes.lg),
                  border: Border.all(color: AppColors.borderGold10),
                ),
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _premiumHeading(context, AppStrings.premiumFilterTitle),
                    AppSpacing.vMd,
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AppDropdown<String>(
                            value: draftItem,
                            items: items,
                            itemLabelBuilder: (v) => v,
                            decoration: const InputDecoration(labelText: AppStrings.itemLabel),
                            onChanged: (v) => setModalState(() => draftItem = v ?? AppStrings.filterAll),
                          ),
                        ),
                        AppSpacing.hSm,
                        Expanded(
                          child: AppDropdown<String>(
                            value: draftTx,
                            items: const <String>[AppStrings.filterAll, 'IN', 'OUT'],
                            itemLabelBuilder: (v) => v,
                            decoration: const InputDecoration(labelText: AppStrings.filterType),
                            onChanged: (v) => setModalState(() => draftTx = v ?? AppStrings.filterAll),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vSm,
                    AppDropdown<String>(
                      value: draftReason,
                      items: reasons,
                      itemLabelBuilder: (v) => v,
                      decoration: const InputDecoration(labelText: AppStrings.filterReason),
                      onChanged: (v) => setModalState(() => draftReason = v ?? AppStrings.filterAll),
                    ),
                    AppSpacing.vSm,
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AppButton(
                            label: draftFrom == null ? AppStrings.filterFrom : _fmtDate(draftFrom!),
                            isExpanded: true,
                            onPressed: () async {
                              final picked = await _pickPremiumDate(
                                context: context,
                                initialDate: draftFrom ?? DateTime.now(),
                              );
                              if (picked == null || !context.mounted) return;
                              setModalState(() => draftFrom = picked);
                            },
                          ),
                        ),
                        AppSpacing.hSm,
                        Expanded(
                          child: AppButton(
                            label: draftTo == null ? AppStrings.filterTo : _fmtDate(draftTo!),
                            isExpanded: true,
                            onPressed: () async {
                              final picked = await _pickPremiumDate(
                                context: context,
                                initialDate: draftTo ?? DateTime.now(),
                              );
                              if (picked == null || !context.mounted) return;
                              setModalState(() => draftTo = picked);
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.md),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.champagneGold.withValues(alpha: 0.35),
                            blurRadius: AppSizes.md,
                            spreadRadius: 0.3,
                          ),
                        ],
                      ),
                      child: AppButton(
                        label: AppStrings.applyFilters,
                        isExpanded: true,
                        onPressed: () {
                          ledgerBloc.add(
                                LedgerFiltersApplied(
                                  item: draftItem,
                                  tx: draftTx,
                                  reason: draftReason,
                                  from: draftFrom,
                                  to: draftTo,
                                ),
                              );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    AppSpacing.vSm,
                    AppButton(
                      label: AppStrings.clearFilters,
                      isExpanded: true,
                      onPressed: () {
                        ledgerBloc.add(
                              const LedgerFiltersApplied(
                                item: AppStrings.filterAll,
                                tx: AppStrings.filterAll,
                                reason: AppStrings.filterAll,
                                from: null,
                                to: null,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _ledgerRow(StockLedgerEntry entry) {
    final isIn = entry.transactionType == 'IN';
    final accent = isIn ? AppColors.success : AppColors.danger;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: <Widget>[
              Container(
                height: AppSizes.xxl + AppSizes.sm,
                width: AppSizes.xxl + AppSizes.sm,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardGlass,
                  border: Border.all(color: AppColors.borderGold10),
                ),
                child: Icon(
                  isIn ? Icons.south_west_rounded : Icons.north_east_rounded,
                  color: AppColors.champagneGold,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(entry.itemName, style: const TextStyle(fontWeight: FontWeight.w800)),
                    AppSpacing.vXs,
                    AppText(entry.reason, style: const TextStyle(color: AppColors.textSecondary)),
                    AppSpacing.vXs,
                    AppText(_when(entry.createdAt), style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: accent.withValues(alpha: 0.32),
                      blurRadius: AppSizes.md,
                      spreadRadius: 0.4,
                    ),
                  ],
                ),
                child: AppText(
                  'x${entry.quantity}',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDateGroupedWidgets(List<StockLedgerEntry> entries) {
    final grouped = <DateTime, List<StockLedgerEntry>>{};
    for (final entry in entries) {
      final key = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      grouped.putIfAbsent(key, () => <StockLedgerEntry>[]).add(entry);
    }
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final widgets = <Widget>[];
    for (final date in dates) {
      widgets.add(_dateHeader(date));
      widgets.addAll(grouped[date]!.map(_ledgerRow));
    }
    return widgets;
  }

  Widget _dateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm, top: AppSizes.xs),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.cardLuxury,
          borderRadius: BorderRadius.circular(AppSizes.md),
          border: Border.all(color: AppColors.borderGold10),
        ),
        child: Text(
          _monthDateLabel(date),
          style: ResponsiveTypography.luxuryHeading(context).copyWith(
            color: AppColors.champagneGold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _premiumHeading(BuildContext context, String title) {
    return Row(
      children: <Widget>[
        Container(
          height: AppSizes.xl,
          width: 3,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[AppColors.champagneGold, Colors.transparent],
            ),
          ),
        ),
        AppSpacing.hSm,
        Text(
          title,
          style: ResponsiveTypography.luxuryHeading(context).copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _glassCard({required Widget child}) {
    return AppCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0x221E293B), Color(0x660F172A)],
          ),
          borderRadius: BorderRadius.circular(AppSizes.lg),
          border: Border.all(color: AppColors.borderGlass),
        ),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: child,
      ),
    );
  }

  List<String> _reasonsForTx(String tx) {
    if (tx == 'IN') {
      return <String>[
        AppStrings.filterAll,
        AppStrings.reasonInitialStock,
        AppStrings.reasonPurchase,
        AppStrings.reasonProductionOutput,
        AppStrings.reasonReturn,
        AppStrings.reasonDismantle,
      ];
    }
    if (tx == 'OUT') {
      return <String>[
        AppStrings.filterAll,
        AppStrings.reasonManualStockOut,
        AppStrings.reasonAssemblyComponentsOut,
        AppStrings.reasonSale,
        AppStrings.reasonDismantle,
      ];
    }
    return <String>[
      AppStrings.filterAll,
      AppStrings.reasonInitialStock,
      AppStrings.reasonPurchase,
      AppStrings.reasonManualStockOut,
      AppStrings.reasonAssemblyComponentsOut,
      AppStrings.reasonProductionOutput,
      AppStrings.reasonSale,
      AppStrings.reasonReturn,
      AppStrings.reasonDismantle,
    ];
  }

  String _fmtDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  String _when(DateTime dt) => '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

  String _monthDateLabel(DateTime dt) {
    return '${AppStrings.monthNames[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }

  Future<DateTime?> _pickPremiumDate({
    required BuildContext context,
    required DateTime initialDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final baseTheme = Theme.of(context);
        return Theme(
          data: baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              primary: AppColors.champagneGold,
              onPrimary: AppColors.obsidianMidnight,
              surface: AppColors.cardLuxury,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.obsidianMidnight,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

