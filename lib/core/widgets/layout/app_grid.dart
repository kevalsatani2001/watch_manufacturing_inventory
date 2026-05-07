import 'package:flutter/material.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/responsive_layout.dart';
import 'package:watch_manufacturing_inventory_app/core/responsive/screen_preset.dart';

class AppGrid<T> extends StatelessWidget {
  const AppGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.mobileCrossAxisCount,
    this.tabletCrossAxisCount,
    this.desktopCrossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 1.2,
    this.shrinkWrap = true,
    this.physics,
    this.screenPreset = ScreenPreset.comfortable,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int? mobileCrossAxisCount;
  final int? tabletCrossAxisCount;
  final int? desktopCrossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScreenPreset screenPreset;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final type = ResponsiveLayout.deviceType(width);
    final tokens = PresetTokens.fromPreset(screenPreset);
    final crossAxisCount = switch (type) {
      DeviceType.mobile => mobileCrossAxisCount ?? tokens.mobileGridCount,
      DeviceType.tablet => tabletCrossAxisCount ?? tokens.tabletGridCount,
      DeviceType.desktop => desktopCrossAxisCount ?? tokens.desktopGridCount,
    };

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing ?? tokens.spacing,
        crossAxisSpacing: crossAxisSpacing ?? tokens.spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
