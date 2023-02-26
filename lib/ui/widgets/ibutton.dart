import 'package:flutter/material.dart';

class IButton extends StatelessWidget {
  final Function() pressButton;
  final Color color;
  final Color colorText;
  final String? text;
  final TextStyle? textStyle;
  const IButton(
      {required this.pressButton,
      this.text,
      this.color = Colors.grey,
      this.colorText = Colors.white,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    TextStyle? _textStyle = const TextStyle(fontSize: 16);
    if (textStyle != null) {
      _textStyle = textStyle;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child:
                    Text(text!, textAlign: TextAlign.center, style: _textStyle),
              ),
              Icon(
                Icons.navigate_next,
                color: colorText,
              )
            ],
          )),
      onPressed: () {
        pressButton();
      },
    );
  }
}
