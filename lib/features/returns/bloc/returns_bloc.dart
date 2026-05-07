import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/features/returns/bloc/returns_event.dart';
import 'package:watch_manufacturing_inventory_app/features/returns/bloc/returns_state.dart';

class ReturnsBloc extends Bloc<ReturnsEvent, ReturnsState> {
  ReturnsBloc({required StockLedgerHiveService stockService})
      : _stockService = stockService,
        super(ReturnsState.initial()) {
    on<ReturnsLoadRequested>(_onLoadRequested);
    on<ReturnsQuantityChanged>(_onQuantityChanged);
    on<ReturnsAddBackRequested>(_onAddBackRequested);
    on<ReturnsDismantleRequested>(_onDismantleRequested);
  }

  final StockLedgerHiveService _stockService;

  Future<void> _onLoadRequested(ReturnsLoadRequested event, Emitter<ReturnsState> emit) async {
    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    await _stockService.seedInitialStockIfEmpty();
    emit(
      state.copyWith(
        viewState: ViewState.idle,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(limit: 30),
      ),
    );
  }

  void _onQuantityChanged(ReturnsQuantityChanged event, Emitter<ReturnsState> emit) {
    emit(state.copyWith(quantityInput: event.value, clearErrorMessage: true, clearSuccessMessage: true));
  }

  Future<void> _onAddBackRequested(ReturnsAddBackRequested event, Emitter<ReturnsState> emit) async {
    final qty = int.tryParse(state.quantityInput.trim());
    if (qty == null || qty <= 0) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: AppStrings.invalidQuantity));
      return;
    }

    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    await _stockService.returnFinishedWatch(quantity: qty);
    emit(
      state.copyWith(
        viewState: ViewState.success,
        stock: _stockService.calculateCurrentStock(),
        entries: _stockService.recentEntries(limit: 30),
        successMessage: AppStrings.returnWatch,
      ),
    );
  }

  Future<void> _onDismantleRequested(ReturnsDismantleRequested event, Emitter<ReturnsState> emit) async {
    final qty = int.tryParse(state.quantityInput.trim());
    if (qty == null || qty <= 0) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: AppStrings.invalidQuantity));
      return;
    }

    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, clearSuccessMessage: true));
    try {
      await _stockService.dismantleReturnedWatch(quantity: qty);
      emit(
        state.copyWith(
          viewState: ViewState.success,
          stock: _stockService.calculateCurrentStock(),
          entries: _stockService.recentEntries(limit: 30),
          successMessage: AppStrings.dismantleWatch,
        ),
      );
    } catch (e) {
      emit(state.copyWith(viewState: ViewState.error, errorMessage: e.toString()));
    }
  }
}

