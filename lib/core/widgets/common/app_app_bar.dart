import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.scrolledUnderElevation,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarHeight,
    this.surfaceTintColor,
    this.automaticallyImplyLeading = true,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? scrolledUnderElevation;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? toolbarHeight;
  final Color? surfaceTintColor;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      surfaceTintColor: surfaceTintColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0));
}
