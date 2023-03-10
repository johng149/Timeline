import 'package:flutter/material.dart';

///Widget that draws a line across the screen
///
///The [BackgroundLine] widget is a simple widget that draws a line across the
///screen. The line is drawn using a [CustomPaint] widget, which has a container
///of width [constraints.maxWidth]
///
///The line is drawn at the given [y] position, with the given [color] and
///[thickness]. The line will be drawn from the left edge of the screen to the
///right edge of the screen, which is determined by the given [constraints] and
///[leftPadding]
class BackgroundLine extends StatelessWidget {
  final BoxConstraints constraints;
  final double y;
  final double thickness;
  final Color color;
  final double leftPadding;

  const BackgroundLine(
      {super.key,
      required this.constraints,
      this.y = 0.0,
      this.thickness = 2.0,
      this.color = Colors.black,
      this.leftPadding = 0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineBackgroundPainter(
          y: y, thickness: thickness, color: color, leftPadding: leftPadding),
      child: Container(width: constraints.maxWidth, height: thickness),
    );
  }
}

class LineBackgroundPainter extends CustomPainter {
  final double y;
  final double thickness;
  final Color color;
  final double leftPadding;

  LineBackgroundPainter(
      {required this.y,
      required this.thickness,
      required this.color,
      this.leftPadding = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = color;
    paint.strokeWidth = thickness;

    canvas.drawLine(Offset(leftPadding, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
