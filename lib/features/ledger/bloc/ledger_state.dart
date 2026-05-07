import 'package:equatable/equatable.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/view_state.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class LedgerState extends Equatable {
  const LedgerState({
    required this.viewState,
    required this.entries,
    required this.item,
    required this.tx,
    required this.reason,
    required this.from,
    required this.to,
    required this.hasMore,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.isExportingPdf,
    required this.exportPath,
  });

  factory LedgerState.initial() {
    return const LedgerState(
      viewState: ViewState.idle,
      entries: <StockLedgerEntry>[],
      item: AppStrings.filterAll,
      tx: AppStrings.filterAll,
      reason: AppStrings.filterAll,
      from: null,
      to: null,
      hasMore: true,
      isLoadingMore: false,
      errorMessage: null,
      isExportingPdf: false,
      exportPath: null,
    );
  }

  final ViewState viewState;
  final List<StockLedgerEntry> entries;
  final String item;
  final String tx;
  final String reason;
  final DateTime? from;
  final DateTime? to;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool isExportingPdf;
  final String? exportPath;

  LedgerState copyWith({
    ViewState? viewState,
    List<StockLedgerEntry>? entries,
    String? item,
    String? tx,
    String? reason,
    DateTime? from,
    bool clearFrom = false,
    DateTime? to,
    bool clearTo = false,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isExportingPdf,
    String? exportPath,
    bool clearExportPath = false,
  }) {
    return LedgerState(
      viewState: viewState ?? this.viewState,
      entries: entries ?? this.entries,
      item: item ?? this.item,
      tx: tx ?? this.tx,
      reason: reason ?? this.reason,
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isExportingPdf: isExportingPdf ?? this.isExportingPdf,
      exportPath: clearExportPath ? null : (exportPath ?? this.exportPath),
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[
        viewState,
        entries,
        item,
        tx,
        reason,
        from,
        to,
        hasMore,
        isLoadingMore,
        errorMessage,
        isExportingPdf,
        exportPath,
      ];
}
