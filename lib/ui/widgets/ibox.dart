import 'package:flutter/material.dart';

class IBox extends StatelessWidget {
  final Function() press;
  final Widget? child;
  final Color color;
  final double radius;
  final double blur;
  IBox(
      {this.color = Colors.white,
      required this.press,
      this.child,
      this.radius = 3,
      this.blur = 3});

  @override
  Widget build(BuildContext context) {
    Widget? _child = Container();
    if (child != null) {
      _child = child;
    }
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(40),
            spreadRadius: radius,
            blurRadius: blur,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(color: color, child: _child)),
    );
  }
}
