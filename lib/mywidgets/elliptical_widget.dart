import 'package:flutter/material.dart' ;

class EllipticalWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double cheight = MediaQuery.of(context).size.height ;
    double cwidth = MediaQuery.of(context).size.width ;

    return Container(
      child: Container(
        color: Colors.transparent,
        height: cheight,
        width: cwidth,
        child: CustomPaint(
          painter: CurvePainter(),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.cyan;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.22);
    path.quadraticBezierTo(
        size.width / 2, size.height*0.4, size.width, size.height * 0.22);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false ;
  }
}
