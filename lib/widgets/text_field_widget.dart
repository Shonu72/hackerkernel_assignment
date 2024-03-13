import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? suffixIcon;
  final Icon prefixIcon;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    required this.prefixIcon,
    required this.obscureText,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && !isPasswordVisible,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  if (widget.obscureText) {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  }
                },
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
              )
            : null,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
