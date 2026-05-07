import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_event.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_state.dart';

class ProductionBloc extends Bloc<ProductionEvent, ProductionState> {
  ProductionBloc({required StockLedgerHiveService stockService})
      : _stockService = stockService,
        super(ProductionState.initial()) {
    on<ProductionLoadRequested>(_onLoadRequested);
    on<ProductionQuantityChanged>(_onQuantityChanged);
    on<ProductionAssembleRequested>(_onAssembleRequested);
  }

  final StockLedgerHiveService _stockService;

  Future<void> _onLoadRequested(
    ProductionLoadRequested event,
    Emitter<ProductionState> emit,
  ) async {
    emit(
      state.copyWith(
        viewState: ViewState.loading,
        clearErrorMessage: true,
        showSuccess: false,
        showLowStockWarning: false,
      ),
    );
    await _stockService.seedInitialStockIfEmpty();
    emit(
      state.copyWith(
        viewState: ViewState.idle,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(),
        showLowStockWarning: false,
      ),
    );
  }

  void _onQuantityChanged(ProductionQuantityChanged event, Emitter<ProductionState> emit) {
    emit(state.copyWith(quantityInput: event.value, showSuccess: false, showLowStockWarning: false));
  }

  Future<void> _onAssembleRequested(
    ProductionAssembleRequested event,
    Emitter<ProductionState> emit,
  ) async {
    final quantity = int.tryParse(state.quantityInput.trim());
    if (quantity == null || quantity <= 0) {
      emit(
        state.copyWith(
          viewState: ViewState.error,
          errorMessage: AppStrings.invalidQuantity,
          showSuccess: false,
          showLowStockWarning: false,
        ),
      );
      return;
    }

    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, showSuccess: false));
    final maxPossible = _stockService.maxAssemblable();
    if (maxPossible <= 0) {
      emit(
        state.copyWith(
          viewState: ViewState.error,
          showLowStockWarning: true,
          errorMessage: AppStrings.lowStockMessage,
        ),
      );
      return;
    }

    final produced = await _stockService.assembleWatchesPartialAllowed(requestedQuantity: quantity);
    await HapticFeedback.mediumImpact();
    emit(
      state.copyWith(
        viewState: ViewState.success,
        errorMessage: produced < quantity
            ? AppStrings.partialProductionMessage
                .replaceAll('{requested}', quantity.toString())
                .replaceAll('{produced}', produced.toString())
            : null,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(),
        showSuccess: true,
        showLowStockWarning: false,
      ),
    );
  }
}
