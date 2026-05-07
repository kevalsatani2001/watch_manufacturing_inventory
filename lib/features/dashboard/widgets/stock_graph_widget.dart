import 'package:fl_chart/fl_chart.dart';
import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/dashboard/services/dashboard_stock_analysis_service.dart';

class StockGraphWidget extends StatelessWidget {
  const StockGraphWidget({
    super.key,
    required this.points,
  });

  final List<StockTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.cardGlass,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: const BorderSide(color: AppColors.borderGlass),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.stockTrendTitle,
              style: ResponsiveTypography.luxuryHeading(context).copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            AppSpacing.vSm,
            Row(
              children: const <Widget>[
                _LegendChip(
                  label: AppStrings.legendIn,
                  color: AppColors.champagneGold,
                ),
                SizedBox(width: AppSizes.sm),
                _LegendChip(
                  label: AppStrings.legendOut,
                  color: AppColors.trendBlue,
                ),
              ],
            ),
            AppSpacing.vMd,
            SizedBox(
              height: AppSizes.xxl * 4,
              child: LineChart(_chartData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _chartData() {
    final watchSpots = <FlSpot>[];
    final partsSpots = <FlSpot>[];
    double minY = 0;
    double maxY = 0;

    for (int i = 0; i < points.length; i++) {
      final inQty = points[i].inQty.toDouble();
      final outQty = points[i].outQty.toDouble();
      watchSpots.add(FlSpot(i.toDouble(), inQty));
      partsSpots.add(FlSpot(i.toDouble(), outQty));
      minY = [minY, inQty, outQty].reduce((a, b) => a < b ? a : b);
      maxY = [maxY, inQty, outQty].reduce((a, b) => a > b ? a : b);
    }

    if (minY < 0) minY = 0;
    if (minY == maxY) maxY = maxY + 1;

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      minY: 0,
      maxY: maxY + 1,
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(
          color: AppColors.borderGold10,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppColors.borderGlass),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: AppSizes.xl + AppSizes.xs,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              if (index < 0 || index >= points.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: AppSizes.xs),
                child: Text(
                  _dateLabel(points[index].date),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: watchSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.champagneGold,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.champagneGold.withValues(alpha: 0.32),
                AppColors.champagneGold.withValues(alpha: 0.02),
              ],
            ),
          ),
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: partsSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.trendBlue,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.trendBlue.withValues(alpha: 0.22),
                AppColors.trendBlue.withValues(alpha: 0.02),
              ],
            ),
          ),
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  String _dateLabel(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.sm),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: AppSizes.sm,
            width: AppSizes.sm,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
