import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:flutter/material.dart';

Positions pos = new Positions();

// reference : https://morioh.com/p/40f3c0ad1f33
class PathExample extends StatefulWidget {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const PathExample({Key? key,required this.x1,required this.y1,required this.x2,required this.y2}) : super(key: key);
  @override
  State<PathExample> createState() => _PathExampleState();
}

class _PathExampleState extends State<PathExample> {
  @override
  Widget build(BuildContext context) {
    return 
    CustomPaint(
      painter: PathPainter(widget.x1,widget.y1,widget.x2,widget.y2,),
    );
  }
}

class PathPainter extends CustomPainter {
  late double x1;
  late double y1;
  late double x2;
  late double y2;

  PathPainter(this.x1,this.y1,this.x2,this.y2);
  @override
  void paint(Canvas canvas, Size size) {
    
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Path path = Path();
    path.addPolygon([
      // Offset.zero,
      Offset(x1, y1),
      Offset(x2, y2),
    ], true);

    Rect.fromLTWH(x1, y1, 8, 8);
    Rect.fromLTWH(x2, y2, 8, 8);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
