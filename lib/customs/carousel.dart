import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:thikthak/constant/colors.dart';

Widget imageCarousel = SizedBox(
    height: 260,
    width: double.infinity,
    child: Carousel(
      images: [
        ExactAssetImage("assets/images/slider1.png"),
        ExactAssetImage("assets/images/slider2.png"),
        ExactAssetImage("assets/images/slider3.png"),
      ],
      dotSize: 5.0,
      dotSpacing: 15.0,
      dotBgColor: MyColor.colorBlue.withOpacity(0),
      autoplay: true,
    ));

class SliderFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SliderClipper(),
      child: imageCarousel,
    );
  }
}

class SliderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 55);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 55);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);
    path.lineTo(size.width, size.height - 55);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
