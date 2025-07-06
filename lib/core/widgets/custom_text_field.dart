import 'package:email_validator/email_validator.dart';

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
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        if (keyboardType == TextInputType.emailAddress &&
            !EmailValidator.validate(value)) {
          return 'Enter a valid email address';
        }
        if (keyboardType == TextInputType.phone &&
            !RegExp(r'^(?:\+94|0)?7\d{8}$').hasMatch(value)) {
          return 'Enter a valid Sri Lankan phone number';
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 14),
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}
