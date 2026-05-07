class AppStrings {
  const AppStrings._();

  static const String appTitle = 'WatchFlow Pro';
  static const String productionTitle = 'Production Assembly';
  static const String productionSubtitle = '1 Watch = 1 Dial + 1 Case + 1 Machine';
  static const String quantityLabel = 'Assembly Quantity';
  static const String quantityHint = 'Enter number of watches';
  static const String assembleNow = 'Assemble Watches';
  static const String refreshStock = 'Refresh Stock';
  static const String stockSnapshot = 'Current Stock Snapshot';
  static const String transactionHistory = 'Recent Ledger Transactions';
  static const String noLedgerTransactions = 'No ledger transactions yet.';
  static const String lowStockTitle = 'Low Stock Warning';
  static const String lowStockMessage = 'Insufficient stock for one or more components.';
  static const String lowStockWithNumbers = 'Low stock: required {required}, available {available}.';
  static const String close = 'Close';
  static const String successAssembly = 'Production complete';
  static const String successLottieAsset = 'assets/lottie/success.json';
  static const String invalidQuantity = 'Enter a valid quantity greater than 0';
  static const String invalidItemSelection = 'Please select a valid item.';
  static const String dial = 'Dial';
  static const String watchCase = 'Case';
  static const String machine = 'Machine';
  static const String watch = 'Watch';
  static const String ledgerBoxName = 'stock_ledger_box';
  static const String ledgerEncryptionKeyName = 'ledger_box_encryption_key';

  static const String reasonInitialStock = 'Initial stock';
  static const String reasonAssemblyComponentsOut = 'Used for watch assembly';
  static const String reasonProductionOutput = 'Production output';

  static const String inventoryTitle = 'Inventory Management';
  static const String salesTitle = 'Sales Orders';
  static const String returnsTitle = 'Returns & Reverse Flow';
  static const String dashboardTitle = 'Dashboard';
  static const String ledgerTitle = 'Ledger Center';
  static const String viewAllLedger = 'View All Ledger';
  static const String latestTenEntries = 'Activity Stream';
  static const String luxuryTagline = 'Luxury Manufacturing • Offline-first Ledger';
  static const String dashboardDynamicTagline = 'Precision Manufacturing & Inventory Excellence • {moves} Ledger Movements';
  static const String openLabel = 'Open';
  static const String openInventory = 'Open Inventory';
  static const String openProduction = 'Open Production';
  static const String openSales = 'Open Sales';
  static const String openReturns = 'Open Returns';

  static const String stockIn = 'Stock In (Purchase)';
  static const String stockOut = 'Stock Out';
  static const String itemLabel = 'Item';
  static const String qtyLabel = 'Quantity';
  static const String qtyHint = 'Enter quantity';
  static const String addEntry = 'Add Ledger Entry';
  static const String addStockOutEntry = 'Add Stock-Out Entry';
  static const String orderQuantityLabel = 'Order Quantity (Watches)';
  static const String createOrder = 'Create Order';
  static const String returnWatch = 'Return Watch (Add Back)';
  static const String dismantleWatch = 'Dismantle Watch (Break into parts)';

  static const String reasonPurchase = 'Purchase received';
  static const String reasonManualStockOut = 'Manual stock-out';
  static const String reasonSale = 'Sales order';
  static const String reasonReturn = 'Return received';
  static const String reasonDismantle = 'Dismantled return';

  static const String partialProductionMessage = 'Partial production: requested {requested}, produced {produced}.';
  static const String insufficientFinishedWatch = 'Insufficient finished watch stock.';

  static const String filterLabel = 'Filter';
  static const String filterAll = 'All';
  static const String filterType = 'Type';
  static const String filterFrom = 'From';
  static const String filterTo = 'To';
  static const String filterReason = 'Reason';
  static const String clearFilters = 'Clear filters';
  static const String openFilters = 'Filters';
  static const String applyFilters = 'Apply Filters';
  static const String premiumFilterTitle = 'Premium Ledger Filters';
  static const String loadingMore = 'Loading more...';
  static const String exportPdf = 'Export PDF';
  static const String ledgerReportTitle = 'Ledger Activity Report';
  static const String filterSummaryLabel = 'Applied Filters';
  static const String generatedOn = 'Generated on';
  static const String allDates = 'All Dates';
  static const String allTypes = 'All Types';
  static const String allReasons = 'All Reasons';
  static const String exportingPdf = 'Preparing premium PDF...';
  static const String pdfGeneratedSuccess = 'PDF generated successfully.';
  static const String pdfGeneratedError = 'Failed to generate PDF.';
  static const String reportColumnDate = 'Date';
  static const String reportColumnItem = 'Item';
  static const String reportColumnType = 'Type';
  static const String reportColumnQty = 'Qty';
  static const String reportColumnReason = 'Reason/Remarks';
  static const String reportColumnStatus = 'Status';
  static const String statusIn = 'IN';
  static const String statusOut = 'OUT';
  static const String statusStockIn = 'Stock In';
  static const String statusStockOut = 'Stock Out';
  static const List<String> monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const String statusSuccess = 'success';
  static const String statusError = 'error';
}
