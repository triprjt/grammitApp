import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RewardItem {
  // int totalScore;
  int lastScoreGained;
  int grammToken;
  // int totalGrammToken;
  int lastRewardedTime;
  String? platform;
  // int totalNumOfSubmissions;
  // int numOfCorrectSubmissions;

  RewardItem({
    // this.totalScore,
    required this.lastScoreGained,
    required this.grammToken,
    // this.totalGrammToken,
    required this.lastRewardedTime,
    this.platform,
    // this.totalNumOfSubmissions,
    // this.numOfCorrectSubmissions,
  });
}

class CalculationUtil with ChangeNotifier {
  String nftKey = "";
  String upgradeKey = "";
  int upgradeCounter = 0;
  List<RewardItem> _rewardList = [];
  int _upgradeTokenRequired = 0;
  double scoreFactor = 0;
  int _upgradeTime = 0;
  String serviceId = '';
  String templateId = '';
  String userId = '';

  List<RewardItem> get rewardList {
    return [..._rewardList];
  }

  String get ServiceId {
    return serviceId;
  }

  String get TemplateId {
    return templateId;
  }

  String get UserId {
    return userId;
  }

  int get totalGrammTokensAvailable {
    int totalGrammToken = 0;
    for (RewardItem rewardItem in _rewardList) {
      totalGrammToken += rewardItem.grammToken;
    }
    return totalGrammToken;
  }

  int get totalScoreTokensAvailable {
    int totalScoreToken = 0;
    for (RewardItem rewardItem in _rewardList) {
      totalScoreToken += rewardItem.lastScoreGained;
    }
    return totalScoreToken;
  }

  int get upgradeTokenRequired {
    return _upgradeTokenRequired;
  }

  int get upgradeTime {
    return _upgradeTime;
  }

