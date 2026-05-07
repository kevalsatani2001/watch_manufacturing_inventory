import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_manufacturing_inventory_app/core/services/stock_ledger_hive_service.dart';
import 'package:watch_manufacturing_inventory_app/core/services/ledger_pdf_service.dart';
import 'package:watch_manufacturing_inventory_app/features/dashboard/view/dashboard_view.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/bloc/inventory_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/inventory/view/inventory_view.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/bloc/ledger_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/ledger/view/ledger_view.dart';
import 'package:watch_manufacturing_inventory_app/features/production/bloc/production_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/production/view/production_view.dart';
import 'package:watch_manufacturing_inventory_app/features/returns/bloc/returns_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/returns/view/returns_view.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/bloc/sales_bloc.dart';
import 'package:watch_manufacturing_inventory_app/features/sales/view/sales_view.dart';

class AppRouter {
  const AppRouter._();

  static const String home = '/';
  static const String production = '/production';
  static const String inventory = '/inventory';
  static const String sales = '/sales';
  static const String returns = '/returns';
  static const String ledger = '/ledger';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardView(),
          settings: settings,
        );
      case production:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<ProductionBloc>(
            create: (_) => ProductionBloc(stockService: StockLedgerHiveService.instance),
            child: const ProductionView(),
          ),
          settings: settings,
        );
      case inventory:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<InventoryBloc>(
            create: (_) => InventoryBloc(stockService: StockLedgerHiveService.instance),
            child: const InventoryView(),
          ),
          settings: settings,
        );
      case sales:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<SalesBloc>(
            create: (_) => SalesBloc(stockService: StockLedgerHiveService.instance),
            child: const SalesView(),
          ),
          settings: settings,
        );
      case returns:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<ReturnsBloc>(
            create: (_) => ReturnsBloc(stockService: StockLedgerHiveService.instance),
            child: const ReturnsView(),
          ),
          settings: settings,
        );
      case ledger:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<LedgerBloc>(
            create: (_) => LedgerBloc(
              stockService: StockLedgerHiveService.instance,
              pdfService: const LedgerPdfService(),
            ),
            child: const LedgerView(),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardView(),
          settings: settings,
        );
    }
  }
}
