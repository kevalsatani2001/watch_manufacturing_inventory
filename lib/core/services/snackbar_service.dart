import 'package:flutter/material.dart';

class SnackBarService {
  SnackBarService._();
  static final SnackBarService instance = SnackBarService._();

  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  void show({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
