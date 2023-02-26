import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/stats.dart';
import '../../model/statsprice.dart';
import '../../viewmodel/createaccount.dart';
import '../widgets/ICard25.dart';
import '../widgets/ICard26.dart';
import '../widgets/IList1.dart';

class StatisticsScreen extends StatefulWidget {
  final Function(String)? callback;
  StatisticsScreen({Key? key, this.callback}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: MediaQuery.of(context).padding.top + 30),
          child: _body(),
        )
      ],
    );
  }

  _body() {
    return ListView(
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];
    Stats? statsData =
        Provider.of<CreateAccountViewModel>(context, listen: false).stats;
    Statsprice? statsPrice =
        Provider.of<CreateAccountViewModel>(context, listen: false).statsprices;

    list.add(ICard26(
      color: theme.colorBackgroundDialog!,
      text: "\N${statsData?.totalamt}",
      text2: strings.get(90) ?? '', // "Total Earning",
      text3: statsData?.jobdone.toString() ?? '',
      text4: strings.get(91) ?? '', // "Orders",
      textStyle: theme.text18bold!,
      text2Style: theme.text16!,
      enable56: false,
    ));

    list.add(const SizedBox(
      height: 10,
    ));

    list.add(Container(
      margin: const EdgeInsets.only(left: 20),
      child: IList1(
          imageAsset: "assets/earning.png",
          text: strings.get(90) ?? '', // "Total Earning",
          textStyle: theme.text16bold!,
          imageColor: theme.colorDefaultText!),
    ));

    list.add(ICard25(
      bottomTexts: const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
      bottomTexts2: const ["5", "10", "15", "20", "25"],
      bottomTextStyle: theme.text14!,

      width: windowWidth,
      height: windowWidth * 0.45,

      color: theme.colorPrimary.withOpacity(0.1),
      colorTimeIcon: theme.colorGrey,

      colorAction: theme.colorPrimary,
      actionText: strings.get(81) ?? '', // "week",
      actionText2: strings.get(82) ?? '', // month
      action: theme.text12white!,

      data: statsPrice!.earningweek!,
      data2: statsPrice.earningmonth!,
      colorLine: theme.colorPrimary,
      shadowColor: Colors.white,
    ));
    list.add(const SizedBox(
      height: 10,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20),
      child: IList1(
          imageAsset: "assets/statistics.png",
          text: strings.get(24) ?? '', // "Orders",
          textStyle: theme.text16bold!,
          imageColor: theme.colorDefaultText!),
    ));

    list.add(ICard25(
      bottomTexts: const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
      bottomTexts2: const ["5", "10", "15", "20", "25"],
      bottomTextStyle: theme.text14!,

      width: windowWidth,
      height: windowWidth * 0.45,

      color: theme.colorPrimary.withOpacity(0.1),
      colorTimeIcon: theme.colorGrey,

      colorAction: theme.colorPrimary,
      actionText: strings.get(81) ?? '', // "week",
      actionText2: strings.get(82) ?? '', // month
      action: theme.text12white!,

      data: statsData!.earningweek!,
      data2: statsData.earningmonth!,
      colorLine: theme.colorPrimary,
      shadowColor: Colors.white,
    ));

    list.add(const SizedBox(
      height: 100,
    ));
    return list;
  }
}
