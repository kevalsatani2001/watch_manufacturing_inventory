// ignore_for_file: unused_element

import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_event.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_state.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final TextEditingController _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(const InventoryLoadRequested());
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        final loading = state.viewState == ViewState.loading;

        return ResponsiveScaffold(
          appBar: const AppAppBar(
            backgroundColor: AppColors.obsidianMidnight,
            title: AppText(AppStrings.inventoryTitle),
          ),
          backgroundColor: AppColors.obsidianMidnight,
          body: ResponsiveLayout(
            mobile: _buildBody(context, state, loading),
            tablet: _buildBody(context, state, loading),
            desktop: _buildBody(context, state, loading),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, InventoryState state, bool loading) {
    final items = state.items.where((e) => e != AppStrings.filterAll).toList();
    final selected = items.contains(state.selectedItem) ? state.selectedItem : (items.isEmpty ? null : items.first);
    return AnimationLimiter(
      child: ListView(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 350),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: AppSizes.xl,
            child: FadeInAnimation(child: widget),
          ),
          children: <Widget>[
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppText(AppStrings.stockIn),
                  AppSpacing.vMd,
                  AppDropdown<String>(
                    value: selected,
                    items: items,
                    itemLabelBuilder: (v) => v,
                    decoration: const InputDecoration(labelText: AppStrings.itemLabel),
                    onChanged: (value) =>
                        context.read<InventoryBloc>().add(InventoryItemChanged(value)),
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => context.read<InventoryBloc>().add(InventoryQuantityChanged(value)),
                    decoration: const InputDecoration(
                      labelText: AppStrings.qtyLabel,
                      hintText: AppStrings.qtyHint,
                    ),
                  ),
                  AppSpacing.vMd,
                  AppButton(
                    label: AppStrings.addEntry,
                    isExpanded: true,
                    onPressed: loading
                        ? null
                        : () {
                            context.read<InventoryBloc>().add(const InventoryStockInRequested());
                            _qtyController.clear();
                          },
                    icon: loading ? const AppLoader(size: AppSizes.md, strokeWidth: 2) : null,
                  ),
                  AppSpacing.vSm,
                  AppButton(
                    label: AppStrings.addStockOutEntry,
                    isExpanded: true,
                    onPressed: loading
                        ? null
                        : () {
                            context.read<InventoryBloc>().add(const InventoryStockOutRequested());
                            _qtyController.clear();
                          },
                  ),
                  if (state.errorMessage != null) ...<Widget>[
                    AppSpacing.vSm,
                    AppText(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.danger),
                    ),
                  ],
                  if (state.successMessage != null) ...<Widget>[
                    AppSpacing.vSm,
                    AppText(
                      state.successMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success),
                    ),
                  ],
                ],
              ),
            ),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppText(AppStrings.stockSnapshot),
                  AppSpacing.vMd,
                  _stockRow(AppStrings.dial, state.stock[AppStrings.dial] ?? 0),
                  _stockRow(AppStrings.watchCase, state.stock[AppStrings.watchCase] ?? 0),
                  _stockRow(AppStrings.machine, state.stock[AppStrings.machine] ?? 0),
                  _stockRow(AppStrings.watch, state.stock[AppStrings.watch] ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(InventoryState state, {required bool scrollable}) {
    final reasonsByTx = _reasonsForTx(state.filterTx);
    final reasonValue = reasonsByTx.contains(state.filterReason) ? state.filterReason : AppStrings.filterAll;
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AppText(AppStrings.transactionHistory),
          AppSpacing.vMd,
          Row(
            children: <Widget>[
              Expanded(
                child: AppDropdown<String>(
                  value: state.filterItem,
                  items: state.items,
                  itemLabelBuilder: (v) => v,
                  decoration: const InputDecoration(labelText: AppStrings.itemLabel),
                  onChanged: (value) => context.read<InventoryBloc>().add(InventoryFilterItemChanged(value)),
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: AppDropdown<String>(
                  value: state.filterTx,
                  items: const <String>[AppStrings.filterAll, 'IN', 'OUT'],
                  itemLabelBuilder: (v) => v,
                  decoration: const InputDecoration(labelText: AppStrings.filterType),
                  onChanged: (value) =>
                      context.read<InventoryBloc>().add(InventoryFilterTxChanged(value ?? AppStrings.filterAll)),
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  label: state.filterFrom == null ? AppStrings.filterFrom : _fmtDate(state.filterFrom!),
                  isExpanded: true,
                  onPressed: () async {
                    final bloc = context.read<InventoryBloc>();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.filterFrom ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted) return;
                    if (picked != null) {
                      bloc.add(InventoryFilterFromDateChanged(picked));
                    }
                  },
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: AppButton(
                  label: state.filterTo == null ? AppStrings.filterTo : _fmtDate(state.filterTo!),
                  isExpanded: true,
                  onPressed: () async {
                    final bloc = context.read<InventoryBloc>();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.filterTo ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted) return;
                    if (picked != null) {
                      bloc.add(InventoryFilterToDateChanged(picked));
                    }
                  },
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          AppDropdown<String>(
            value: reasonValue,
            items: reasonsByTx,
            itemLabelBuilder: (v) => v,
            decoration: const InputDecoration(labelText: AppStrings.filterReason),
            onChanged: (value) => context
                .read<InventoryBloc>()
                .add(InventoryFilterReasonChanged(value ?? AppStrings.filterAll)),
          ),
          AppSpacing.vSm,
          AppButton(
            label: AppStrings.clearFilters,
            isExpanded: true,
            onPressed: () {
              context.read<InventoryBloc>().add(const InventoryClearFiltersRequested());
            },
          ),
          AppSpacing.vMd,
          if (state.filteredEntries.isEmpty)
            const AppText(AppStrings.noLedgerTransactions)
          else if (!scrollable)
            ...state.filteredEntries.take(8).map(_ledgerRow)
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.filteredEntries.length,
                itemBuilder: (_, index) => _ledgerRow(state.filteredEntries[index]),
              ),
            ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
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
    return statefulAllReasons();
  }

  List<String> statefulAllReasons() {
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

  Widget _ledgerRow(StockLedgerEntry entry) {
    final String type = entry.transactionType;
    final bool isIn = type == 'IN';
    final Color accent = isIn ? AppColors.success : AppColors.goldenAmber;
    final Color badgeBg = accent.withValues(alpha: 0.18);
    final Color badgeBorder = accent.withValues(alpha: 0.45);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.cardGlass,
          borderRadius: BorderRadius.circular(AppSizes.md),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(AppSizes.sm),
                border: Border.all(color: badgeBorder),
              ),
              child: AppText(
                type,
                style: TextStyle(color: accent, fontWeight: FontWeight.w800),
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    entry.itemName,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                  AppSpacing.vXs,
                  AppText(
                    entry.reason,
                    style: const TextStyle(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSpacing.hMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                AppText(
                  'x${entry.quantity}',
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800),
                ),
                AppSpacing.vXs,
                AppText(
                  _formatWhen(entry.createdAt),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatWhen(DateTime dt) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${two(dt.hour)}:${two(dt.minute)} • ${two(dt.day)}/${two(dt.month)}';
  }

  Widget _glassCard({required Widget child}) {
    return AppCard(
      color: AppColors.cardGlass,
      shadowColor: AppColors.obsidianMidnight,
      elevation: AppSizes.xs,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: const BorderSide(color: AppColors.borderGlass),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: child,
      ),
    );
  }

  Widget _stockRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppText(name),
          AppText(value.toString()),
        ],
      ),
    );
  }
}

