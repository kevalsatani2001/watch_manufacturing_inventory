import 'package:flutter/material.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/responsive_layout.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/screen_preset.dart';

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get width => screenSize.width;
  double get height => screenSize.height;

  DeviceType get deviceType => ResponsiveLayout.deviceType(width);

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  ScreenPreset get screenPreset {
    if (isDesktop) return ScreenPreset.spacious;
    if (isTablet) return ScreenPreset.comfortable;
    return ScreenPreset.compact;
  }

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  T presetValue<T>({
    required T compact,
    T? comfortable,
    T? spacious,
  }) {
    if (screenPreset == ScreenPreset.spacious) return spacious ?? comfortable ?? compact;
    if (screenPreset == ScreenPreset.comfortable) return comfortable ?? compact;
    return compact;
  }
}
