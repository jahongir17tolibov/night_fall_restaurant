import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final Color borderColor;

  const CustomTabIndicator(this.borderColor);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged!, borderColor);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final Color borderColor;

  _CustomPainter(this.decoration, VoidCallback onChanged, this.borderColor)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final rect = offset & configuration.size!;
    final paint = Paint()
      ..color = borderColor // Transparent fill color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 // Border width
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      rect,
      const Radius.circular(120.0),
    ));
    canvas.drawPath(path, paint);
  }
}
