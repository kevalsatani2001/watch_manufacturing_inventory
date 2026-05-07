import 'package:hive/hive.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/inventory_enums.dart';

part 'stock_ledger_entry.g.dart';

@HiveType(typeId: 1)
class StockLedgerEntry extends HiveObject {
  StockLedgerEntry({
    required this.itemName,
    required this.transactionType,
    required this.quantity,
    required this.createdAt,
    required this.reason,
    this.itemTypeCode,
    this.txTypeCode,
  });

  @HiveField(0)
  final String itemName;

  @HiveField(1)
  final String transactionType;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String reason;

  // Backward compatible enum migration:
  // - Old entries: only itemName/transactionType exist.
  // - New entries: we write both legacy strings + enum codes.
  @HiveField(5)
  final int? itemTypeCode;

  @HiveField(6)
  final int? txTypeCode;

  ItemType? get itemType => ItemType.tryFromCode(itemTypeCode) ?? ItemType.tryFromLegacyName(itemName);

  LedgerTxType? get txType => LedgerTxType.tryFromCode(txTypeCode) ?? LedgerTxType.tryFromLegacy(transactionType);
}
