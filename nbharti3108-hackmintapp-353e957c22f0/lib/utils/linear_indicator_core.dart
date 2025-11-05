import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearIndicatorCore extends StatefulWidget {
  final state;
  LinearIndicatorCore(this.state);

  @override
  State<LinearIndicatorCore> createState() => _LinearIndicatorCoreState();
}

class _LinearIndicatorCoreState extends State<LinearIndicatorCore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      child: LinearPercentIndicator(
        alignment: MainAxisAlignment.start,
        lineHeight: 9.0,
        barRadius: Radius.circular(10),
        // width: 260,
        // width: double.infinity,
        percent: widget.state / 30,
        animation: true,
        animationDuration: 1000,
        leading: Text(
          "0",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        trailing: Text(
          "30",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),

        progressColor: Color.fromARGB(255, 127, 191, 124),
        widgetIndicator: Icon(
          Icons.place,
          color: Colors.red,
          size: 14,
        ),
      ),
    );
  }
}
