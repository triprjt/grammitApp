import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularIndicator extends StatefulWidget {
  final double health;
  CircularIndicator(this.health);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularPercentIndicator(
        radius: 25.0,
        lineWidth: 5.0,
        percent: widget.health / 100,
        animation: true,
        animationDuration: 2000,
        center: Text(widget.health.toString() + '%',
            style: TextStyle(fontSize: 12, color: Colors.white)),
        progressColor: Colors.lightGreen,
      ),
    );
  }
}
