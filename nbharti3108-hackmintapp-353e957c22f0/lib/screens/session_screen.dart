import 'package:first_app/providers/calculation_util.dart';
import 'package:first_app/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../widgets/session_item.dart';

class SessionScreen extends StatefulWidget {
  static const routeName = '/sessions-screen';
  const SessionScreen({Key? key}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late Future<void> _futureSessionFunctions;

  @override
  void initState() {
    _futureSessionFunctions = _getSessionList(context);
    super.initState();
  }

  Future<void> _getSessionList(BuildContext context) async {
    print("...getting session lists...");
    await Provider.of<SessionProvider>(context, listen: false)
        .fetchSessionList();
    await Provider.of<CalculationUtil>(context, listen: false)
        .fetchRewardList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<SessionInfo> _sessionList = [];
    List<Widget> sessionDetails = [];

    _sessionList =
        Provider.of<SessionProvider>(context, listen: false).getSessionList;
    sessionDetails = _sessionList
        .map(
          (sessionItem) => SessionItem(
            sessionItem,
          ),
        )
        .toList();
    return FutureBuilder(
      future: _futureSessionFunctions,
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _getSessionList(ctx),
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('CV Reviews'),
                      backgroundColor: Colors.blueGrey[600],
                      automaticallyImplyLeading: false,
                    ),
                    backgroundColor: Colors.black,
                    body: WillPopScope(
                      onWillPop: () async => false,
                      child: _sessionList.isEmpty
                          ? const Center(
                              child: Text(
                                'No Sesssions scheduled.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: sessionDetails,
                              ),
                            ),
                    ),
                  ),
                ),
    );
  }
}
