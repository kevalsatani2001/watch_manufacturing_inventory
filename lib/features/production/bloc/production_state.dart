import 'package:equatable/equatable.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/view_state.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class ProductionState extends Equatable {
  const ProductionState({
    required this.viewState,
    required this.quantityInput,
    required this.stock,
    required this.entries,
    required this.errorMessage,
    required this.showSuccess,
    required this.showLowStockWarning,
  });

  factory ProductionState.initial() {
    return const ProductionState(
      viewState: ViewState.idle,
      quantityInput: '1',
      stock: <String, int>{},
      entries: <StockLedgerEntry>[],
      errorMessage: null,
      showSuccess: false,
      showLowStockWarning: false,
    );
  }

  final ViewState viewState;
  final String quantityInput;
  final Map<String, int> stock;
  final List<StockLedgerEntry> entries;
  final String? errorMessage;
  final bool showSuccess;
  final bool showLowStockWarning;

  ProductionState copyWith({
    ViewState? viewState,
    String? quantityInput,
    Map<String, int>? stock,
    List<StockLedgerEntry>? entries,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? showSuccess,
    bool? showLowStockWarning,
  }) {
    return ProductionState(
      viewState: viewState ?? this.viewState,
      quantityInput: quantityInput ?? this.quantityInput,
      stock: stock ?? this.stock,
      entries: entries ?? this.entries,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      showSuccess: showSuccess ?? this.showSuccess,
      showLowStockWarning: showLowStockWarning ?? this.showLowStockWarning,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        viewState,
        quantityInput,
        stock,
        entries,
        errorMessage,
        showSuccess,
        showLowStockWarning,
      ];
}
