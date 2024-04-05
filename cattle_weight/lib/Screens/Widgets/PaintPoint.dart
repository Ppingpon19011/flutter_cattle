import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:flutter/material.dart';

Positions pos = new Positions();

// reference : https://morioh.com/p/40f3c0ad1f33
class PathCircle extends StatefulWidget {
  final double x1;
  final double y1;

  const PathCircle(
      {Key? key,
      required this.x1,
      required this.y1,})
      : super(key: key);
  @override
  State<PathCircle> createState() => _PathCircleState();
}

class _PathCircleState extends State<PathCircle> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(
        widget.x1,
        widget.y1,
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  late double x1;
  late double y1;

  PathPainter(
    this.x1,
    this.y1,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Path path = Path();

    canvas.drawPath(path, paint);
    canvas.drawOval(
      Rect.fromLTWH(x1,y1, 8, 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
