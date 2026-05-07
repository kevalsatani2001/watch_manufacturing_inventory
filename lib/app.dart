import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/router/app_router.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/responsive_typography.dart';
import 'package:watch_manufacturing_inventory_app/core/services/navigation_service.dart';
import 'package:watch_manufacturing_inventory_app/core/services/snackbar_service.dart';
import 'package:watch_manufacturing_inventory_app/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      scaffoldMessengerKey: SnackBarService.instance.messengerKey,
      theme: AppTheme.lightTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: ResponsiveTypography.scalerForWidth(media.size.width),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
