import 'package:flutter/material.dart';

class MyAlert extends StatelessWidget {
  final String title;
  final String content;
  const MyAlert({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // close alert
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
