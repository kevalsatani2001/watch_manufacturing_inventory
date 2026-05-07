import 'package:flutter/material.dart';

class AppListView<T> extends StatelessWidget {
  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.primary,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.separatorBuilder,
    this.cacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool? primary;
  final Axis scrollDirection;
  final bool reverse;
  final double? cacheExtent;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index], index),
        separatorBuilder: separatorBuilder!,
        padding: padding,
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        primary: primary,
        scrollDirection: scrollDirection,
        reverse: reverse,
        cacheExtent: cacheExtent,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      primary: primary,
      scrollDirection: scrollDirection,
      reverse: reverse,
      cacheExtent: cacheExtent,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }
}
