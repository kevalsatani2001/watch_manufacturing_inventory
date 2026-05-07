import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';

enum ItemType {
  dial(0, AppStrings.dial),
  watchCase(1, AppStrings.watchCase),
  machine(2, AppStrings.machine),
  watch(3, AppStrings.watch);

  const ItemType(this.code, this.label);

  final int code;
  final String label;

  static ItemType? tryFromCode(int? code) {
    if (code == null) return null;
    for (final v in ItemType.values) {
      if (v.code == code) return v;
    }
    return null;
  }

  static ItemType? tryFromLegacyName(String? itemName) {
    if (itemName == null) return null;
    for (final v in ItemType.values) {
      if (v.label == itemName) return v;
    }
    return null;
  }
}

enum LedgerTxType {
  inTx(0, 'IN'),
  outTx(1, 'OUT');

  const LedgerTxType(this.code, this.legacy);

  final int code;
  final String legacy;

  static LedgerTxType? tryFromCode(int? code) {
    if (code == null) return null;
    for (final v in LedgerTxType.values) {
      if (v.code == code) return v;
    }
    return null;
  }

  static LedgerTxType? tryFromLegacy(String? legacy) {
    if (legacy == null) return null;
    for (final v in LedgerTxType.values) {
      if (v.legacy == legacy) return v;
    }
    return null;
  }
}

