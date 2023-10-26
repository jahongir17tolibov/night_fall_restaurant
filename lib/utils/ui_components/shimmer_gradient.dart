import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Gradient shimmerEffect(
  BuildContext context,
  AnimationController controller,
) {
  final List<Color> colorsList = [
    Theme.of(context).colorScheme.surfaceVariant,
    Theme.of(context).colorScheme.outline,
    Theme.of(context).colorScheme.surfaceVariant,
  ];
  return LinearGradient(
    begin: const Alignment(-1.0, -0.5),
    end: const Alignment(1.0, 0.5),
    tileMode: TileMode.repeated,
    colors: colorsList,
    stops: [controller.value - 1.0, controller.value, controller.value + 1.0],
  );
}
