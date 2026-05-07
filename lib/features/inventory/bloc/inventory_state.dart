import 'package:equatable/equatable.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/enums/view_state.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class InventoryState extends Equatable {
  const InventoryState({
    required this.viewState,
    required this.items,
    required this.reasons,
    required this.selectedItem,
    required this.filterItem,
    required this.filterTx,
    required this.filterFrom,
    required this.filterTo,
    required this.filterReason,
    required this.quantityInput,
    required this.stock,
    required this.entries,
    required this.filteredEntries,
    required this.errorMessage,
    required this.successMessage,
  });

  factory InventoryState.initial() {
    return const InventoryState(
      viewState: ViewState.idle,
      items: <String>[],
      reasons: <String>[],
      selectedItem: null,
      filterItem: AppStrings.filterAll,
      filterTx: AppStrings.filterAll,
      filterFrom: null,
      filterTo: null,
      filterReason: AppStrings.filterAll,
      quantityInput: '',
      stock: <String, int>{},
      entries: <StockLedgerEntry>[],
      filteredEntries: <StockLedgerEntry>[],
      errorMessage: null,
      successMessage: null,
    );
  }

  final ViewState viewState;
  final List<String> items;
  final List<String> reasons;
  final String? selectedItem;
  final String filterItem;
  final String filterTx;
  final DateTime? filterFrom;
  final DateTime? filterTo;
  final String filterReason;
  final String quantityInput;
  final Map<String, int> stock;
  final List<StockLedgerEntry> entries;
  final List<StockLedgerEntry> filteredEntries;
  final String? errorMessage;
  final String? successMessage;

  InventoryState copyWith({
    ViewState? viewState,
    List<String>? items,
    List<String>? reasons,
    String? selectedItem,
    String? filterItem,
    String? filterTx,
    DateTime? filterFrom,
    bool clearFilterFrom = false,
    DateTime? filterTo,
    bool clearFilterTo = false,
    String? filterReason,
    String? quantityInput,
    Map<String, int>? stock,
    List<StockLedgerEntry>? entries,
    List<StockLedgerEntry>? filteredEntries,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return InventoryState(
      viewState: viewState ?? this.viewState,
      items: items ?? this.items,
      reasons: reasons ?? this.reasons,
      selectedItem: selectedItem ?? this.selectedItem,
      filterItem: filterItem ?? this.filterItem,
      filterTx: filterTx ?? this.filterTx,
      filterFrom: clearFilterFrom ? null : (filterFrom ?? this.filterFrom),
      filterTo: clearFilterTo ? null : (filterTo ?? this.filterTo),
      filterReason: filterReason ?? this.filterReason,
      quantityInput: quantityInput ?? this.quantityInput,
      stock: stock ?? this.stock,
      entries: entries ?? this.entries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[
        viewState,
        items,
        reasons,
        selectedItem,
        filterItem,
        filterTx,
        filterFrom,
        filterTo,
        filterReason,
        quantityInput,
        stock,
        entries,
        filteredEntries,
        errorMessage,
        successMessage,
      ];
}

