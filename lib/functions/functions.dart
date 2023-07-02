import 'package:flutter/material.dart';

showReusableSnackBar(BuildContext context, String text, Color color) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontSize: 36,
        color: Colors.white,
      ),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
