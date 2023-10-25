import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontFamily: 'Ktwod')),
      duration: const Duration(seconds: 2),
    ),
  );
}
