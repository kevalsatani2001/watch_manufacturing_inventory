import 'package:flutter/material.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_sizes.dart';

class AppSpacing {
  const AppSpacing._();

  static const Widget vXs = SizedBox(height: AppSizes.xs);
  static const Widget vSm = SizedBox(height: AppSizes.sm);
  static const Widget vMd = SizedBox(height: AppSizes.md);
  static const Widget vLg = SizedBox(height: AppSizes.lg);
  static const Widget vXl = SizedBox(height: AppSizes.xl);

  static const Widget hXs = SizedBox(width: AppSizes.xs);
  static const Widget hSm = SizedBox(width: AppSizes.sm);
  static const Widget hMd = SizedBox(width: AppSizes.md);
  static const Widget hLg = SizedBox(width: AppSizes.lg);
  static const Widget hXl = SizedBox(width: AppSizes.xl);
}
