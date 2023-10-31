import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: TextView(
        text: message,
        textColor: Theme.of(context).colorScheme.surface,
        maxLines: 3,
      ),
      backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondaryContainer,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
