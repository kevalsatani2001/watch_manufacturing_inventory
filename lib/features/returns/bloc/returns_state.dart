import 'package:equatable/equatable.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/view_state.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class ReturnsState extends Equatable {
  const ReturnsState({
    required this.viewState,
    required this.quantityInput,
    required this.stock,
    required this.entries,
    required this.errorMessage,
    required this.successMessage,
  });

  factory ReturnsState.initial() {
    return const ReturnsState(
      viewState: ViewState.idle,
      quantityInput: '1',
      stock: <String, int>{},
      entries: <StockLedgerEntry>[],
      errorMessage: null,
      successMessage: null,
    );
  }

  final ViewState viewState;
  final String quantityInput;
  final Map<String, int> stock;
  final List<StockLedgerEntry> entries;
  final String? errorMessage;
  final String? successMessage;

  ReturnsState copyWith({
    ViewState? viewState,
    String? quantityInput,
    Map<String, int>? stock,
    List<StockLedgerEntry>? entries,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return ReturnsState(
      viewState: viewState ?? this.viewState,
      quantityInput: quantityInput ?? this.quantityInput,
      stock: stock ?? this.stock,
      entries: entries ?? this.entries,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[viewState, quantityInput, stock, entries, errorMessage, successMessage];
}

