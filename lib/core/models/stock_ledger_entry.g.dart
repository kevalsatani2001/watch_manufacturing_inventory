// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_ledger_entry.dart';

class StockLedgerEntryAdapter extends TypeAdapter<StockLedgerEntry> {
  @override
  final int typeId = 1;

  @override
  StockLedgerEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockLedgerEntry(
      itemName: fields[0] as String,
      transactionType: fields[1] as String,
      quantity: fields[2] as int,
      createdAt: fields[3] as DateTime,
      reason: fields[4] as String,
      itemTypeCode: fields[5] as int?,
      txTypeCode: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StockLedgerEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.transactionType)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.reason)
      ..writeByte(5)
      ..write(obj.itemTypeCode)
      ..writeByte(6)
      ..write(obj.txTypeCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockLedgerEntryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
