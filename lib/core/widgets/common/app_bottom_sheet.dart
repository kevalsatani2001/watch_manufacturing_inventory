import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.decoration,
    this.constraints,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;
  final BoxConstraints? constraints;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      builder: (_) => AppBottomSheet(
        constraints: constraints,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding.resolve(Directionality.of(context));
    return Container(
      constraints: constraints,
      decoration: decoration,
      padding: EdgeInsets.only(
        left: resolvedPadding.left,
        right: resolvedPadding.right,
        top: resolvedPadding.top,
        bottom: MediaQuery.viewInsetsOf(context).bottom + resolvedPadding.bottom,
      ),
      child: child,
    );
  }
}
