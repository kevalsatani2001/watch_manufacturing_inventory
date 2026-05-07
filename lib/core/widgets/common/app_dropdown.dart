import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.onChanged,
    this.hintText,
    this.decoration,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.isExpanded = true,
    this.menuMaxHeight,
    this.borderRadius,
    this.dropdownColor,
    this.icon,
  });

  final List<T> items;
  final String Function(T value) itemLabelBuilder;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final InputDecoration? decoration;
  final String? Function(T? value)? validator;
  final void Function(T? value)? onSaved;
  final AutovalidateMode? autovalidateMode;
  final bool isExpanded;
  final double? menuMaxHeight;
  final BorderRadius? borderRadius;
  final Color? dropdownColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      isExpanded: isExpanded,
      menuMaxHeight: menuMaxHeight,
      borderRadius: borderRadius,
      dropdownColor: dropdownColor,
      icon: icon,
      hint: hintText == null ? null : Text(hintText!),
      decoration: decoration ?? const InputDecoration(),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder(item)),
            ),
          )
          .toList(),
    );
  }
}
