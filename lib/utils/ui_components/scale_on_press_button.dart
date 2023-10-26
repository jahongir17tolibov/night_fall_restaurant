import 'package:flutter/cupertino.dart';

Widget scaleOnPress({
  required Widget child,
  required AnimationController controller,
  VoidCallback? onPressed,
}) =>
    ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.25).animate(controller),
      child: GestureDetector(
        onTap: () {
          controller.forward();
          Future.delayed(const Duration(milliseconds: 200), () {
            controller.reverse();
          });
          onPressed!();
        },
        child: child,
      ),
    );
