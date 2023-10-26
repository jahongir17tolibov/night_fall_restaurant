import 'package:flutter/material.dart';

IconButton onBackNavigate(BuildContext context, String destination) =>
    IconButton(
      onPressed: () {
        Navigator.of(context).popAndPushNamed(destination);
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
