// ignore_for_file: unused_element

import 'package:lottie/lottie.dart';
import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_event.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_state.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final TextEditingController _qtyController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(const SalesLoadRequested());
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalesBloc, SalesState>(
      listenWhen: (previous, current) =>
          !previous.showLowStockWarning && current.showLowStockWarning,
      listener: (context, state) {
        if (state.showLowStockWarning) {
          AppDialog.show<void>(
            context: context,
            title: const AppText(AppStrings.lowStockTitle),
            content: const AppText(AppStrings.insufficientFinishedWatch),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.close),
              ),
            ],
          );
        }
      },
      child: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          final loading = state.viewState == ViewState.loading;
          final success = state.viewState == ViewState.success && state.successMessage != null;

          return ResponsiveScaffold(
            appBar: const AppAppBar(
              backgroundColor: AppColors.obsidianMidnight,
              title: AppText(AppStrings.salesTitle),
            ),
            backgroundColor: AppColors.obsidianMidnight,
            body: ResponsiveLayout(
              mobile: _buildLeft(context, state, loading, success),
              tablet: _buildLeft(context, state, loading, success),
              desktop: _buildLeft(context, state, loading, success),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeft(BuildContext context, SalesState state, bool loading, bool success) {
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
                  AppText('${AppStrings.watch}: ${state.stock[AppStrings.watch] ?? 0}'),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => context.read<SalesBloc>().add(SalesQuantityChanged(value)),
                    decoration: const InputDecoration(
                      labelText: AppStrings.orderQuantityLabel,
                      hintText: AppStrings.qtyHint,
                    ),
                  ),
                  AppSpacing.vMd,
                  AppButton(
                    label: AppStrings.createOrder,
                    isExpanded: true,
                    onPressed: loading ? null : () => context.read<SalesBloc>().add(const SalesCreateOrderRequested()),
                    icon: loading ? const AppLoader(size: AppSizes.md, strokeWidth: 2) : null,
                  ),
                  if (state.errorMessage != null) ...<Widget>[
                    AppSpacing.vSm,
                    AppText(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.danger),
                    ),
                  ],
                ],
              ),
            ),
            if (success)
              _glassCard(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: AppSizes.xxl * 3,
                      child: Lottie.asset(AppStrings.successLottieAsset, repeat: false),
                    ),
                    AppText(state.successMessage!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerPanel(List<StockLedgerEntry> entries, {required bool scrollable}) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AppText(AppStrings.transactionHistory),
          AppSpacing.vMd,
          if (entries.isEmpty)
            const AppText(AppStrings.noLedgerTransactions)
          else if (!scrollable)
            ...entries.take(8).map(_ledgerRow)
          else
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (_, index) => _ledgerRow(entries[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _ledgerRow(StockLedgerEntry entry) {
    final type = entry.transactionType;
    final isIn = type == 'IN';
    final accent = isIn ? AppColors.success : AppColors.goldenAmber;
    final badgeBg = accent.withValues(alpha: 0.18);
    final badgeBorder = accent.withValues(alpha: 0.45);

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
              child: AppText(type, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
            ),
            AppSpacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(entry.itemName, style: const TextStyle(fontWeight: FontWeight.w700)),
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
                AppText('x${entry.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                AppSpacing.vXs,
                AppText(_formatWhen(entry.createdAt), style: const TextStyle(color: AppColors.textSecondary)),
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
}

