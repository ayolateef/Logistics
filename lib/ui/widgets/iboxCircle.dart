import 'package:flutter/material.dart';

class IBoxCircle extends StatelessWidget {
  @required
  final Function()? press;
  final Widget? child;
  final Color color;
  const IBoxCircle({this.color = Colors.white, this.press, this.child});

  @override
  Widget build(BuildContext context) {
    Widget? child = Container();
    child = child;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(40),
                spreadRadius: 6,
                blurRadius: 6,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ],
          ),
          child: child),
    );
  }
}
