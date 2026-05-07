import 'package:flutter/material.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/responsive_extensions.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/screen_preset.dart';
import 'package:watch_manufacturing_inventory_app/core/widgets/common/app_app_bar.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.maxContentWidth,
    this.padding,
    this.screenPreset,
    this.floatingActionButton,
    this.drawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.resizeToAvoidBottomInset,
  });

  final AppAppBar? appBar;
  final Widget body;
  final double? maxContentWidth;
  final EdgeInsetsGeometry? padding;
  final ScreenPreset? screenPreset;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final preset = screenPreset ?? context.screenPreset;
    final tokens = PresetTokens.fromPreset(preset);
    final resolvedMaxWidth = maxContentWidth ?? tokens.maxContentWidth;
    final resolvedPadding = padding ?? tokens.padding;

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
            child: Padding(
              padding: resolvedPadding,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
