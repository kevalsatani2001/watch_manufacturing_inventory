import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    this.backgroundColor,
    this.value,
    this.padding = const EdgeInsets.all(0),
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
          backgroundColor: backgroundColor,
          value: value,
        ),
      ),
    );
  }
}
