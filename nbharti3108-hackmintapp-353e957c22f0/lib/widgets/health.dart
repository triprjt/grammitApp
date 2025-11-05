import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../utils/circularIndicator.dart';

class HealthIndicator extends StatefulWidget {
  const HealthIndicator({Key? key}) : super(key: key);

  @override
  State<HealthIndicator> createState() => _HealthIndicatorState();
}

class _HealthIndicatorState extends State<HealthIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 15),
        child: Column(
          children: [
            CircularIndicator(60),
            NeumorphicButton(
                onPressed: () async {
                  //await openDialog('Health', 30, 300, 200);
                },
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.8,
                  border: NeumorphicBorder(
                    color: Color.fromARGB(51, 13, 1, 1),
                    width: 0.8,
                  ),

                  //color: Color.fromARGB(255, 159, 85, 51),
                  color: Color.fromARGB(255, 20, 131, 187),
                  lightSource: LightSource.bottom,

                  shape: NeumorphicShape.convex,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'UPGRADE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )),
          ],
        ));
  }
}
