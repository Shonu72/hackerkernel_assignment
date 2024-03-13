import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function onPressed;

  CustomAlertDialog({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
