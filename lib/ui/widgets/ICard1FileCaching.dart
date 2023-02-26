import 'dart:core';
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'ILabelIcon.dart';
import 'iline.dart';

class ICard1FileCaching extends StatelessWidget {
  final Color? color;
  final String? title;
  final Color colorProgressBar;
  final TextStyle? titleStyle;
  final String? date;
  final TextStyle? dateStyle;
  final String? text;
  final TextStyle? textStyle;
  final String? userAvatar;
  final double? rating;
  const ICard1FileCaching(
      {this.color,
      this.text,
      this.textStyle,
      this.title,
      this.titleStyle,
      this.colorProgressBar = Colors.black,
      this.date,
      this.dateStyle,
      this.userAvatar,
      this.rating = 5});

  @override
  Widget build(BuildContext context) {
    Color? color = Colors.grey;
    if (color != null) color = color;
    String? text = "";
    if (text != null) text = text;
    String? title = "";
    if (title != null) title = title;
    String? date = "";
    if (date != null) date = date;
    TextStyle? titleStyle = const TextStyle(fontSize: 16);
    if (titleStyle != null) titleStyle = titleStyle;
    TextStyle? textStyle = const TextStyle(fontSize: 16);
    if (textStyle != null) textStyle = textStyle;
    TextStyle? dateStyle = const TextStyle(fontSize: 16);
    if (dateStyle != null) dateStyle = dateStyle;

    var avatar = Container();
    try {
      avatar = Container(
        width: 30,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(
                backgroundColor: colorProgressBar,
              ),
              imageUrl: userAvatar,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
      );
    } catch (_) {}

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              avatar,
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: titleStyle,
                    ),
                    Row(
                      children: <Widget>[
                        UnconstrainedBox(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset("assets/date.png",
                                    fit: BoxFit.contain))),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          date,
                          style: dateStyle,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ILabelIcon(
                text: rating?.toStringAsFixed(1) ?? '',
                color: Colors.white,
                colorBackgroud: color,
                icon: const Icon(
                  Icons.star_border,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            text,
            style: textStyle,
            textAlign: TextAlign.left,
          ),
          ILine(),
        ],
      ),
    );
  }
}
