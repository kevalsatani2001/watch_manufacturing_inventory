import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_event.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({required StockLedgerHiveService stockService})
      : _stockService = stockService,
        super(InventoryState.initial()) {
    on<InventoryLoadRequested>(_onLoadRequested);
    on<InventoryItemChanged>(_onItemChanged);
    on<InventoryQuantityChanged>(_onQuantityChanged);
    on<InventoryStockInRequested>(_onStockInRequested);
    on<InventoryStockOutRequested>(_onStockOutRequested);
    on<InventoryFilterItemChanged>(_onFilterItemChanged);
    on<InventoryFilterTxChanged>(_onFilterTxChanged);
    on<InventoryFilterFromDateChanged>(_onFilterFromChanged);
    on<InventoryFilterToDateChanged>(_onFilterToChanged);
    on<InventoryFilterReasonChanged>(_onFilterReasonChanged);
    on<InventoryClearFiltersRequested>(_onClearFiltersRequested);
  }

  final StockLedgerHiveService _stockService;

  Future<void> _onLoadRequested(InventoryLoadRequested event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    await _stockService.seedInitialStockIfEmpty();
    final items = _stockService.supportedItems();
    final reasons = <String>[
      AppStrings.filterAll,
      AppStrings.reasonInitialStock,
      AppStrings.reasonPurchase,
      AppStrings.reasonManualStockOut,
      AppStrings.reasonAssemblyComponentsOut,
      AppStrings.reasonProductionOutput,
      AppStrings.reasonSale,
      AppStrings.reasonReturn,
      AppStrings.reasonDismantle,
    ];
    final entries = _stockService.recentEntries(limit: 200);
    emit(
      state.copyWith(
        viewState: ViewState.idle,
        items: <String>[AppStrings.filterAll, ...items],
        reasons: reasons,
        selectedItem: state.selectedItem ?? items.first,
        stock: _stockService.calculateCurrentStock(),
        entries: entries,
        filteredEntries: _applyFilters(
          entries: entries,
          filterItem: state.filterItem,
          filterTx: state.filterTx,
          from: state.filterFrom,
          to: state.filterTo,
          filterReason: state.filterReason,
        ),
      ),
    );
  }

  void _onItemChanged(InventoryItemChanged event, Emitter<InventoryState> emit) {
    final item = event.itemName;
    if (item == null || item == AppStrings.filterAll) {
      emit(state.copyWith(errorMessage: AppStrings.invalidItemSelection, clearSuccessMessage: true));
      return;
    }
    emit(state.copyWith(selectedItem: item, clearErrorMessage: true, clearSuccessMessage: true));
  }

  void _onQuantityChanged(InventoryQuantityChanged event, Emitter<InventoryState> emit) {
    emit(state.copyWith(quantityInput: event.value, clearErrorMessage: true, clearSuccessMessage: true));
  }

  Future<void> _onStockInRequested(InventoryStockInRequested event, Emitter<InventoryState> emit) async {
    final item = state.selectedItem;
    final qty = int.tryParse(state.quantityInput.trim());
    if (item == null || qty == null || qty <= 0) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: AppStrings.invalidQuantity));
      return;
    }

    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    await _stockService.stockIn(itemName: item, quantity: qty, reason: AppStrings.reasonPurchase);
    final entries = _stockService.recentEntries(limit: 200);
    emit(
      state.copyWith(
        viewState: ViewState.success,
        stock: _stockService.calculateCurrentStock(),
        entries: entries,
        filteredEntries: _applyFilters(
          entries: entries,
          filterItem: state.filterItem,
          filterTx: state.filterTx,
          from: state.filterFrom,
          to: state.filterTo,
          filterReason: state.filterReason,
        ),
        quantityInput: '',
        successMessage: AppStrings.stockIn,
      ),
    );
  }

  Future<void> _onStockOutRequested(InventoryStockOutRequested event, Emitter<InventoryState> emit) async {
    final item = state.selectedItem;
    final qty = int.tryParse(state.quantityInput.trim());
    if (item == null || qty == null || qty <= 0) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: AppStrings.invalidQuantity));
      return;
    }

    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    try {
      await _stockService.stockOut(itemName: item, quantity: qty, reason: AppStrings.reasonManualStockOut);
      final entries = _stockService.recentEntries(limit: 200);
      emit(
        state.copyWith(
          viewState: ViewState.success,
          stock: _stockService.calculateCurrentStock(),
          entries: entries,
          filteredEntries: _applyFilters(
            entries: entries,
            filterItem: state.filterItem,
            filterTx: state.filterTx,
            from: state.filterFrom,
            to: state.filterTo,
            filterReason: state.filterReason,
          ),
          quantityInput: '',
          successMessage: AppStrings.stockOut,
        ),
      );
    } catch (e) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: _safeError(e)));
    }
  }

  void _onFilterItemChanged(InventoryFilterItemChanged event, Emitter<InventoryState> emit) {
    final filterItem = event.itemName ?? AppStrings.filterAll;
    emit(
      state.copyWith(
        filterItem: filterItem,
        filteredEntries: _applyFilters(
          entries: state.entries,
          filterItem: filterItem,
          filterTx: state.filterTx,
          from: state.filterFrom,
          to: state.filterTo,
          filterReason: state.filterReason,
        ),
      ),
    );
  }

  void _onFilterTxChanged(InventoryFilterTxChanged event, Emitter<InventoryState> emit) {
    final allowedReasons = _reasonsForTx(event.tx);
    final nextReason = allowedReasons.contains(state.filterReason) ? state.filterReason : AppStrings.filterAll;
    emit(
      state.copyWith(
        filterTx: event.tx,
        filterReason: nextReason,
        filteredEntries: _applyFilters(
          entries: state.entries,
          filterItem: state.filterItem,
          filterTx: event.tx,
          from: state.filterFrom,
          to: state.filterTo,
          filterReason: nextReason,
        ),
      ),
    );
  }

  void _onFilterFromChanged(InventoryFilterFromDateChanged event, Emitter<InventoryState> emit) {
    emit(
      state.copyWith(
        filterFrom: event.from,
        filteredEntries: _applyFilters(
          entries: state.entries,
          filterItem: state.filterItem,
          filterTx: state.filterTx,
          from: event.from,
          to: state.filterTo,
          filterReason: state.filterReason,
        ),
      ),
    );
  }

  void _onFilterToChanged(InventoryFilterToDateChanged event, Emitter<InventoryState> emit) {
    emit(
      state.copyWith(
        filterTo: event.to,
        filteredEntries: _applyFilters(
          entries: state.entries,
          filterItem: state.filterItem,
          filterTx: state.filterTx,
          from: state.filterFrom,
          to: event.to,
          filterReason: state.filterReason,
        ),
      ),
    );
  }

  void _onFilterReasonChanged(InventoryFilterReasonChanged event, Emitter<InventoryState> emit) {
    emit(
      state.copyWith(
        filterReason: event.reason,
        filteredEntries: _applyFilters(
          entries: state.entries,
          filterItem: state.filterItem,
          filterTx: state.filterTx,
          from: state.filterFrom,
          to: state.filterTo,
          filterReason: event.reason,
        ),
      ),
    );
  }

  void _onClearFiltersRequested(InventoryClearFiltersRequested event, Emitter<InventoryState> emit) {
    emit(
      state.copyWith(
        filterItem: AppStrings.filterAll,
        filterTx: AppStrings.filterAll,
        clearFilterFrom: true,
        clearFilterTo: true,
        filterReason: AppStrings.filterAll,
        filteredEntries: state.entries,
      ),
    );
  }

  List<StockLedgerEntry> _applyFilters({
    required List<StockLedgerEntry> entries,
    required String filterItem,
    required String filterTx,
    required DateTime? from,
    required DateTime? to,
    required String filterReason,
  }) {
    Iterable<StockLedgerEntry> result = entries;
    if (filterItem != AppStrings.filterAll) {
      result = result.where((e) => e.itemName == filterItem);
    }
    if (filterTx != AppStrings.filterAll) {
      result = result.where((e) => e.transactionType == filterTx);
    }
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      result = result.where((e) => !e.createdAt.isBefore(start));
    }
    if (to != null) {
      final endExclusive = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
      result = result.where((e) => e.createdAt.isBefore(endExclusive));
    }
    if (filterReason != AppStrings.filterAll) {
      result = result.where((e) => e.reason == filterReason);
    }
    return result.toList();
  }

  List<String> _reasonsForTx(String tx) {
    if (tx == 'IN') {
      return <String>[
        AppStrings.filterAll,
        AppStrings.reasonInitialStock,
        AppStrings.reasonPurchase,
        AppStrings.reasonProductionOutput,
        AppStrings.reasonReturn,
        AppStrings.reasonDismantle,
      ];
    }
    if (tx == 'OUT') {
      return <String>[
        AppStrings.filterAll,
        AppStrings.reasonManualStockOut,
        AppStrings.reasonAssemblyComponentsOut,
        AppStrings.reasonSale,
        AppStrings.reasonDismantle,
      ];
    }
    return <String>[
      AppStrings.filterAll,
      AppStrings.reasonInitialStock,
      AppStrings.reasonPurchase,
      AppStrings.reasonManualStockOut,
      AppStrings.reasonAssemblyComponentsOut,
      AppStrings.reasonProductionOutput,
      AppStrings.reasonSale,
      AppStrings.reasonReturn,
      AppStrings.reasonDismantle,
    ];
  }

  String _safeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Bad state: ')) {
      return message.replaceFirst('Bad state: ', '');
    }
    if (message.startsWith('Invalid argument')) {
      return AppStrings.invalidItemSelection;
    }
    return message;
  }
}

