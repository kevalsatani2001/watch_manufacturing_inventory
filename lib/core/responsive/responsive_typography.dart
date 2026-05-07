import 'package:flutter/widgets.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/responsive_layout.dart';

class ResponsiveTypography {
  const ResponsiveTypography._();

  static TextScaler scalerForWidth(double width) {
    final type = ResponsiveLayout.deviceType(width);
    switch (type) {
      case DeviceType.mobile:
        return const TextScaler.linear(0.95);
      case DeviceType.tablet:
        return const TextScaler.linear(1.0);
      case DeviceType.desktop:
        return const TextScaler.linear(1.05);
    }
  }

  static TextStyle luxuryHeading(BuildContext context) {
    final type = ResponsiveLayout.deviceType(MediaQuery.sizeOf(context).width);
    final base = switch (type) {
      DeviceType.mobile => 18.0,
      DeviceType.tablet => 20.0,
      DeviceType.desktop => 22.0,
    };
    return TextStyle(
      fontSize: base,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.9,
      height: 1.2,
    );
  }
}
