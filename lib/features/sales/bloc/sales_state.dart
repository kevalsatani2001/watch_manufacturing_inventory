import 'package:equatable/equatable.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/view_state.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class SalesState extends Equatable {
  const SalesState({
    required this.viewState,
    required this.quantityInput,
    required this.stock,
    required this.entries,
    required this.errorMessage,
    required this.successMessage,
    required this.showLowStockWarning,
  });

  factory SalesState.initial() {
    return const SalesState(
      viewState: ViewState.idle,
      quantityInput: '1',
      stock: <String, int>{},
      entries: <StockLedgerEntry>[],
      errorMessage: null,
      successMessage: null,
      showLowStockWarning: false,
    );
  }

  final ViewState viewState;
  final String quantityInput;
  final Map<String, int> stock;
  final List<StockLedgerEntry> entries;
  final String? errorMessage;
  final String? successMessage;
  final bool showLowStockWarning;

  SalesState copyWith({
    ViewState? viewState,
    String? quantityInput,
    Map<String, int>? stock,
    List<StockLedgerEntry>? entries,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    bool? showLowStockWarning,
  }) {
    return SalesState(
      viewState: viewState ?? this.viewState,
      quantityInput: quantityInput ?? this.quantityInput,
      stock: stock ?? this.stock,
      entries: entries ?? this.entries,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      showLowStockWarning: showLowStockWarning ?? this.showLowStockWarning,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[viewState, quantityInput, stock, entries, errorMessage, successMessage, showLowStockWarning];
}

