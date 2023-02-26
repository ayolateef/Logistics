import 'package:flutter/material.dart';

class IInkWell extends StatelessWidget {
  final Function() onPress;
  final Widget child;
  const IInkWell({required this.onPress, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  onPress();
                }, // needed
              )),
        )
      ],
    );
  }
}
