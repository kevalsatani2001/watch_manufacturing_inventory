import 'dart:ui';

import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/dashboard/services/dashboard_stock_analysis_service.dart';

class StockGridWidget extends StatelessWidget {
  const StockGridWidget({
    super.key,
    required this.stock,
  });

  final Map<String, int> stock;

  @override
  Widget build(BuildContext context) {
    final tiles = <_StockTileData>[
      _StockTileData(
        label: AppStrings.dial,
        value: stock[AppStrings.dial] ?? 0,
        icon: Icons.watch_later_outlined,
        borderGradient: const <Color>[AppColors.goldenAmber, AppColors.borderGlass],
      ),
      _StockTileData(
        label: AppStrings.watchCase,
        value: stock[AppStrings.watchCase] ?? 0,
        icon: Icons.crop_portrait_rounded,
        borderGradient: const <Color>[AppColors.success, AppColors.borderGlass],
      ),
      _StockTileData(
        label: AppStrings.machine,
        value: stock[AppStrings.machine] ?? 0,
        icon: Icons.precision_manufacturing_rounded,
        borderGradient: const <Color>[AppColors.textSecondary, AppColors.borderGlass],
      ),
      _StockTileData(
        label: AppStrings.watch,
        value: stock[AppStrings.watch] ?? 0,
        icon: Icons.watch_rounded,
        borderGradient: const <Color>[AppColors.champagneGold, AppColors.borderGold10],
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.md,
      mainAxisSpacing: AppSizes.md,
      childAspectRatio: 1.2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: tiles.map(_buildTile).toList(),
    );
  }

  Widget _buildTile(_StockTileData tile) {
    final isLow = tile.value < DashboardStockAnalysisService.lowStockThreshold;
    return AppCard(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: tile.borderGradient),
          borderRadius: BorderRadius.circular(AppSizes.lg),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: isLow ? AppColors.danger.withValues(alpha: 0.28) : AppColors.borderGold10,
              blurRadius: AppSizes.md,
              spreadRadius: 0.3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xs / 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColors.cardLuxury.withValues(alpha: 0.95),
                      AppColors.obsidianMidnight.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: AppSizes.xl + AppSizes.sm,
                          width: AppSizes.xl + AppSizes.sm,
                          decoration: BoxDecoration(
                            color: AppColors.cardGlass,
                            borderRadius: BorderRadius.circular(AppSizes.md),
                            border: Border.all(color: AppColors.borderGold10),
                          ),
                          child: Icon(tile.icon, color: AppColors.champagneGold, size: AppSizes.lg),
                        ),
                        const Spacer(),
                        if (isLow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(AppSizes.sm),
                              border: Border.all(color: AppColors.danger.withValues(alpha: 0.65)),
                            ),
                            child: const Text(
                              AppStrings.lowStockBadge,
                              style: TextStyle(
                                color: AppColors.danger,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Text(
                      tile.value.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                    AppSpacing.vXs,
                    Text(
                      tile.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StockTileData {
  const _StockTileData({
    required this.label,
    required this.value,
    required this.icon,
    required this.borderGradient,
  });

  final String label;
  final int value;
  final IconData icon;
  final List<Color> borderGradient;
}