  Future<void> fetchemailJsParameters() async {
    const storage = FlutterSecureStorage();

    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
      };
      final List<RewardItem> listOfRewards = [];
      final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/emailJs.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }

      extractedData.forEach((key, emailJsValues) {
        serviceId = emailJsValues['serviceId'];
        templateId = emailJsValues['templateId'];
        userId = emailJsValues['userId'];
      });

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchRewardList() async {
    const storage = FlutterSecureStorage();

    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      final List<RewardItem> listOfRewards = [];
      final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/rewardList.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      // print(extractedData);
      extractedData.forEach((key, rewardItem) {
        listOfRewards.add(
          RewardItem(
            // totalScore: rewardItem['totalScore'],
            lastScoreGained: rewardItem['lastScoreGained'],
            grammToken: rewardItem['grammToken'],
            // totalGrammToken: rewardItem['totalGrammToken'],
            lastRewardedTime: rewardItem['lastRewardedTime'],
            platform: rewardItem['platform'] ?? "",
            // totalNumOfSubmissions: rewardItem['totalNumOfSubmissions'],
            // numOfCorrectSubmissions: rewardItem['numOfCorrectSubmissions'],
          ),
        );
      });
      _rewardList = listOfRewards;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postInitialNftState() async {
    const storage = FlutterSecureStorage();
    final url = Uri.https(
      'grammit-70261-default-rtdb.firebaseio.com',
      '/nftState.json',
      {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
    );
    try {
      String? _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode(
          {
            'userId': _userId,
            'batteryLevel': 100,
            'lagLevel': 0,
            'timeLevel': 5,
            'spaceLevel': 5,
            'healthLevel': 100,
            'spaceIndex': 2,
            'spaceIndexLimitCounter': 0,
            'upgradeKey': "null",
          },
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUpgradeTransactionToFirebase(
      int scoreOrGrammToken, int upgradeTime, bool isScore) async {
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
            'lastScoreGained': isScore ? -scoreOrGrammToken : -1,
            'grammToken': isScore ? -1 : -scoreOrGrammToken,
            // 'totalGrammToken': -1,
            'lastRewardedTime': upgradeTime,
            'userId': _userId,
            // 'numOfCorrectSubmissions': -1,
            // 'totalNumOfSubmissions': -1,
            'platform': "upgrade",
          },
        ),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /* This method should be called after checking that wallet score balance > update score required on the screen page*/
  Future<void> upgradeSpaceLevel(
      int updatedSpaceLevel, int tokensNeeded) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/nftState.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, nft) {
        nftKey = key;
        upgradeKey = nft['upgradeKey'];
        // spaceLevel = nft['spaceLevel'];
        // timeLevel = nft['timeLevel'];
      });
      // calculateUpgradeTokenRequired(updatedSpaceLevel);

      // if (scoreBalance > _upgradeTokenRequired && _upgradeTokenRequired != 0) {
      if (upgradeKey == "null") {
        upgradeCounter = 0;
      } else {
        String tempUpgradeCounter = upgradeKey.split('u').last;
        upgradeCounter = int.parse(tempUpgradeCounter);
      }
      _upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      upgradeCounter += 1;
      upgradeKey = _upgradeTime.toString() + 'u' + upgradeCounter.toString();
      url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/nftState/$nftKey.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      await http.patch(
        url,
        body: json.encode({
          'spaceLevel': updatedSpaceLevel,
          'upgradeKey': upgradeKey,
        }),
      );
      await postUpgradeTransactionToFirebase(tokensNeeded, _upgradeTime, true);
      notifyListeners();
      // return true;
      // } else {
      // return false;
      // }
    } catch (error) {
      throw error;
    }
  }

  /* This method should be called after checking that wallet score balance > update score required on the screen page*/
  Future<void> upgradeTimeLevel(int updatedTimeLevel, int tokensNeeded) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/nftState.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, nft) {
        nftKey = key;
        upgradeKey = nft['upgradeKey'];
        // spaceLevel = nft['spaceLevel'];
        // timeLevel = nft['timeLevel'];
      });
      // calculateUpgradeTokenRequired(updatedTimeLevel);

      // if (scoreBalance > _upgradeTokenRequired && _upgradeTokenRequired != 0) {
      if (upgradeKey == "null") {
        upgradeCounter = 0;
      } else {
        String tempUpgradeCounter = upgradeKey.split('u').last;
        upgradeCounter = int.parse(tempUpgradeCounter);
      }
      _upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      upgradeCounter += 1;
      upgradeKey = _upgradeTime.toString() + 'u' + upgradeCounter.toString();
      url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/nftState/$nftKey.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      await http.patch(
        url,
        body: json.encode({
          'timeLevel': updatedTimeLevel,
          'upgradeKey': upgradeKey,
        }),
      );
      await postUpgradeTransactionToFirebase(tokensNeeded, _upgradeTime, true);
      notifyListeners();
      // return true;
      // } else {
      // return false;
      // }
    } catch (error) {
      throw error;
    }
  }

  /* This method should be called after checking that wallet score balance > update score required on the screen page*/
  Future<void> upgradeBatteryLevel(
      int updatedBatteryLevel, int tokensNeeded, bool isScore) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/nftState.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, nft) {
        nftKey = key;
        upgradeKey = nft['upgradeKey'];
      });
      if (upgradeKey == "null") {
        upgradeCounter = 0;
      } else {
        String tempUpgradeCounter = upgradeKey.split('u').last;
        upgradeCounter = int.parse(tempUpgradeCounter);
      }
      _upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      upgradeCounter += 1;
      upgradeKey = _upgradeTime.toString() + 'u' + upgradeCounter.toString();
      url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/nftState/$nftKey.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      await http.patch(
        url,
        body: json.encode({
          'batteryLevel': updatedBatteryLevel,
          'upgradeKey': upgradeKey,
        }),
      );
      await postUpgradeTransactionToFirebase(
          tokensNeeded, _upgradeTime, isScore);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /* This method should be called after checking that wallet score balance > update score required on the screen page*/
  Future<void> upgradeLagLevel(
      int updatedLagLevel, int tokensNeeded, bool isScore) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/nftState.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, nft) {
        nftKey = key;
        upgradeKey = nft['upgradeKey'];
      });
      if (upgradeKey == "null") {
        upgradeCounter = 0;
      } else {
        String tempUpgradeCounter = upgradeKey.split('u').last;
        upgradeCounter = int.parse(tempUpgradeCounter);
      }
      _upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      upgradeCounter += 1;
      upgradeKey = _upgradeTime.toString() + 'u' + upgradeCounter.toString();
      url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/nftState/$nftKey.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      // print("upgraded lag level is : " '$updatedLagLevel');
      await http.patch(
        url,
        body: json.encode({
          'lagLevel': updatedLagLevel,
          'upgradeKey': upgradeKey,
        }),
      );
      await postUpgradeTransactionToFirebase(
          tokensNeeded, _upgradeTime, isScore);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /* This method should be called after checking that wallet score balance > update score required on the screen page*/
  Future<void> upgradeHealthLevel(
      int updatedHealthLevel, int tokensNeeded, bool isScore) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/nftState.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((key, nft) {
        nftKey = key;
        upgradeKey = nft['upgradeKey'];
      });
      if (upgradeKey == "null") {
        upgradeCounter = 0;
      } else {
        String tempUpgradeCounter = upgradeKey.split('u').last;
        upgradeCounter = int.parse(tempUpgradeCounter);
      }
      _upgradeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      upgradeCounter += 1;
      upgradeKey = _upgradeTime.toString() + 'u' + upgradeCounter.toString();
      url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/nftState/$nftKey.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      await http.patch(
        url,
        body: json.encode({
          'healthLevel': updatedHealthLevel,
          'upgradeKey': upgradeKey,
        }),
      );
      await postUpgradeTransactionToFirebase(
          tokensNeeded, _upgradeTime, isScore);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void calculateUpgradeTokenRequired(
      int upgradeLevel, int spaceLevel, int timeLevel) {
    Map<int, int> optimalSubmissionScore = {};
    optimalSubmissionScore[1] = 14;
    optimalSubmissionScore[2] = 14;
    optimalSubmissionScore[3] = 14;
    optimalSubmissionScore[4] = 28;
    optimalSubmissionScore[5] = 28;

    optimalSubmissionScore[6] = 42;
    optimalSubmissionScore[7] = 42;
    optimalSubmissionScore[8] = 42;

    optimalSubmissionScore[9] = 56;
    optimalSubmissionScore[10] = 56;
    optimalSubmissionScore[11] = 56;

    optimalSubmissionScore[12] = 70;
    optimalSubmissionScore[13] = 70;
    optimalSubmissionScore[14] = 70;

    optimalSubmissionScore[15] = 84;
    optimalSubmissionScore[16] = 84;

    optimalSubmissionScore[17] = 98;
    optimalSubmissionScore[18] = 98;

    optimalSubmissionScore[19] = 112;
    optimalSubmissionScore[20] = 112;

    optimalSubmissionScore[21] = 126;
    optimalSubmissionScore[22] = 126;

    optimalSubmissionScore[23] = 140;
    optimalSubmissionScore[24] = 154;
    optimalSubmissionScore[25] = 168;
    optimalSubmissionScore[26] = 182;
    optimalSubmissionScore[27] = 196;
    optimalSubmissionScore[28] = 210;
    optimalSubmissionScore[29] = 224;
    optimalSubmissionScore[30] = 238;
    calculateScoreFactor(spaceLevel, timeLevel);
    int? subScore = optimalSubmissionScore[upgradeLevel];
    double tempUpgradeTokenRequired = scoreFactor * subScore!;
    _upgradeTokenRequired = tempUpgradeTokenRequired.floor();
  }

  void calculateScoreFactor(int spaceLevel, int timeLevel) {
    double batteryFactor;
    double lagFactor;
    Map<int, double> spaceMap = {};
    Map<int, double> timeMap = {};
    double healthFactor;
    double levelOneValue = 0.8;
    /* space and time factor*/
    for (int i = 1; i <= 30; i++) {
      spaceMap[i] = levelOneValue;
      timeMap[i] = levelOneValue;
      levelOneValue += 0.05;
    }

    /* battery factor*/
    batteryFactor = 1;

    /* lag factor*/
    lagFactor = 1;

    /* health factor*/
    healthFactor = 1.0;

    double nonCoreFactor = batteryFactor * lagFactor;
    double coreFactor = timeMap[timeLevel]! + spaceMap[spaceLevel]!;
    double tempScoreFactor = coreFactor * nonCoreFactor;
    scoreFactor = pow(tempScoreFactor, healthFactor).toDouble();
  }
}
