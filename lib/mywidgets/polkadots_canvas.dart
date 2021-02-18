  import 'package:flutter/material.dart';
  import 'dart:math';


  class PolkadotsCanvas extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Container(
        child: CustomPaint(
          //  DemoPainter(),
          //  CircularWavePainter(),
          //  LineDrawPainter(),
          painter: PathDrawPainter(),
          child: Container(),
        ),

      ) ;
    }
  }

  class PathDrawPainter extends CustomPainter {


    Paint circlePaint = Paint()
      ..color = Colors.blue                                                            // colors[Random().nextInt(colors.length)]
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    Paint circlePaint1 = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    Paint circlePaint2 = Paint()
      ..color = Colors.yellowAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    Paint circlePaint3 = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    Paint circlePaint4 = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    Paint circlePaint5 = Paint()
      ..color = Colors.tealAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill


    @override
    void paint(Canvas canvas, Size size) {

      double wi = size.width ;
      double he = size.height ;

      canvas.drawCircle(Offset(0.05*wi, 0.6*he), 8, circlePaint5);
      canvas.drawCircle(Offset(0.15*wi, 0.95*he), 14, circlePaint);
      canvas.drawCircle(Offset(0.35*wi, he), 20, circlePaint1);
      canvas.drawCircle(Offset(0.4*wi, 0.5*he), 12, circlePaint2);
      canvas.drawCircle(Offset(0.55*wi, 0.75*he), 8, circlePaint3);
      canvas.drawCircle(Offset(0.75*wi, 0.55*he), 6, circlePaint4);
      canvas.drawCircle(Offset(0.9*wi, 0.95*he), 18, circlePaint5);
      canvas.drawCircle(Offset(0.92*wi, 0.55*he), 6, circlePaint1);
      canvas.drawCircle(Offset(0.96*wi, 0.45*he), 8, circlePaint2);

      canvas.drawArc(Rect.fromCircle(center:Offset(0.99*wi, 1.12*he), radius: 24), 3.14, 3.14, false, circlePaint);

    }

    @override
    bool shouldRepaint(PathDrawPainter old) {
      return false;
    }

  }

  var colors = <Color>[Colors.deepPurpleAccent,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.cyan,
    Colors.purple,
    Colors.brown,
    Colors.deepPurple,
    Colors.amber,
    Colors.red,
    Colors.indigo,
    Colors.limeAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent
  ];
