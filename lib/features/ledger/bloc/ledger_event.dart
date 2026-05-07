import 'package:equatable/equatable.dart';

sealed class LedgerEvent extends Equatable {
  const LedgerEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class LedgerLoadRequested extends LedgerEvent {
  const LedgerLoadRequested();
}

final class LedgerLoadMoreRequested extends LedgerEvent {
  const LedgerLoadMoreRequested();
}

final class LedgerFiltersApplied extends LedgerEvent {
  const LedgerFiltersApplied({
    required this.item,
    required this.tx,
    required this.reason,
    required this.from,
    required this.to,
  });

  final String item;
  final String tx;
  final String reason;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => <Object?>[item, tx, reason, from, to];
}

final class LedgerPdfExportRequested extends LedgerEvent {
  const LedgerPdfExportRequested();
}
