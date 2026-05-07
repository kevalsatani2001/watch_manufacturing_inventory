import 'package:flutter/material.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/app_breakpoints.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static DeviceType deviceType(double width) {
    if (width <= AppBreakpoints.mobileMaxWidth) return DeviceType.mobile;
    if (width <= AppBreakpoints.tabletMaxWidth) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final type = deviceType(constraints.maxWidth);
        switch (type) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}
