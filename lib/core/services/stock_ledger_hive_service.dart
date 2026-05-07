import 'package:hive/hive.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/inventory_enums.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class StockLedgerHiveService {
  StockLedgerHiveService._();

  static final StockLedgerHiveService instance = StockLedgerHiveService._();

  static const String inTransaction = 'IN';
  static const String outTransaction = 'OUT';

  Box<StockLedgerEntry> get _ledgerBox => Hive.box<StockLedgerEntry>(AppStrings.ledgerBoxName);

  Future<void> addEntry({
    required String itemName,
    required String transactionType,
    required int quantity,
    required String reason,
  }) async {
    final itemType = ItemType.tryFromLegacyName(itemName);
    final txType = LedgerTxType.tryFromLegacy(transactionType);
    await _ledgerBox.add(
      StockLedgerEntry(
        itemName: itemName,
        transactionType: transactionType,
        quantity: quantity,
        createdAt: DateTime.now(),
        reason: reason,
        itemTypeCode: itemType?.code,
        txTypeCode: txType?.code,
      ),
    );
  }

  String lowStockMessage({required int requiredQty, required int availableQty}) {
    return AppStrings.lowStockWithNumbers
        .replaceAll('{required}', requiredQty.toString())
        .replaceAll('{available}', availableQty.toString());
  }

  int currentStockOf(String itemName) {
    final stock = calculateCurrentStock();
    return stock[itemName] ?? 0;
  }

  List<String> supportedItems() {
    return <String>[
      AppStrings.dial,
      AppStrings.watchCase,
      AppStrings.machine,
      AppStrings.watch,
    ];
  }

  Future<void> stockIn({
    required String itemName,
    required int quantity,
    required String reason,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity');
    }
    if (!supportedItems().contains(itemName)) {
      throw ArgumentError.value(itemName, 'itemName', AppStrings.invalidItemSelection);
    }
    await addEntry(
      itemName: itemName,
      transactionType: inTransaction,
      quantity: quantity,
      reason: reason,
    );
  }

  Future<void> stockOut({
    required String itemName,
    required int quantity,
    required String reason,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity');
    }
    if (!supportedItems().contains(itemName)) {
      throw ArgumentError.value(itemName, 'itemName', AppStrings.invalidItemSelection);
    }
    final available = currentStockOf(itemName);
    if (available < quantity) {
      throw StateError(lowStockMessage(requiredQty: quantity, availableQty: available));
    }
    await addEntry(
      itemName: itemName,
      transactionType: outTransaction,
      quantity: quantity,
      reason: reason,
    );
  }

  int maxAssemblable() {
    final stock = calculateCurrentStock();
    final dials = stock[AppStrings.dial] ?? 0;
    final cases = stock[AppStrings.watchCase] ?? 0;
    final machines = stock[AppStrings.machine] ?? 0;
    final min1 = dials < cases ? dials : cases;
    return min1 < machines ? min1 : machines;
  }

  Future<void> seedInitialStockIfEmpty() async {
    if (_ledgerBox.isNotEmpty) {
      return;
    }

    await addEntry(
      itemName: AppStrings.dial,
      transactionType: inTransaction,
      quantity: 20,
      reason: AppStrings.reasonInitialStock,
    );
    await addEntry(
      itemName: AppStrings.watchCase,
      transactionType: inTransaction,
      quantity: 20,
      reason: AppStrings.reasonInitialStock,
    );
    await addEntry(
      itemName: AppStrings.machine,
      transactionType: inTransaction,
      quantity: 20,
      reason: AppStrings.reasonInitialStock,
    );
  }

  Map<String, int> calculateCurrentStock() {
    final stock = <String, int>{
      AppStrings.dial: 0,
      AppStrings.watchCase: 0,
      AppStrings.machine: 0,
      AppStrings.watch: 0,
    };

    for (final entry in _ledgerBox.values) {
      if (!stock.containsKey(entry.itemName)) {
        continue;
      }
      final multiplier = entry.transactionType == inTransaction ? 1 : -1;
      stock.update(
        entry.itemName,
        (value) => value + (entry.quantity * multiplier),
      );
    }

    return stock;
  }

  bool canAssemble({required int quantity}) {
    final stock = calculateCurrentStock();
    return (stock[AppStrings.dial] ?? 0) >= quantity &&
        (stock[AppStrings.watchCase] ?? 0) >= quantity &&
        (stock[AppStrings.machine] ?? 0) >= quantity;
  }

  Future<void> assembleWatches({required int quantity}) async {
    if (!canAssemble(quantity: quantity)) {
      throw StateError(AppStrings.lowStockMessage);
    }
    final now = DateTime.now();
    final entries = <StockLedgerEntry>[
      StockLedgerEntry(
        itemName: AppStrings.dial,
        transactionType: outTransaction,
        quantity: quantity,
        createdAt: now,
        reason: AppStrings.reasonAssemblyComponentsOut,
        itemTypeCode: ItemType.dial.code,
        txTypeCode: LedgerTxType.outTx.code,
      ),
      StockLedgerEntry(
        itemName: AppStrings.watchCase,
        transactionType: outTransaction,
        quantity: quantity,
        createdAt: now,
        reason: AppStrings.reasonAssemblyComponentsOut,
        itemTypeCode: ItemType.watchCase.code,
        txTypeCode: LedgerTxType.outTx.code,
      ),
      StockLedgerEntry(
        itemName: AppStrings.machine,
        transactionType: outTransaction,
        quantity: quantity,
        createdAt: now,
        reason: AppStrings.reasonAssemblyComponentsOut,
        itemTypeCode: ItemType.machine.code,
        txTypeCode: LedgerTxType.outTx.code,
      ),
      StockLedgerEntry(
        itemName: AppStrings.watch,
        transactionType: inTransaction,
        quantity: quantity,
        createdAt: now,
        reason: AppStrings.reasonProductionOutput,
        itemTypeCode: ItemType.watch.code,
        txTypeCode: LedgerTxType.inTx.code,
      ),
    ];
    await _ledgerBox.addAll(entries);
  }

  Future<int> assembleWatchesPartialAllowed({required int requestedQuantity}) async {
    final allowed = maxAssemblable();
    if (allowed <= 0) {
      throw StateError(AppStrings.lowStockMessage);
    }
    final actual = requestedQuantity <= allowed ? requestedQuantity : allowed;
    await assembleWatches(quantity: actual);
    return actual;
  }

  Future<void> createSalesOrder({required int quantity}) async {
    await stockOut(itemName: AppStrings.watch, quantity: quantity, reason: AppStrings.reasonSale);
  }

  Future<void> returnFinishedWatch({required int quantity}) async {
    await stockIn(itemName: AppStrings.watch, quantity: quantity, reason: AppStrings.reasonReturn);
  }

  Future<void> dismantleReturnedWatch({required int quantity}) async {
    final availableWatches = currentStockOf(AppStrings.watch);
    if (availableWatches < quantity) {
      throw StateError(AppStrings.insufficientFinishedWatch);
    }
    await stockOut(itemName: AppStrings.watch, quantity: quantity, reason: AppStrings.reasonDismantle);
    await stockIn(itemName: AppStrings.dial, quantity: quantity, reason: AppStrings.reasonDismantle);
    await stockIn(itemName: AppStrings.watchCase, quantity: quantity, reason: AppStrings.reasonDismantle);
    await stockIn(itemName: AppStrings.machine, quantity: quantity, reason: AppStrings.reasonDismantle);
  }

  List<StockLedgerEntry> recentEntries({
    int limit = 15,
    bool includeInitialSeedEntries = true,
  }) {
    final values = _ledgerBox.values
        .where(
          (entry) => includeInitialSeedEntries || entry.reason != AppStrings.reasonInitialStock,
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (values.length <= limit) {
      return values;
    }
    return values.take(limit).toList();
  }

  List<StockLedgerEntry> queryEntries({
    String item = AppStrings.filterAll,
    String tx = AppStrings.filterAll,
    String reason = AppStrings.filterAll,
    DateTime? from,
    DateTime? to,
    int offset = 0,
    int limit = 20,
  }) {
    final sorted = _ledgerBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    Iterable<StockLedgerEntry> result = sorted;
    if (item != AppStrings.filterAll) result = result.where((e) => e.itemName == item);
    if (tx != AppStrings.filterAll) result = result.where((e) => e.transactionType == tx);
    if (reason != AppStrings.filterAll) result = result.where((e) => e.reason == reason);
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      result = result.where((e) => !e.createdAt.isBefore(start));
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
      result = result.where((e) => e.createdAt.isBefore(end));
    }
    final filtered = result.toList();
    if (offset >= filtered.length) return <StockLedgerEntry>[];
    final end = (offset + limit) > filtered.length ? filtered.length : (offset + limit);
    return filtered.sublist(offset, end);
  }
}
