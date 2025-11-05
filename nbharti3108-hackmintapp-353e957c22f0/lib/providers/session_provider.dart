import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionInfo {
  String sessionId;
  String companyName;
  int timeOfSession;
  String speakerName;
  int yearsOfExperience;
  int entryFee;
  int numOfRegisteredusers;
  int totalNumOfUsers;
  List<String>? usersList = [];
  bool? isRegisterd = false;

  SessionInfo({
    required this.sessionId,
    required this.companyName,
    required this.timeOfSession,
    required this.speakerName,
    required this.yearsOfExperience,
    required this.entryFee,
    required this.numOfRegisteredusers,
    required this.totalNumOfUsers,
    this.usersList,
    this.isRegisterd,
  });
}

class SessionProvider with ChangeNotifier {
  List<SessionInfo> _sessionList = [];

  List<SessionInfo> get getSessionList {
    return [..._sessionList];
  }

  Future<void> fetchSessionList() async {
    const storage = FlutterSecureStorage();
    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      String? _userId = await storage.read(key: "uid");
      final List<SessionInfo> listOfSessions = [];
      final url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/sessionList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, session) {
        if (session['timeOfSession'] > now) {
          listOfSessions.add(
            SessionInfo(
              sessionId: session['sessionId'],
              companyName: session['companyName'],
              timeOfSession: session['timeOfSession'],
              speakerName: session['speakerName'],
              yearsOfExperience: session['yearsOfExperience'],
              entryFee: session['entryFee'],
              totalNumOfUsers: session['totalNumOfUsers'],
              numOfRegisteredusers: session['usersList'] == null
                  ? 0
                  : (session['usersList'] as List<dynamic>).length,
              isRegisterd: session['usersList'] == null
                  ? false
                  : (session['usersList'] as List<dynamic>).contains(_userId),
            ),
          );
        }
      });
      _sessionList = listOfSessions;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> adduserToSession(String sessionId) async {
    const storage = FlutterSecureStorage();

    try {
      String _dbKey = "";
      int _entryFee = 0;
      List<dynamic> _listOfUsers = [];
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('sessionId'),
        'equalTo': json.encode(sessionId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/sessionList.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        // This will never be possible since sessionId will be availabel only if session is present
        // so no need to add a post method here.
      } else {
        int lengthOfList = 0;
        extractedData.forEach((key, session) {
          _dbKey = key;
          _entryFee = session['entryFee'];
          _listOfUsers = session['usersList'] == null
              ? []
              : (session['usersList'] as List<dynamic>);
        });

        lengthOfList = _listOfUsers.length;
        // print(lengthOfList);
        url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/sessionList/$_dbKey/usersList.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
        await http.patch(
          url,
          body: json.encode(
            {
              '$lengthOfList': _userId,
            },
          ),
        );
        await postSessionTransactionToFirebase(_entryFee);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postSessionTransactionToFirebase(int grammToken) async {
    int upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/rewardList.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode(
          {
            // 'totalScore': -1,
            'lastScoreGained': -1,
            'grammToken': -grammToken,
            // 'totalGrammToken': -1,
            'lastRewardedTime': upgradeTime,
            'userId': _userId,
            // 'numOfCorrectSubmissions': -1,
            // 'totalNumOfSubmissions': -1,
            'platform': "session",
          },
        ),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
