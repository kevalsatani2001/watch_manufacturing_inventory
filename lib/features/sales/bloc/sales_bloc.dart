import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_event.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc({required StockLedgerHiveService stockService})
      : _stockService = stockService,
        super(SalesState.initial()) {
    on<SalesLoadRequested>(_onLoadRequested);
    on<SalesQuantityChanged>(_onQuantityChanged);
    on<SalesCreateOrderRequested>(_onCreateOrderRequested);
  }

  final StockLedgerHiveService _stockService;

  Future<void> _onLoadRequested(SalesLoadRequested event, Emitter<SalesState> emit) async {
    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    await _stockService.seedInitialStockIfEmpty();
    emit(
      state.copyWith(
        viewState: ViewState.idle,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(limit: 30),
        showLowStockWarning: false,
      ),
    );
  }

  void _onQuantityChanged(SalesQuantityChanged event, Emitter<SalesState> emit) {
    emit(
      state.copyWith(
        quantityInput: event.value,
        clearErrorMessage: true,
        clearSuccessMessage: true,
        showLowStockWarning: false,
      ),
    );
  }

  Future<void> _onCreateOrderRequested(SalesCreateOrderRequested event, Emitter<SalesState> emit) async {
    final qty = int.tryParse(state.quantityInput.trim());
    if (qty == null || qty <= 0) {
      emit(
        state.copyWith(
          viewState: ViewState.error,
          errorMessage: AppStrings.invalidQuantity,
          showLowStockWarning: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        viewState: ViewState.loading,
        clearErrorMessage: true,
        clearSuccessMessage: true,
        showLowStockWarning: false,
      ),
    );
    final available = _stockService.currentStockOf(AppStrings.watch);
    if (available < qty) {
      emit(
        state.copyWith(
          viewState: ViewState.error,
          errorMessage: _stockService.lowStockMessage(requiredQty: qty, availableQty: available),
          showLowStockWarning: true,
        ),
      );
      return;
    }

    await _stockService.createSalesOrder(quantity: qty);
    emit(
      state.copyWith(
        viewState: ViewState.success,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(limit: 30),
        successMessage: AppStrings.createOrder,
        showLowStockWarning: false,
      ),
    );
  }
}

