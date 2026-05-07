import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<StockLedgerEntry>>(
      valueListenable: Hive.box<StockLedgerEntry>(
        AppStrings.ledgerBoxName,
      ).listenable(),
      builder: (context, box, child) {
        final latest = StockLedgerHiveService.instance.recentEntries(
          limit: 10,
          includeInitialSeedEntries: false,
        );
        final items = <_DashItem>[
          const _DashItem(
            icon: Icons.inventory_2_outlined,
            title: AppStrings.inventoryTitle,
            subtitle: AppStrings.stockIn,
            route: AppRouter.inventory,
          ),
          const _DashItem(
            icon: Icons.precision_manufacturing_outlined,
            title: AppStrings.productionTitle,
            subtitle: AppStrings.productionSubtitle,
            route: AppRouter.production,
          ),
          const _DashItem(
            icon: Icons.receipt_long_outlined,
            title: AppStrings.salesTitle,
            subtitle: AppStrings.createOrder,
            route: AppRouter.sales,
          ),
          const _DashItem(
            icon: Icons.assignment_return_outlined,
            title: AppStrings.returnsTitle,
            subtitle: AppStrings.dismantleWatch,
            route: AppRouter.returns,
          ),
        ];

        return ResponsiveScaffold(
          appBar: const AppAppBar(
            backgroundColor: AppColors.obsidianMidnight,
            title: AppText(AppStrings.dashboardTitle),
          ),
          backgroundColor: AppColors.obsidianMidnight,
          body: ResponsiveLayout(
            mobile: _buildMobile(context, items, latest),
            tablet: _buildTablet(context, items, latest),
            desktop: _buildDesktop(context, items, latest),
          ),
        );
      },
    );
  }

  Widget _buildMobile(
    BuildContext context,
    List<_DashItem> items,
    List<StockLedgerEntry> latest,
  ) {
    return AnimationLimiter(
      child: ListView(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 350),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: AppSizes.xl,
            child: FadeInAnimation(child: widget),
          ),
          children: <Widget>[
            _headerCard(context, latest.length),
            ...items.map((i) => _navTile(context, item: i)),
            const SizedBox(height: AppSizes.large),
            _latestCard(context, latest),
          ],
        ),
      ),
    );
  }

  Widget _buildTablet(
    BuildContext context,
    List<_DashItem> items,
    List<StockLedgerEntry> latest,
  ) {
    return ListView(
      children: <Widget>[
        _headerCard(context, latest.length),
        AppSpacing.vMd,
        AppGrid<_DashItem>(
          items: items,
          screenPreset: ScreenPreset.comfortable,
          mobileCrossAxisCount: 1,
          tabletCrossAxisCount: 2,
          desktopCrossAxisCount: 2,
          childAspectRatio: 1.55,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item, index) => _navCard(context, item: item),
        ),
        const SizedBox(height: AppSizes.large),
        _latestCard(context, latest),
      ],
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    List<_DashItem> items,
    List<StockLedgerEntry> latest,
  ) {
    return ListView(
      children: <Widget>[
        _headerCard(context, latest.length),
        AppSpacing.vMd,
        AppGrid<_DashItem>(
          items: items,
          screenPreset: ScreenPreset.spacious,
          mobileCrossAxisCount: 1,
          tabletCrossAxisCount: 2,
          desktopCrossAxisCount: 2,
          childAspectRatio: 1.75,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item, index) => _navCard(context, item: item),
        ),
        const SizedBox(height: AppSizes.large),
        _latestCard(context, latest),
      ],
    );
  }

  Widget _headerCard(BuildContext context, int moveCount) {
    final subtitle = AppStrings.dashboardDynamicTagline.replaceAll(
      '{moves}',
      moveCount.toString(),
    );
    return _glassCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppColors.borderGlass, AppColors.obsidianMidnight],
          ),
          borderRadius: BorderRadius.circular(AppSizes.lg),
        ),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.appTitle,
              style: ResponsiveTypography.luxuryHeading(context).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 30,
                fontFamily: 'Times New Roman',
              ),
            ),
            AppSpacing.vXs,
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _latestCard(BuildContext context, List<StockLedgerEntry> latest) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _premiumHeading(context, AppStrings.latestTenEntries),
          AppSpacing.vMd,
          if (latest.isEmpty)
            const AppText(AppStrings.noLedgerTransactions)
          else
            _buildStickyGroupedRows(context, latest),
          AppSpacing.vSm,
          AppButton(
            label: AppStrings.viewAllLedger,
            isExpanded: true,
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.ledger),
          ),
        ],
      ),
    );
  }

  Widget _navCard(BuildContext context, {required _DashItem item}) {
    return _glassCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        onTap: () => Navigator.of(context).pushNamed(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardGlass,
                      borderRadius: BorderRadius.circular(AppSizes.md),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Icon(item.icon, color: AppColors.goldenAmber),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.open_in_new,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
              AppSpacing.vMd,
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.vXs,
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  Text(
                    AppStrings.openLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.goldenAmber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.goldenAmber,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navTile(BuildContext context, {required _DashItem item}) {
    return _glassCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        onTap: () => Navigator.of(context).pushNamed(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Row(
            children: <Widget>[
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.cardGlass,
                  borderRadius: BorderRadius.circular(AppSizes.md),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: Icon(item.icon, color: AppColors.goldenAmber),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.vXs,
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
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
      child: Padding(padding: const EdgeInsets.all(AppSizes.lg), child: child),
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
          style: ResponsiveTypography.luxuryHeading(
            context,
          ).copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _latestRow(StockLedgerEntry e) {
    final isIn = e.transactionType == 'IN';
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
                    AppText(
                      e.itemName,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    AppSpacing.vXs,
                    AppText(
                      e.reason,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    AppSpacing.vXs,
                    AppText(
                      _when(e.createdAt),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
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
                  'x${e.quantity}',
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _when(DateTime dt) =>
      '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

  Widget _buildStickyGroupedRows(
    BuildContext context,
    List<StockLedgerEntry> entries,
  ) {
    final grouped = <_DateSection>[];
    final groupedMap = <DateTime, List<StockLedgerEntry>>{};
    for (final entry in entries) {
      final key = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      groupedMap.putIfAbsent(key, () => <StockLedgerEntry>[]).add(entry);
    }
    final sortedDates = groupedMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    for (final date in sortedDates) {
      grouped.add(_DateSection(date: date, entries: groupedMap[date]!));
    }

    final widgets = <Widget>[];
    for (final section in grouped) {
      widgets.add(_dateHeader(context, _monthDateLabel(section.date)));
      widgets.addAll(section.entries.map(_latestRow));
    }
    return Column(children: widgets);
  }

  Widget _dateHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardGlass,
          borderRadius: BorderRadius.circular(AppSizes.md),
          border: Border.all(color: AppColors.borderGold10),
        ),
        child: Text(
          title,
          style: ResponsiveTypography.luxuryHeading(
            context,
          ).copyWith(color: AppColors.champagneGold, fontSize: 15),
        ),
      ),
    );
  }

  String _monthDateLabel(DateTime dt) {
    return '${AppStrings.monthNames[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }
}

class _DateSection {
  const _DateSection({required this.date, required this.entries});

  final DateTime date;
  final List<StockLedgerEntry> entries;
}

class _DashItem {
  const _DashItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}
