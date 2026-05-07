import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watch_manufacturing_inventory_app/app.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StockLedgerEntryAdapter());
  final secureStorage = const FlutterSecureStorage();
  final encodedKey = await secureStorage.read(key: AppStrings.ledgerEncryptionKeyName);
  List<int> keyBytes;

  if (encodedKey == null) {
    keyBytes = Hive.generateSecureKey();
    await secureStorage.write(
      key: AppStrings.ledgerEncryptionKeyName,
      value: base64UrlEncode(keyBytes),
    );
    final boxExists = await Hive.boxExists(AppStrings.ledgerBoxName);
    if (boxExists) {
      final oldBox = await Hive.openBox<StockLedgerEntry>(AppStrings.ledgerBoxName);
      final oldEntries = oldBox.values.toList();
      await oldBox.close();
      await Hive.deleteBoxFromDisk(AppStrings.ledgerBoxName);
      final encryptedBox = await Hive.openBox<StockLedgerEntry>(
        AppStrings.ledgerBoxName,
        encryptionCipher: HiveAesCipher(keyBytes),
      );
      await encryptedBox.addAll(oldEntries);
    } else {
      await Hive.openBox<StockLedgerEntry>(
        AppStrings.ledgerBoxName,
        encryptionCipher: HiveAesCipher(keyBytes),
      );
    }
  } else {
    keyBytes = base64Url.decode(encodedKey);
    await Hive.openBox<StockLedgerEntry>(
      AppStrings.ledgerBoxName,
      encryptionCipher: HiveAesCipher(keyBytes),
    );
  }
  runApp(const App());
}
