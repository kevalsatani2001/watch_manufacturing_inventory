import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';
import 'package:watch_manufacturing_inventory_app/core/services/stock_ledger_hive_service.dart';

class DashboardStockAnalysisService {
  const DashboardStockAnalysisService._();

  static const int lowStockThreshold = 10;

  static Map<String, int> currentStock() {
    return StockLedgerHiveService.instance.calculateCurrentStock();
  }

  static List<StockTrendPoint> last7DaysTrend(List<StockLedgerEntry> entries) {
    final now = DateTime.now();
    final buckets = <DateTime, StockTrendPoint>{};

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      buckets[day] = StockTrendPoint(date: day, inQty: 0, outQty: 0);
    }

    for (final entry in entries) {
      if (entry.reason == AppStrings.reasonInitialStock) continue;
      final day = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      if (!buckets.containsKey(day)) continue;
      final point = buckets[day]!;
      if (entry.transactionType == StockLedgerHiveService.inTransaction) {
        buckets[day] = point.copyWith(inQty: point.inQty + entry.quantity);
      } else if (entry.transactionType == StockLedgerHiveService.outTransaction) {
        buckets[day] = point.copyWith(outQty: point.outQty + entry.quantity);
      }
    }

    return buckets.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }
}

class StockTrendPoint {
  const StockTrendPoint({
    required this.date,
    required this.inQty,
    required this.outQty,
  });

  final DateTime date;
  final int inQty;
  final int outQty;

  StockTrendPoint copyWith({
    int? inQty,
    int? outQty,
  }) {
    return StockTrendPoint(
      date: date,
      inQty: inQty ?? this.inQty,
      outQty: outQty ?? this.outQty,
    );
  }
}
