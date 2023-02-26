import 'package:flutter/material.dart';

class ILine extends StatelessWidget {
  final double? margin;
  const ILine({this.margin});

  @override
  Widget build(BuildContext context) {
    double? _margin = 0.0;
    if (margin != null) {
      _margin = margin;
    }

    return Container(
      margin: EdgeInsets.only(
          left: _margin ?? 0.0, right: _margin ?? 0.0, top: 10.0, bottom: 10.0),
      height: 0.5,
      color: Colors.grey,
    );
  }
}
