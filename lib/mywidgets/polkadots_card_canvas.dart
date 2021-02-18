import 'package:flutter/material.dart' ;

class PolkadotsCardCanvas extends StatelessWidget {

  final Color polkaColor ;

  PolkadotsCardCanvas(this.polkaColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        //  DemoPainter(),
        //  CircularWavePainter(),
        //  LineDrawPainter(),
        painter: PathDrawPainter(polkaColor),
        child: Container(),
      ),

    ) ;
  }
}

class PathDrawPainter extends CustomPainter {

  final Color polkaColor ;

  PathDrawPainter(this.polkaColor) ;


  @override
  void paint(Canvas canvas, Size size) {

    double wi = size.width ;
    double he = size.height ;

    Paint circlePaint = Paint()
      ..color = polkaColor.withOpacity(0.2)                                                           // colors[Random().nextInt(colors.length)]
      ..strokeWidth = 3
      ..style = PaintingStyle.fill ;     //PaintingStyle.fill

    canvas.drawCircle(Offset(0.1*wi, 0.25*he), 36, circlePaint);
    canvas.drawCircle(Offset(0.15*wi, 0.8*he), 24, circlePaint);
    canvas.drawCircle(Offset(0.35*wi, 0.3*he), 20, circlePaint);
  //  canvas.drawCircle(Offset(0.4*wi, 0.5*he), 12, circlePaint);
 //   canvas.drawCircle(Offset(0.55*wi, 0.75*he), 8, circlePaint);
    canvas.drawCircle(Offset(0.75*wi, 0.55*he), 26, circlePaint);
    canvas.drawCircle(Offset(0.9*wi, 0.7*he), 28, circlePaint);
 //   canvas.drawCircle(Offset(0.92*wi, 0.25*he), 26, circlePaint);
 //   canvas.drawCircle(Offset(0.96*wi, 0.45*he), 38, circlePaint);

  //  canvas.drawArc(Rect.fromCircle(center:Offset(0.99*wi, 1.12*he), radius: 24), 3.14, 3.14, false, circlePaint);

  }

  @override
  bool shouldRepaint(PathDrawPainter old) {
    return false;
  }

}


