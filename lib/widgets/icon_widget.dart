import 'package:flutter/material.dart';

class StyledIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const StyledIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: borderColor,
        ),
      ),
    );
  }
}
