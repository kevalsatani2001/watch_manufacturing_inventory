import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior = Clip.none,
    this.semanticContainer = true,
  });

  final Widget child;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;
  final bool semanticContainer;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: child,
    );
  }
}
