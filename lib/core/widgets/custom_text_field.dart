import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
required     this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) =>
          value!.isEmpty ? 'This field cannot be empty' : null,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 14),
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}
