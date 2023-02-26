import 'package:flutter/material.dart';

class ICard7 extends StatelessWidget {
  final Color? color;
  final String? title;
  final String? body;

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  ICard7({this.title, this.body, this.color, this.titleStyle, this.bodyStyle});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if (color != null) {
      color = color;
    }
    TextStyle? _titleStyle = const TextStyle(fontSize: 16);
    if (titleStyle != null) {
      _titleStyle = titleStyle;
    }
    var bodyStyle = const TextStyle(fontSize: 16);
    if (bodyStyle != null) {
      bodyStyle = bodyStyle;
    }

    String? title = "";
    if (title != null) {
      title = title;
    }
    String? body = "";
    if (body != null) {
      body = body;
    }

    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  style: _titleStyle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                body,
                overflow: TextOverflow.clip,
                style: bodyStyle,
              ),
            ),
          ],
        ));
  }
}
