import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengeInfo {
  String challengeId;
  String challengeName;
  String challengeLevel;
  int challengeStartTime;
  int challengeEndTime;
  String inviteLink;

  ChallengeInfo({
    required this.challengeId,
    required this.challengeName,
    required this.challengeLevel,
    required this.challengeStartTime,
    required this.challengeEndTime,
    required this.inviteLink,
  });
}

class ChallengesProvider with ChangeNotifier {
  List<ChallengeInfo> _challengeList = [];

  List<ChallengeInfo> get getChallengeList {
    return [..._challengeList];
  }

  Future<void> fetchChallengesList() async {
    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      final List<ChallengeInfo> listOfChallenges = [];
      final url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/challengesList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, challenge) {
        if (challenge['challengeEndTime'] > now) {
          listOfChallenges.add(
            ChallengeInfo(
              challengeId: challenge['challengeId'],
              challengeName: challenge['challengeName'],
              challengeLevel: challenge['challengeLevel'],
              challengeStartTime: challenge['challengeStartTime'],
              challengeEndTime: challenge['challengeEndTime'],
              inviteLink: challenge['inviteLink'],
            ),
          );
        }
      });
      _challengeList = listOfChallenges;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postPairFoundStatus() async {
    const storage = FlutterSecureStorage();
    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/pairProgramming.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});

    try {
      String? _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode(
          {
            'foundAPair': true,
            'userId': _userId,
          },
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<bool> getPairFoundStatus() async {
    const storage = FlutterSecureStorage();
    try {
      bool pairFound = false;
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/pairProgramming.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return false;
      }
      extractedData.forEach((key, userPairStatus) {
        pairFound = userPairStatus['foundAPair'];
      });
      return pairFound;
    } catch (error) {
      throw error;
    }
  }
}
