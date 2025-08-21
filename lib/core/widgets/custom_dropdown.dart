import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final List<String> items;
  final String hintLabel;
  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hintLabel,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      onChanged: onChanged,

      items: items
          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
      hint: Text(hintLabel),
      value: value,
    );
  }
}
