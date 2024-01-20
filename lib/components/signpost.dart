import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/definitions/point_clicked.dart';
import 'package:timeline/models/point/point.dart';

///Widget that displays child on a column with dot so it looks like a signpost
///
///The [Signpost] widget is a simple widget that displays a child on a column
///of a given [width] and [height]. The child is displayed such that its left
///edge is aligned with the left edge of the column, and its bottom edge is
///aligned with the top edge of the column. The column connects the child to
///a dot of a given [dotRadius] and [dotColor] at the bottom of the column.
///
///This column and dot is drawn using a [CustomPaint] widget
class Signpost extends ConsumerWidget {
  final double width;
  final double height;
  final double dotRadius;
  final Color dotColor;
  final Color lineColor;
  final Point point;
  final PointClicked? onPointClicked;
  final StateProvider<Point?> selectedPointProvider;
  const Signpost(
      {super.key,
      required this.width,
      required this.height,
      this.dotRadius = 8,
      this.dotColor = Colors.black,
      this.lineColor = Colors.black,
      required this.selectedPointProvider,
      required this.point,
      this.onPointClicked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPoint = ref.watch(selectedPointProvider);
    final selected =
        selectedPoint == null ? false : selectedPoint.id == point.id;
    return Draggable(
        feedback: point.child(context, selected),
        data: point,
        childWhenDragging:
            Opacity(opacity: 0.14, child: point.child(context, selected)),
        child: signBody(context, selected));
  }

  /// pointClickDetector is a GestureDetector that calls [onPointClicked] when
  /// the point is clicked
  ///
  /// It will be wrapped around [point.child]
  Widget pointClickDetector(BuildContext context, Widget child) =>
      GestureDetector(
        onTap: () => onPointClicked?.call(point),
        child: child,
      );

  ///signBody contains a Column that houses the child and the columnWithDot
  Widget signBody(BuildContext context, bool selected) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pointClickDetector(context, point.child(context, selected)),
          columnWithDot,
        ],
      );

  Widget get columnWithDot => Container(
        padding: EdgeInsets.only(left: 1.3 + dotRadius / 2),
        height: height,
        width: width,
        child: CustomPaint(
          painter: DotWithColumnPainter(
            columnLength: height,
            radius: dotRadius,
            width: width,
            dotColor: dotColor,
            columnColor: lineColor,
          ),
        ),
      );
}

class DotWithColumnPainter extends CustomPainter {
  final double columnLength;
  final double radius;
  final double width;
  final Color dotColor;
  final Color columnColor;

  DotWithColumnPainter(
      {required this.columnLength,
      required this.radius,
      required this.width,
      required this.dotColor,
      required this.columnColor});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = dotColor
      ..strokeWidth = width;

    final columnPaint = Paint()
      ..color = columnColor
      ..strokeWidth = width;

    final center = Offset(size.width / 2, size.height);

    canvas.drawCircle(center, radius, dotPaint);

    final columnStart = Offset(center.dx, center.dy - radius + 1);
    final columnEnd = Offset(center.dx, center.dy - radius - columnLength + 3);
    canvas.drawLine(columnStart, columnEnd, columnPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
