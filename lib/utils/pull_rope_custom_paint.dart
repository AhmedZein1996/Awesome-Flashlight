// Drawn Line here
import 'package:flutter/cupertino.dart';

class PullRopeCustomPaint extends CustomPainter {
  final Offset springOffset;

  final Color lineColor;
  final Offset anchorOffset;

  PullRopeCustomPaint(this.lineColor,
      {required this.anchorOffset, required this.springOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3;
    size.center(Offset.zero);
    canvas.drawLine(anchorOffset, springOffset, linePaint);

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
