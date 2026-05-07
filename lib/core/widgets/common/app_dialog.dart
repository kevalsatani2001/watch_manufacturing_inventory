import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_colors.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_sizes.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.shape,
    this.backgroundColor,
    this.elevation,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
    this.clipBehavior = Clip.none,
    this.lottieAsset,
    this.status = AppStrings.statusError,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets insetPadding;
  final Clip clipBehavior;
  final String? lottieAsset;
  final String status;

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    String? lottieAsset,
    String status = AppStrings.statusError,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (_) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        lottieAsset: lottieAsset,
        status: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == AppStrings.statusSuccess;
    final accent = isSuccess ? AppColors.success : AppColors.champagneGold;
    final optionalContent = content == null ? <Widget>[] : <Widget>[content!];
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox.expand(),
          ),
        ),
        AlertDialog(
          title: title,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (lottieAsset != null) ...<Widget>[
                SizedBox(height: AppSizes.xxl * 2, child: Lottie.asset(lottieAsset!, repeat: false)),
                const SizedBox(height: AppSizes.sm),
              ],
              ...optionalContent,
            ],
          ),
          actions: actions,
          titlePadding: titlePadding,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.lg),
                side: BorderSide(color: accent.withValues(alpha: 0.35)),
              ),
          backgroundColor: backgroundColor ?? AppColors.cardLuxury,
          elevation: elevation ?? AppSizes.md,
          insetPadding: insetPadding,
          clipBehavior: clipBehavior,
        ),
      ],
    );
  }
}
