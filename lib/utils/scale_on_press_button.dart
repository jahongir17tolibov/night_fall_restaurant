import 'package:flutter/cupertino.dart';

Widget scaleOnPress({
  required Widget child,
  required AnimationController controller,
}) =>
    ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.8).animate(controller),
      child: GestureDetector(
        onTap: () {
          controller.forward();
          Future.delayed(const Duration(milliseconds: 200), () {
            controller.reverse();
          });
        },
        child: child,
      ),
    );
