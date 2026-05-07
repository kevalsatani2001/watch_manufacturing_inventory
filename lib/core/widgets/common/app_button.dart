import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.icon,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final button = icon == null
        ? ElevatedButton(
            onPressed: onPressed,
            onLongPress: onLongPress,
            style: style,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            child: Text(label),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            onLongPress: onLongPress,
            style: style,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            icon: icon!,
            label: Text(label),
          );

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
