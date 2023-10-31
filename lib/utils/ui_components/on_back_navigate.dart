import 'package:flutter/material.dart';

IconButton onBackNavigate(BuildContext context, String destination) =>
    IconButton(
      onPressed: () async {
        await Navigator.of(context).pushReplacementNamed(destination);
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
