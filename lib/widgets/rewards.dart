import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RewardsButton extends StatefulWidget {
  const RewardsButton({Key? key}) : super(key: key);

  @override
  State<RewardsButton> createState() => _RewardsButtonState();
}

class _RewardsButtonState extends State<RewardsButton> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.only(top: 5, right: 10),
        child: NeumorphicButton(
            onPressed: () {
              ShowAlertDialog(context);
            },
            style: NeumorphicStyle(
              color: Colors.blue,
              shadowLightColor: Colors.green,
              shadowDarkColor: Colors.red[400],
              depth: 5,
              intensity: 0.8,
              lightSource: LightSource.topLeft,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: ClipOval(
              child: Image(
                  width: 35,
                  height: 35,
                  image: AssetImage('lib/icons/gift-box.jpg')),
            ))),
      ),
    ]);
  }

  void ShowAlertDialog(BuildContext context) {
    Widget okBtn = NeumorphicButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.8,
          lightSource: LightSource.topLeft,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 60,
          child: Center(
            child: Text(
              'Ok',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ));

    AlertDialog alert = AlertDialog(
      title: Text('Your rewards for the day!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Text(
          'Congratulations! Your battery life has been upgraded from the mystry box',
          style: TextStyle(fontSize: 12)),
      actions: [okBtn],
    );

    showDialog(
        context: context,
        builder: (BuildContext buildercontext) {
          return alert;
        });
  }
}
