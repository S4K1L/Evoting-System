import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    super.key, required this.title, required this.icon, required this.controller, required this.obscureText,
  });
  final String title;
  final bool obscureText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: title,
        filled: true,
        fillColor: Colors.purple[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}