import 'package:flutter/widgets.dart';

// ignore: non_constant_identifier_names
Text TextView({
  required String text,
  required Color textColor,
  double? textSize,
  FontWeight? weight,
  int? maxLines,
}) =>
    Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
        fontFamily: 'Ktwod',
        fontWeight: weight,
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: maxLines,
    );
