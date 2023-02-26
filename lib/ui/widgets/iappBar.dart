import 'package:flutter/material.dart';

class IAppBar extends StatelessWidget {
  final BuildContext context;
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  IAppBar(
      {required this.context, required this.text, this.color, this.textStyle});

  @override
  Widget build(BuildContext context) {
    var color = Colors.black;
    if (color != null) {
      color = color;
    }
    TextStyle? style = const TextStyle(fontSize: 18);
    if (textStyle != null) {
      style = textStyle;
    }

    return Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    height: 30,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, color: color),
                        onPressed: () {
                          Navigator.pop(context);
                        }))),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: style,
                    ))),
          ],
        ));
  }
}
