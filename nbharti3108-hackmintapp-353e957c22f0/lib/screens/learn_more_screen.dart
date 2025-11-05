import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LearnMoreScreen extends StatelessWidget {
  static const routeName = '/learn-more-screen';

  const LearnMoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        title: Text('Learn more !'),
        automaticallyImplyLeading: true,
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        // ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Space :',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Space level limits the number of submissions, which can earn you rewards. After Logn is out of Space, user can still make submissions but no reward will be generated. Varies from Level 0 to Level 30.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Time :',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'It is a measure of how powerful or efficient Logn is. Higher level in Time means higher Gramm rewards. Varies from Level 0 to Level 30. ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Battery :',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Battery is the source of power for Logn. No battery means, no rewards will be minted. No in-app activity and No submissions for many days will reduce your battery to 0% after which Logn will not be able to mint Gramm. For lower levels, Battery gets recharged faster than at higher levels. ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Lag :',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'In order to make sure it is hard to game the system, we have placed an Anti cheating system. It is the measure of the rate of submissions that Logn level can handle. If the user is submitting at a rate which is faster than the limit corresponding to the user current level, then Logn will mint fewer Gramm tokens.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Health :',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Logn health reflects user engagement with the app. The more active and involved the user is on the app, the better his/her health will be. It also varies depending on where the user is on his/her grammit journey.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
