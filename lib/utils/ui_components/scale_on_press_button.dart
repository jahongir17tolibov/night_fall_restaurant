import 'package:flutter/cupertino.dart';

class ScaleOnPressButton extends StatelessWidget {
  final Widget child;
  final AnimationController controller;

  const ScaleOnPressButton({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double scale = 1 - controller.value;
    return GestureDetector(
      onTapUp: _tapUp,
      onTapDown: _tapDown,
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    controller.reverse();
  }
}

// ScaleTransition
// (
// scale: Tween<double>(begin: 1.0, end: 0.25).animate(controller),
// child: GestureDetector(
// onTap: () {
// controller.forward();
// Future.delayed(const Duration(milliseconds: 200), () {
// controller.reverse();
// });
// onPressed!();
// },
// child
// :
// child
// ,
// )
// ,
// );
