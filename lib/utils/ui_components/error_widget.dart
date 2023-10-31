import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

Widget errorWidget(String errorText, BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextView(
          text: errorText,
          textColor: Theme.of(context).colorScheme.error,
          textSize: 20.0,
        ),
      ),
    );
