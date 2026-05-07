import 'package:watch_manufacturing_inventory_app/core/common/app_imports.dart';
import 'package:watch_manufacturing_inventory_app/core/services/ledger_pdf_service.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_event.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  LedgerBloc({
    required StockLedgerHiveService stockService,
    required LedgerPdfService pdfService,
  })
      : _stockService = stockService,
        _pdfService = pdfService,
        super(LedgerState.initial()) {
    on<LedgerLoadRequested>(_onLoadRequested);
    on<LedgerLoadMoreRequested>(_onLoadMoreRequested);
    on<LedgerFiltersApplied>(_onFiltersApplied);
    on<LedgerPdfExportRequested>(_onPdfExportRequested);
  }

  final StockLedgerHiveService _stockService;
  final LedgerPdfService _pdfService;
  static const int _pageSize = 20;

  Future<void> _onLoadRequested(LedgerLoadRequested event, Emitter<LedgerState> emit) async {
    emit(state.copyWith(viewState: ViewState.loading, clearErrorMessage: true, hasMore: true));
    final data = _stockService.queryEntries(
      item: state.item,
      tx: state.tx,
      reason: state.reason,
      from: state.from,
      to: state.to,
      offset: 0,
      limit: _pageSize,
    );
    emit(
      state.copyWith(
        viewState: ViewState.idle,
        entries: data,
        hasMore: data.length == _pageSize,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> _onLoadMoreRequested(LedgerLoadMoreRequested event, Emitter<LedgerState> emit) async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    final more = _stockService.queryEntries(
      item: state.item,
      tx: state.tx,
      reason: state.reason,
      from: state.from,
      to: state.to,
      offset: state.entries.length,
      limit: _pageSize,
    );
    emit(
      state.copyWith(
        entries: <StockLedgerEntry>[...state.entries, ...more],
        hasMore: more.length == _pageSize,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> _onFiltersApplied(LedgerFiltersApplied event, Emitter<LedgerState> emit) async {
    emit(
      state.copyWith(
        item: event.item,
        tx: event.tx,
        reason: event.reason,
        from: event.from,
        clearFrom: event.from == null,
        to: event.to,
        clearTo: event.to == null,
      ),
    );
    add(const LedgerLoadRequested());
  }

  Future<void> _onPdfExportRequested(
    LedgerPdfExportRequested event,
    Emitter<LedgerState> emit,
  ) async {
    if (state.isExportingPdf) return;
    emit(
      state.copyWith(
        isExportingPdf: true,
        clearErrorMessage: true,
        clearExportPath: true,
      ),
    );
    try {
      final allFilteredEntries = _stockService.queryEntries(
        item: state.item,
        tx: state.tx,
        reason: state.reason,
        from: state.from,
        to: state.to,
        offset: 0,
        limit: 100000,
      );
      final filterSummary = _buildFilterSummary(state);
      final path = await _pdfService.exportLedgerPdf(
        entries: allFilteredEntries,
        filterSummary: filterSummary,
      );
      emit(
        state.copyWith(
          isExportingPdf: false,
          exportPath: path,
          errorMessage: AppStrings.pdfGeneratedSuccess,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isExportingPdf: false,
          errorMessage: AppStrings.pdfGeneratedError,
        ),
      );
    }
  }

  String _buildFilterSummary(LedgerState state) {
    final from = state.from == null ? AppStrings.allDates : _formatDate(state.from!);
    final to = state.to == null ? AppStrings.allDates : _formatDate(state.to!);
    final type = state.tx == AppStrings.filterAll ? AppStrings.allTypes : state.tx;
    final reason = state.reason == AppStrings.filterAll ? AppStrings.allReasons : state.reason;
    return '${AppStrings.filterFrom}: $from, ${AppStrings.filterTo}: $to, '
        '${AppStrings.filterType}: $type, ${AppStrings.filterReason}: $reason';
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}
