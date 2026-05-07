// ignore_for_file: unused_element

import 'package:lottie/lottie.dart';
import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_event.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_state.dart';

class ProductionView extends StatefulWidget {
  const ProductionView({super.key});

  @override
  State<ProductionView> createState() => _ProductionViewState();
}

class _ProductionViewState extends State<ProductionView> {
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    context.read<ProductionBloc>().add(const ProductionLoadRequested());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductionBloc, ProductionState>(
      listenWhen: (previous, current) =>
          !previous.showLowStockWarning && current.showLowStockWarning,
      listener: (context, state) {
        if (state.showLowStockWarning) {
          AppDialog.show<void>(
            context: context,
            title: const AppText(AppStrings.lowStockTitle),
            content: const AppText(AppStrings.lowStockMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.close),
              ),
            ],
          );
        }
      },
      child: BlocBuilder<ProductionBloc, ProductionState>(
        builder: (context, state) {
          return ResponsiveScaffold(
            appBar: const AppAppBar(
              backgroundColor: AppColors.obsidianMidnight,
              title: AppText(AppStrings.productionTitle),
            ),
            backgroundColor: AppColors.obsidianMidnight,
            body: ResponsiveLayout(
              mobile: _buildContent(context, state),
              tablet: _buildContent(context, state),
              desktop: _buildContent(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductionState state) {
    final loading = state.viewState == ViewState.loading;
    return AnimationLimiter(
      child: ListView(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: AppSizes.xl,
            child: FadeInAnimation(child: widget),
          ),
          children: <Widget>[
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppText(AppStrings.productionSubtitle),
                  AppSpacing.vLg,
                  AppTextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) =>
                        context.read<ProductionBloc>().add(ProductionQuantityChanged(value)),
                    decoration: const InputDecoration(
                      labelText: AppStrings.quantityLabel,
                      hintText: AppStrings.quantityHint,
                    ),
                  ),
                  AppSpacing.vMd,
                  AppButton(
                    label: AppStrings.assembleNow,
                    isExpanded: true,
                    onPressed: loading
                        ? null
                        : () => context.read<ProductionBloc>().add(const ProductionAssembleRequested()),
                    icon: loading ? const AppLoader(size: AppSizes.md, strokeWidth: 2) : null,
                  ),
                  AppSpacing.vSm,
                  AppButton(
                    label: AppStrings.refreshStock,
                    isExpanded: true,
                    onPressed: () => context.read<ProductionBloc>().add(const ProductionLoadRequested()),
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
            if (state.showSuccess)
              _glassCard(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: AppSizes.xxl * 3,
                      child: Lottie.asset(
                        AppStrings.successLottieAsset,
                        repeat: false,
                      ),
                    ),
                    const AppText(AppStrings.successAssembly),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerCard(ProductionState state, {required bool scrollable}) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AppText(AppStrings.transactionHistory),
          AppSpacing.vMd,
          if (state.entries.isEmpty)
            const AppText(AppStrings.noLedgerTransactions)
          else if (!scrollable)
            ...state.entries.take(8).map(_ledgerRow)
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.entries.length,
                itemBuilder: (_, index) => _ledgerRow(state.entries[index]),
              ),
            ),
        ],
      ),
    );
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
