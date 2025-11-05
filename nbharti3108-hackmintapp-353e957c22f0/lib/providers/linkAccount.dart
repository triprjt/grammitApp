import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubmissionInfo {
  // String handle;
  int submissionTime;
  String problemName;
  String verdict;
  int problemRating;

  SubmissionInfo({
    // @required this.handle,
    required this.submissionTime,
    required this.problemName,
    required this.verdict,
    required this.problemRating,
  });
}

class NftState {}

// class Reward {
//   int totalScore;
//   int lastScoreGained;
//   int grammToken;
//   int lastRewardedTime;

//   Reward({
//     @required this.totalScore,
//     @required this.lastScoreGained,
//     this.grammToken,
//     @required this.lastRewardedTime,
//   });
// }
// grammit-70261-default-rtdb.firebaseio.com
class LinkAccount with ChangeNotifier {
  int _userRating = -1;
  int _totalScore = 0;
  double _dailyScore = 0.0;

  /* This time represents the top most submission timestamp on codeforces. This is tored in the device and keeps on getting updated*/
  int lastSubmissionTime = 0;

  int updatedUserRating = 0;
  String userHandle = "";
  String leetcodeHandle = "";
  String gfgHandle = "";
  final List<String> listOfQuestions = [];
  bool isDuplicateQuestion = false;
  final List<String> questionToAddInDB = [];
  String cfKey = "null";
  int initialLength = 0;
  int totalNumOfSubmissions = 0;
  int numOfCorrectSubmissions = 0;

  /* The below fields represent the nft stae*/
  int batteryLevel = 100;
  int lagLevel = 0;
  int timeLevel = 5;
  int spaceLevel = 5;
  int healthLevel = 100;
  int spaceIndex = 0;
  int spaceIndexLimitCounter = 0;
  String nftDBKey = "";
  int upgradeCounter = 0;
  String upgradeKey = "";
  double scoreFactor = 0;
  int dailyScoreToken = 0;
  int dailyGrammToken = 0;
  int totalGrammToken = 0;
  Map<String, int> nftMap = {};
  Map<String, int> liteNftMap = {};
  bool hasAtleastAHandle = false;

  /*
  leetcode variables
  */
  int easySolvedLc = 0;
  int mediumSolvedLc = 0;
  int hardSolvedLc = 0;

  /*
  gfg variables
  */
  int basicSolvedGfg = 0;
  int easySolvedGfg = 0;
  int mediumSolvedGfg = 0;
  int hardSolvedGfg = 0;

  /* this time represents the time when user minted the nft, i.e. the first time user registered on the app */
  int appRegistrationTime = 0;

  /* this time represents last app opened time. It will be same as previousLastSubmissionTime if the user has made submissions 
  before opening the app*/
  int lastAppOpenedTime = 0;

  int currentAppOpenedTime = 0;

  /* this field represents submission time previous to the last submission time */
  int previousLastSubmissionTime = 0;

  /* This time represnets the timestamp of the last submission in the submission list*/
  int lastSubmissionListLastTime = 0;

  /* This time represents the last time user upgraded any of the nft property*/
  int lastUpgradeTime = 0;

  List<SubmissionInfo> _submissionList = [];

  List<SubmissionInfo> get submissionList {
    return [..._submissionList];
  }

  double get dailyScore {
    return _dailyScore;
  }

  int get totalScore {
    return _totalScore;
  }

  int get userRating {
    return _userRating;
  }

  Map<String, int> get nftState {
    return {...nftMap};
  }

  Map<String, int> get liteNftState {
    return {...liteNftMap};
  }

  String get getCFHandle {
    return userHandle;
  }

  String get getLCHandle {
    return leetcodeHandle;
  }

  String get getGfgHandle {
    return gfgHandle;
  }

  Future<void> getUserRatingForCodeforces(String handle) async {
    userHandle = handle;
    lastSubmissionTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var _params = <String, String>{
      'handles': handle,
    };
    final url = Uri.https('codeforces.com', '/api/user.info', _params);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      // print(extractedData);
      if (extractedData['status'] == 'OK') {
        _userRating = extractedData['result'][0]['rating'] ?? 0;
        // _totalScore = userRating.toDouble();
      } else {
        _userRating = -1;
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUpdatedUserRatingForCodeforces() async {
    // userHandle = handle;
    var _params = <String, String>{
      'handles': userHandle,
    };
    final url = Uri.https('codeforces.com', '/api/user.info', _params);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      if (extractedData['status'] == 'OK') {
        updatedUserRating = extractedData['result'][0]['rating'] ?? 0;
      }
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getCompleteSubmissionList() async {
    if (userHandle.isNotEmpty) {
      await getSubmissionListForHandle(userHandle, 1, 50);
      // await getUpdatedUserRatingForCodeforces();
      await addUniqueQuestionToDB();
    }

    // if (_submissionList.length == 50) {
    //   getSubmissionListForHandle(userHandle, 51, 50);
    // }
  }

  Future<void> getSubmissionListForHandle(
      String handle, int from, int count) async {
    var _params = <String, String>{
      'handle': handle,
      'from': json.encode(from),
      'count': json.encode(count),
    };

    final url = Uri.https('codeforces.com', '/api/user.status', _params);
    try {
      final response = await http.get(url);
      final List<SubmissionInfo> loadedSubmissions = [];
      final Map<String, dynamic>? extractedData = json.decode(response.body);

      if (extractedData == null || extractedData.isEmpty) {
        return;
      }

      await getQuestionsListForUser();

      if (extractedData['status'] == 'OK' && lastSubmissionTime != 0) {
        for (var item in (extractedData['result'] as List<dynamic>)) {
          if (item['creationTimeSeconds'] > lastSubmissionTime) {
            print(item['creationTimeSeconds']);
            // print('in for loop it is -  $lastSubmissionTime');
            // lastSubmissionTime = item['creationTimeSeconds'];
            // dailyScoreAvailable = true;
            // print('after update it is -  $lastSubmissionTime');

            // if (!listOfQuestions.contains(item['problem']['name'])) {
            loadedSubmissions.add(
              SubmissionInfo(
                // handle: handle,
                submissionTime: item['creationTimeSeconds'],
                problemName: item['problem']['name'],
                verdict: item['verdict'] ?? "",
                problemRating: item['problem']['rating'] ?? 0,
              ),
            );
            // listOfQuestions.add(item['problem']['name']);
            // questionToAddInDB.add(item['problem']['name']);

            // }
          }
        }
      }
      print(loadedSubmissions.length);
      totalNumOfSubmissions = loadedSubmissions.length;
      _submissionList = loadedSubmissions;
      if (_submissionList.isNotEmpty) {
        lastSubmissionTime = _submissionList[0].submissionTime;
        lastSubmissionListLastTime =
            _submissionList[totalNumOfSubmissions - 1].submissionTime;
      }
      calculateDailyScoreForCodeforces();
      // calculateTotalScoreForCodeforces();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void calculateDailyScoreForCodeforces() {
    for (var submission in _submissionList) {
      if (submission.verdict == 'OK' &&
          !listOfQuestions.contains(submission.problemName)) {
        // dailyScoreAvailable = true;
        numOfCorrectSubmissions++;
        listOfQuestions.add(submission.problemName);
        questionToAddInDB.add(submission.problemName);
        print("(((");
        print(submission.submissionTime);
        print(lastSubmissionTime);
        print(")))");
        _dailyScore += (submission.problemRating) / 100;
        print("daily score for cf ::" '$_dailyScore');
      }
    }
  }

  Future<void> postRewardsToFirebase() async {
    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/rewardList.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      print('total num of submission for codeforces - ' +
          '$totalNumOfSubmissions');
      if (totalNumOfSubmissions > 0) {
        print("////");
        // print(_totalScore);
        await http.post(
          url,
          body: json.encode(
            {
              /* 
              totalScore and totalGrammToken fields are not actually needed.
              Ignore these fields. Will be removed after certain refactoring from both db and device storage.
              */
              'totalScore': _totalScore,
              'lastScoreGained': dailyScoreToken,
              'grammToken': dailyGrammToken,
              'totalGrammToken': totalGrammToken,
              'lastRewardedTime': lastSubmissionTime,
              'userId': _userId,
              'numOfCorrectSubmissions': numOfCorrectSubmissions,
              'totalNumOfSubmissions': totalNumOfSubmissions,
              'platform': "cf"
            },
          ),
        );
      }
      if (leetScoreToken > 0 || leetGrammToken > 0) {
        await postLeetcodeRewardToDB(lastSubmissionTimeLeetcode);
      }
      if (gfgScoreToken > 0 || gfgGrammToken > 0) {
        await postGfgRewardToDb(lastSubmissionTimeGfg);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> setUsercodingDataToDevice() async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      appRegistrationTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String _dbKey = "";
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };

      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/userCodingData.json', _params);
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null || extractedData.isEmpty) {
        url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/userCodingData.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
        await http.post(
          url,
          body: json.encode(
            {
              'handle': userHandle,
              'totalScore': totalScore,
              /* optimal last sub time considering all platforms*/
              'lastSubmissionTime': max(lastSubmissionTime,
                  max(lastSubmissionTimeLeetcode, lastSubmissionTimeGfg)),
              'lastAppOpenedTime': appRegistrationTime,
              'totalGramm': totalGrammToken,
              'leetcodeHandle': leetcodeHandle,
              'gfgHandle': gfgHandle,
              'userId': _userId,
            },
          ),
        );
      } else {
        extractedData.forEach((key, value) {
          _dbKey = key;
        });
        url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/userCodingData/$_dbKey.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
        await http.patch(
          url,
          body: json.encode(
            {
              'handle': userHandle,
              'totalScore': totalScore,
              /* optimal last sub time considering all platforms*/
              'lastSubmissionTime': max(lastSubmissionTime,
                  max(lastSubmissionTimeLeetcode, lastSubmissionTimeGfg)),
              'lastAppOpenedTime': currentAppOpenedTime,
              'totalGramm': totalGrammToken,
              'leetcodeHandle': leetcodeHandle,
              'gfgHandle': gfgHandle,
              'userId': _userId,
            },
          ),
        );
      }

      // final prefs = await SharedPreferences.getInstance();
      // String userCodingData = "";
      // if (!prefs.containsKey('userCodingData')) {
      //   print("Setting device data for the first time");
      //   userCodingData = json.encode({
      //     'handle': userHandle,
      //     'totalScore': totalScore,
      //     'lastSubmissionTime': max(lastSubmissionTime,
      //         max(lastSubmissionTimeLeetcode, lastSubmissionTimeGfg)),
      //     'lastAppOpenedTime': appRegistrationTime,
      //     'totalGramm': totalGrammToken,
      //     'leetcodeHandle': leetcodeHandle,
      //     'gfgHandle': gfgHandle,
      //   });
      // } else {
      int optimalSubTime = max(lastSubmissionTime,
          max(lastSubmissionTimeLeetcode, lastSubmissionTimeGfg));
      print("lastSubmission in set is" '$optimalSubTime');
      //   userCodingData = json.encode({
      //     'handle': userHandle,
      //     'totalScore': totalScore,
      //     /* optimal last sub time considering all platforms*/
      //     'lastSubmissionTime': max(lastSubmissionTime,
      //         max(lastSubmissionTimeLeetcode, lastSubmissionTimeGfg)),
      //     'lastAppOpenedTime': currentAppOpenedTime,
      //     'totalGramm': totalGrammToken,
      //     'leetcodeHandle': leetcodeHandle,
      //     'gfgHandle': gfgHandle,
      //   });
      // }
      // prefs.setString('userCodingData', userCodingData);
      _submissionList.clear();
      listOfQuestions.clear();
      questionToAddInDB.clear();
      // dailyScoreAvailable == true
      // ? dailyScoreAvailable = false
      // : _dailyScore = 0.0;
      _dailyScore = 0.0;
      numOfCorrectSubmissions = 0;
      totalNumOfSubmissions = 0;

      dailyGrammToken = 0;
      totalGrammToken = 0;
      dailyScoreToken = 0;
      leetScoreToken = 0;
      leetGrammToken = 0;
      gfgScoreToken = 0;
      gfgGrammToken = 0;

      easySolvedLc = 0;
      mediumSolvedLc = 0;
      hardSolvedLc = 0;
      basicSolvedGfg = 0;
      easySolvedGfg = 0;
      mediumSolvedGfg = 0;
      hardSolvedGfg = 0;

      lagLevelLeetcode = 0;
      lagLevelGfg = 0;
      batteryLevel = 0;
      lagLevel = 0;
      healthLevel = 0;
      spaceLevel = 0;
      timeLevel = 0;
      cfKey = "null";
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUsercodingDataFromDevice() async {
    const storage = FlutterSecureStorage();
    try {
      currentAppOpenedTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String? _userId = await storage.read(key: "uid");

      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/userCodingData.json', _params);

      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);

      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach(
        (key, userCodingData) {
          userHandle = userCodingData['handle'].toString();
          leetcodeHandle = userCodingData['leetcodeHandle'].toString();
          gfgHandle = userCodingData['gfgHandle'].toString();
          _totalScore = int.parse(userCodingData['totalScore'].toString());
          lastSubmissionTime =
              int.parse(userCodingData['lastSubmissionTime'].toString());
          previousLastSubmissionTime = lastSubmissionTime;
          lastAppOpenedTime =
              int.parse(userCodingData['lastAppOpenedTime'].toString());
          totalGrammToken = int.parse(userCodingData['totalGramm'].toString());
        },
      );
      hasAtleastAHandle = hasAtleastOneHandle();
      // final prefs = await SharedPreferences.getInstance();
      // // await prefs.remove('pageIndex');
      // // await prefs.remove('userCodingData');
      // if (!prefs.containsKey('userCodingData')) {
      //   return;
      // }
      // // print(prefs.getString('userCodingData')!);
      // final extractedUserCodingData =
      //     json.decode(prefs.getString('userCodingData')!);
      // userHandle = extractedUserCodingData['handle'].toString();
      // leetcodeHandle = extractedUserCodingData['leetcodeHandle'].toString();
      // gfgHandle = extractedUserCodingData['gfgHandle'].toString();
      // _totalScore = int.parse(extractedUserCodingData['totalScore'].toString());
      // lastSubmissionTime =
      //     int.parse(extractedUserCodingData['lastSubmissionTime'].toString());
      // previousLastSubmissionTime = lastSubmissionTime;
      // lastAppOpenedTime =
      //     int.parse(extractedUserCodingData['lastAppOpenedTime'].toString());
      // totalGrammToken =
      //     int.parse(extractedUserCodingData['totalGramm'].toString());
      print("lastSubmission in get is $lastSubmissionTime");
    } catch (error) {
      throw error;
    }
  }

  bool hasAtleastOneHandle() {
    if (userHandle.isNotEmpty ||
        gfgHandle.isNotEmpty ||
        leetcodeHandle.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getQuestionsListForUser() async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/questionList.json', _params);
      final response = await http.get(url);
      // print("//////");
      // print(_userId);
      // print(response.body);
      // print("//////");
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      print(extractedData);
      cfKey = extractedData.keys.first;
      // print(cfKey);
      for (var item in extractedData.values.first['title']) {
        listOfQuestions.add(item);
      }
      initialLength = listOfQuestions.length;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addUniqueQuestionToDB() async {
    const storage = FlutterSecureStorage();
    if (cfKey == "null" && questionToAddInDB.isNotEmpty) {
      // print("...in add unique question to db...");
      final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/questionList.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
      );

      try {
        String? _userId = await storage.read(key: "uid");
        // print(_userId);
        await http.post(
          url,
          body: json.encode(
            {
              'title': questionToAddInDB,
              'userId': _userId,
            },
          ),
        );
      } catch (error) {
        throw error;
      }
    } else {
      // print("key is: " '$cfKey');
      final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/questionList/$cfKey/title.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
      );

      try {
        for (var questionName in questionToAddInDB) {
          await http.patch(
            url,
            body: json.encode(
              {
                '$initialLength': questionName,
              },
            ),
          );
          initialLength++;
        }
      } catch (error) {
        throw error;
      }
    }
  }

  // Future<void> fetchNftState(bool isLite) async {
  //   const storage = FlutterSecureStorage();
  //   try {
  //     String? _userId = await storage.read(key: "uid");
  //     var _params = <String, String>{
  //       'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
  //       'orderBy': json.encode('userId'),
  //       'equalTo': json.encode(_userId),
  //     };
  //     final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
  //         '/nftState.json', _params);
  //     final response = await http.get(url);
  //     final Map<String, dynamic>? extractedData = json.decode(response.body);
  //     print("///");
  //     if (extractedData == null || extractedData.isEmpty) {
  //       return;
  //     }
  //     print(extractedData);
  //     extractedData.forEach((key, nft) {
  //       nftDBKey = key;
  //       batteryLevel = nft['batteryLevel'];
  //       lagLevel = nft['lagLevel'];
  //       spaceLevel = nft['spaceLevel'];
  //       timeLevel = nft['timeLevel'];
  //       healthLevel = nft['healthLevel'];
  //       spaceIndex = nft['spaceIndex'];
  //       spaceIndexLimitCounter = nft['spaceIndexLimitCounter'];
  //       upgradeKey = nft['upgradeKey'];
  //     });
  //     liteNftMap['batteryPct'] = batteryLevel;
  //     liteNftMap['lagPct'] = lagLevel;
  //     liteNftMap['spaceIndex'] = spaceIndex;
  //     liteNftMap['spaceLevel'] = spaceLevel;
  //     liteNftMap['timeLevel'] = timeLevel;
  //     liteNftMap['healthPct'] = healthLevel;
  //     // print("lag level now is" + '$lagLevel');
  //     if (upgradeKey != "null") {
  //       String tempLastUpgradeTime = upgradeKey.split('u').first;
  //       lastUpgradeTime = int.parse(tempLastUpgradeTime);
  //     }
  //     print("object");
  //     if (!isLite) {
  //       if (hasAtleastAHandle) {
  //         print("Is not lite..");
  //         calculateNftParameters();
  //       } else {
  //         nftMap = liteNftMap;
  //       }
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  void calculateNftParameters() {
    batteryLevel = 100;
    lagLevel = 0;
    timeLevel = 5;
    spaceLevel = 5;
    healthLevel = 100;
    // calculatebatterylevel();
    // calculateLagLevel();
    // calculateSpaceIndex();
    /* logic for degrading space level only applicable for cf and not for leetcode and gfg
    So, we will implement it later when we have numOfCorrectSub and totalSub is available for all platforms*/
    // degradeSpaceLevel();
    // calculateHealthLevel();
    calculateScoreFactor();
    calculateDailyScoreToken();
    calculateGrammToken();
    calculateLeetcodeScoreAndGrammToken(
        easySolvedLc, mediumSolvedLc, hardSolvedLc);
    calculateGfgScoreAndGrammToken(
        basicSolvedGfg, easySolvedGfg, mediumSolvedGfg, hardSolvedGfg);
    calculateTotalScoreToken();
    calculateTotalGrammToken();
    nftMap['batteryPct'] = batteryLevel;
    nftMap['lagPct'] = lagLevel;
    nftMap['spaceIndex'] = spaceIndex;
    nftMap['spaceLevel'] = spaceLevel;
    nftMap['timeLevel'] = timeLevel;
    nftMap['healthPct'] = healthLevel;
    nftMap['grammToken'] = totalGrammToken;
    nftMap['scoreToken'] = _totalScore;
  }

  // void calculatebatterylevel() {
  //   int diffInTime = currentAppOpenedTime - lastAppOpenedTime;
  //   double temp = 20 / 86400;
  //   double reductionInBatteryLevel = temp * diffInTime;
  //   int reductionInBatteryLevelRounded = reductionInBatteryLevel.floor();
  //   print("reduction is :" '$reductionInBatteryLevelRounded');
  //   if (batteryLevel - reductionInBatteryLevelRounded > 0) {
  //     batteryLevel = batteryLevel - reductionInBatteryLevelRounded;
  //   } else {
  //     batteryLevel = 0;
  //   }
  // }

  // void calculateLagLevel() {
  //   if (updatedUserRating > 1401) {
  //     lagLevel = 0;
  //   } else {
  //     /* This if check makes sure that we are calculating lag only when atleast 1 correct submissions has been made*/
  //     if (lastSubmissionTime != previousLastSubmissionTime &&
  //         numOfCorrectSubmissions > 0) {
  //       if (numOfCorrectSubmissions == 1) {
  //         int rangeOfSubmissionTime =
  //             lastSubmissionTime - previousLastSubmissionTime;
  //         if (rangeOfSubmissionTime < 600) {
  //           lagLevel = 28;
  //         }
  //       } else {
  //         int rangeOfSubmissionTime =
  //             lastSubmissionTime - lastSubmissionListLastTime;
  //         double temp = numOfCorrectSubmissions / rangeOfSubmissionTime;
  //         double optimalSubmission = temp * 1800;
  //         int optimalSubmissionFloor = optimalSubmission.floor();

  //         if (optimalSubmissionFloor == 2) {
  //           lagLevel = 0;
  //         } else if (optimalSubmissionFloor == 3) {
  //           lagLevel = 28;
  //         } else if (optimalSubmissionFloor == 4) {
  //           lagLevel = 57;
  //         } else if (optimalSubmissionFloor == 5) {
  //           lagLevel = 85;
  //         } else {
  //           lagLevel = 100;
  //         }
  //       }
  //     }
  //   }
  //   if (lagLevel > 0 && lagLevelLeetcode > 0 && lagLevelGfg > 0) {
  //     lagLevel = min(lagLevel, min(lagLevelLeetcode, lagLevelGfg));
  //   } else if (lagLevel == 0) {
  //     if (lagLevelLeetcode == 0 && lagLevelGfg > 0) {
  //       lagLevel = lagLevelGfg;
  //     } else if (lagLevelLeetcode > 0 && lagLevelGfg == 0) {
  //       lagLevel = lagLevelLeetcode;
  //     } else {
  //       lagLevel = min(lagLevelGfg, lagLevelLeetcode);
  //     }
  //   } else if (lagLevel > 0) {
  //     if (lagLevelLeetcode == 0 && lagLevelGfg > 0) {
  //       lagLevel = min(lagLevel, lagLevelGfg);
  //     } else if (lagLevelLeetcode > 0 && lagLevelGfg == 0) {
  //       lagLevel = min(lagLevel, lagLevelLeetcode);
  //     }
  //   }
  //   // print("lagLevelLeetcode in calcMethod is : " '$lagLevelLeetcode');
  //   // print("lagLevel in calcMethod is : " '$lagLevel');
  // }

  // void calculateSpaceIndex() {
  //   /* Calculating space index only if totalSubmissions>2 to provide leniency*/
  //   if (totalNumOfSubmissions > 2) {
  //     double optimalRatio = numOfCorrectSubmissions / totalNumOfSubmissions;
  //     if (spaceLevel >= 5 && spaceLevel <= 15) {
  //       if (optimalRatio < 0.1) {
  //         spaceIndex = 1;
  //         spaceIndexLimitCounter += 1;
  //       } else if (optimalRatio >= 0.1 && optimalRatio <= 0.3) {
  //         spaceIndex = 2;
  //       } else if (optimalRatio > 0.3) {
  //         spaceIndex = 3;
  //       }
  //     } else if (spaceLevel > 15 && spaceLevel <= 23) {
  //       if (optimalRatio < 0.3) {
  //         spaceIndex = 1;
  //         spaceIndexLimitCounter += 1;
  //       } else if (optimalRatio >= 0.3 && optimalRatio <= 0.5) {
  //         spaceIndex = 2;
  //       } else if (optimalRatio > 0.5) {
  //         spaceIndex = 3;
  //       }
  //     } else if (spaceLevel > 23 && spaceLevel <= 30) {
  //       if (optimalRatio < 0.5) {
  //         spaceIndex = 1;
  //         spaceIndexLimitCounter += 1;
  //       } else if (optimalRatio >= 0.5 && optimalRatio <= 0.9) {
  //         spaceIndex = 2;
  //       } else if (optimalRatio > 0.9) {
  //         spaceIndex = 3;
  //       }
  //     }
  //   }
  // }

  // void degradeSpaceLevel() {
  //   if (spaceIndexLimitCounter >= 2) {
  //     spaceLevel = spaceLevel - 1;
  //     spaceIndexLimitCounter = 0;
  //   }
  // }

  // void calculateHealthLevel() {
  //   int scoreSpendingHealth = 0;
  //   int rewardEarnedHealth = 0;
  //   int appOpeningHealth = 0;
  //   int startTime = currentAppOpenedTime - 604800;
  //   /* Calculating best health level considering last sub time for all platforms*/
  //   int optimalLastSubmissionTime =
  //       max(lastSubmissionTime, lastSubmissionTimeLeetcode);
  //   if (optimalLastSubmissionTime != 0 &&
  //       optimalLastSubmissionTime > startTime) {
  //     rewardEarnedHealth = 30;
  //   }
  //   if (lastUpgradeTime == 0) {
  //     scoreSpendingHealth = 30;
  //   }
  //   if (lastUpgradeTime != 0 && lastUpgradeTime > startTime) {
  //     scoreSpendingHealth = 30;
  //   }
  //   if (updatedUserRating > 1500) {
  //     appOpeningHealth = 40;
  //   } else {
  //     int diffInAppOpeningTime = currentAppOpenedTime - lastAppOpenedTime;
  //     if (diffInAppOpeningTime > 172800) {
  //       appOpeningHealth = 0;
  //     } else if (diffInAppOpeningTime >= 86400 &&
  //         diffInAppOpeningTime <= 172800) {
  //       appOpeningHealth = 20;
  //     } else if (diffInAppOpeningTime < 86400 &&
  //         diffInAppOpeningTime >= 43200) {
  //       appOpeningHealth = 30;
  //     } else {
  //       appOpeningHealth = 40;
  //     }
  //   }
  //   healthLevel = scoreSpendingHealth + rewardEarnedHealth + appOpeningHealth;
  // }

  void calculateScoreFactor() {
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
    if (batteryLevel > 80) {
      batteryFactor = 1;
    } else if (batteryLevel > 50 && batteryLevel <= 80) {
      batteryFactor = 0.9;
    } else if (batteryLevel > 20 && batteryLevel <= 50) {
      batteryFactor = 0.7;
    } else {
      batteryFactor = 0.5;
    }

    /* lag factor*/
    if (lagLevel > 80) {
      lagFactor = 0.5;
    } else if (lagLevel > 50 && lagLevel <= 80) {
      lagFactor = 0.7;
    } else if (lagLevel > 20 && lagLevel <= 50) {
      lagFactor = 0.9;
    } else {
      lagFactor = 1;
    }

    /* health factor*/
    if (healthLevel > 65) {
      healthFactor = 1.0;
    } else if (healthLevel > 40 && healthLevel <= 65) {
      healthFactor = 0.99;
    } else if (healthLevel > 10 && healthLevel <= 40) {
      healthFactor = 0.95;
    } else if (healthLevel > 0 && healthLevel <= 10) {
      healthFactor = 0.9;
    } else {
      healthFactor = 0.0;
    }

    double nonCoreFactor = batteryFactor * lagFactor;
    double coreFactor = timeMap[timeLevel]! + spaceMap[spaceLevel]!;
    double tempScoreFactor = coreFactor * nonCoreFactor;
    scoreFactor = pow(tempScoreFactor, healthFactor).toDouble();
    // print("Score factor is - " '$scoreFactor');
  }

  void calculateDailyScoreToken() {
    double tempScoreToken = _dailyScore * scoreFactor;
    dailyScoreToken = tempScoreToken.ceil();
  }

  void calculateGrammToken() {
    dailyGrammToken = (spaceLevel + timeLevel) * dailyScoreToken;
    dailyGrammToken = (dailyGrammToken / 100).ceil();
  }

  void calculateTotalScoreToken() {
    // print(dailyScoreAvailable);
    // if (dailyScoreAvailable == true) {
    _totalScore += dailyScoreToken + leetScoreToken + gfgScoreToken;
    // dailyScoreAvailable = false;
    // }
  }

  void calculateTotalGrammToken() {
    totalGrammToken += dailyGrammToken + leetGrammToken + gfgGrammToken;
  }

  // Future<void> updateNftState() async {
  //   if (nftDBKey.isNotEmpty) {
  //     try {
  //       final url = Uri.https(
  //           'grammit-70261-default-rtdb.firebaseio.com',
  //           '/nftState/$nftDBKey.json',
  //           {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
  //       await http.patch(
  //         url,
  //         body: json.encode({
  //           'batteryLevel': batteryLevel,
  //           'healthLevel': healthLevel,
  //           'lagLevel': lagLevel,
  //           'timeLevel': timeLevel,
  //           'spaceLevel': spaceLevel,
  //           'spaceIndex': spaceIndex,
  //           'spaceIndexLimitCounter': spaceIndexLimitCounter,
  //         }),
  //       );
  //       notifyListeners();
  //     } catch (error) {
  //       throw error;
  //     }
  //   }
  // }

  /*
    Leetcode integration
  */

  Future<bool> postLeetCodeInitialStateToDB(String leetHandle) async {
    lastSubmissionTimeLeetcode = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var url =
        Uri.https('grammit-leetcode-scraping.as.r.appspot.com', '/$leetHandle');
    const storage = FlutterSecureStorage();

    try {
      String? _userId = await storage.read(key: "uid");
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return false;
      }
      // print(extractedData);
      if (extractedData['status'] == "success") {
        leetcodeHandle = leetHandle;
        // Map<String, dynamic>? submissionCalendar =
        // extractedData['submissionCalendar'];
        // print(submissionCalendar);
        // List<String> submissionTime = submissionCalendar!.keys.toList();
        url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/leetcode.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
        );
        await http.post(
          url,
          body: json.encode(
            {
              'userId': _userId,
              'totalSolved': extractedData['totalSolved'],
              'easySolved': extractedData['easySolved'],
              'mediumSolved': extractedData['mediumSolved'],
              'hardSolved': extractedData['hardSolved'],
              'acceptanceRate': extractedData['acceptanceRate'],
              // 'firstSubmissionTime': submissionTime[submissionTime.length - 1],
              // 'secondSubmissionTime': submissionTime[submissionTime.length - 2],
              // 'tenthSubmissionTime': submissionTime[0],
              'lastSubmissionTime': lastSubmissionTimeLeetcode,
            },
          ),
        );
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  int lastSubmissionTimeLeetcode = 0;
  Future<void> getLastestLeetcodeState() async {
    if (leetcodeHandle.isNotEmpty) {
      print("Fetching leetcode state...");
      int lagCount = 0;

      var url = Uri.https(
          'grammit-leetcode-scraping.as.r.appspot.com', '/$leetcodeHandle');
      const storage = FlutterSecureStorage();
      try {
        String? _userId = await storage.read(key: "uid");
        final response = await http.get(url);
        final Map<String, dynamic>? extractedData = json.decode(response.body);
        if (extractedData == null || extractedData.isEmpty) {
          return;
        }
        // print(extractedData);
        Map<String, dynamic>? submissionCalendar =
            extractedData['submissionCalendar'];
        List<String> submissionTime = submissionCalendar!.keys.toList();
        if (submissionTime.isNotEmpty) {
          lastSubmissionTimeLeetcode =
              int.parse(submissionTime[submissionTime.length - 1]);
        } else {
          lastSubmissionTimeLeetcode =
              DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }

        int easySolvedNew = extractedData['easySolved'];
        int mediumSolvedNew = extractedData['mediumSolved'];
        int hardSolvedNew = extractedData['hardSolved'];
        int easySolvedOld = 0;
        int mediumSolvedOld = 0;
        int hardSolvedOld = 0;
        var _params = <String, String>{
          'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
          'orderBy': json.encode('userId'),
          'equalTo': json.encode(_userId),
        };

        url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/leetcode.json',
          _params,
        );

        final dbResponse = await http.get(url);
        final Map<String, dynamic>? extractedDbData =
            json.decode(dbResponse.body);
        if (extractedDbData == null || extractedDbData.isEmpty) {
          print(extractedDbData);
          print("+++++++++++++++++++");
          url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/leetcode.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
          );
          await http.post(
            url,
            body: json.encode(
              {
                'userId': _userId,
                'totalSolved': extractedData['totalSolved'],
                'easySolved': extractedData['easySolved'],
                'mediumSolved': extractedData['mediumSolved'],
                'hardSolved': extractedData['hardSolved'],
                'acceptanceRate': extractedData['acceptanceRate'],
                // 'firstSubmissionTime': submissionTime[submissionTime.length - 1],
                // 'secondSubmissionTime': submissionTime[submissionTime.length - 2],
                // 'tenthSubmissionTime': submissionTime[0],
                'lastSubmissionTime': lastSubmissionTimeLeetcode,
              },
            ),
          );
        } else {
          String _leetcodeKey = "";
          extractedDbData.forEach((key, leetCodeState) {
            _leetcodeKey = key;
            easySolvedOld = leetCodeState['easySolved'];
            mediumSolvedOld = leetCodeState['mediumSolved'];
            hardSolvedOld = leetCodeState['hardSolved'];
          });
          if (easySolvedNew == easySolvedOld &&
              mediumSolvedNew == mediumSolvedOld &&
              hardSolvedNew == hardSolvedOld) {
            print("No leetcode submissions!");
            // Nothing to do
          } else {
            /* 
            lag level needs to be calculated only when a new submission has been made. 
            Lag needs to be calculated after the last submission. (like how it's happening for cf)
            Currently, there is an error since time in submission calendar always shows 5:30 am of that day irrespective of 
            the actual submission time, so upgrade time is higher and lag is not calculated.
            Right now, there is no fix for this. We will keep it this way since this approach is lenient for the user.
          */
            List<dynamic> numOfSubmissions = [];
            submissionCalendar.forEach((key, value) {
              if (int.parse(key) > lastUpgradeTime) {
                // print("key is " '$key');
                numOfSubmissions.add(value);
              }
            });
            for (var element in numOfSubmissions) {
              if (element >= 15) {
                lagCount++;
              }
            }
            calculateLagLevelLeetCode(lagCount);
            url = Uri.https(
              'grammit-70261-default-rtdb.firebaseio.com',
              '/leetcode/$_leetcodeKey.json',
              {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
            );
            await http.patch(
              url,
              body: json.encode(
                {
                  // 'userId': _userId,
                  'totalSolved': extractedData['totalSolved'],
                  'easySolved': extractedData['easySolved'],
                  'mediumSolved': extractedData['mediumSolved'],
                  'hardSolved': extractedData['hardSolved'],
                  'acceptanceRate': extractedData['acceptanceRate'],
                  'lastSubmissionTime': lastSubmissionTimeLeetcode,
                  // 'firstSubmissionTime':
                  // submissionTime[submissionTime.length - 1],
                  // 'secondSubmissionTime':
                  // submissionTime[submissionTime.length - 2],
                  // 'tenthSubmissionTime': submissionTime[0],
                },
              ),
            );
            easySolvedLc = easySolvedNew - easySolvedOld;
            mediumSolvedLc = mediumSolvedNew - mediumSolvedOld;
            hardSolvedLc = hardSolvedNew - hardSolvedOld;
            // calculateLeetcodeScoreAndGrammToken(easySolvedNew - easySolvedOld,
            // mediumSolvedNew - mediumSolvedOld, hardSolvedNew - hardSolvedOld);
            // await postLeetcodeRewardToDB(
            // int.parse(submissionTime[submissionTime.length - 1]));
          }
        }
      } catch (error) {
        throw error;
      }
    }
  }

  int leetScoreToken = 0;
  int leetGrammToken = 0;
  void calculateLeetcodeScoreAndGrammToken(int easy, int medium, int hard) {
    int leetScore = 4 * easy + 8 * medium + 16 * hard;
    // print(leetScore);
    // print(scoreFactor);
    leetScoreToken = (leetScore * scoreFactor).ceil();
    leetGrammToken = (timeLevel + spaceLevel) * leetScoreToken;
    leetGrammToken = 2 * (leetGrammToken / 100).ceil();
  }

  Future<void> postLeetcodeRewardToDB(int rewardTime) async {
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
            'lastScoreGained': leetScoreToken,
            'grammToken': leetGrammToken,
            // 'totalGrammToken': -1,
            'lastRewardedTime': rewardTime,
            'userId': _userId,
            'platform': "lc",
            // 'numOfCorrectSubmissions': -1,
            // 'totalNumOfSubmissions': -1,
          },
        ),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  int lagLevelLeetcode = 0;
  void calculateLagLevelLeetCode(int lagCount) {
    // print("object");
    lagLevelLeetcode = lagCount * 5;
    // print("lag level is :" '$lagFactorLeetcode');
  }

  /*
    GFG integration
  */
  int lastSubmissionTimeGfg = 0;
  Future<bool> postGfgInitialStateToDB(String handle) async {
    lastSubmissionTimeGfg = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var url = Uri.https('grammit-gfg-scraping.as.r.appspot.com', '/$handle');
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      final response = await http.get(url);
      if (response.statusCode != 200) {
        print(response.statusCode);
        return false;
      }
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null || extractedData.isEmpty) {
        return false;
      }
      url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/geeksForGeeks.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
      );
      // print(extractedData['solvedStats']['basic']['count']);
      if (extractedData['info']['username'] == "Profile not found") {
        return false;
      } else {
        gfgHandle = handle;
        // String _lastSubmittedString = extractedData["lastSubmitted"];
        // int _numOfSubmissions = int.tryParse(_lastSubmittedString[0]) ?? 0;
        int _numOfSubmissions = 0;
        // String _timeString = _lastSubmittedString.split('y ').last;
        // DateFormat formatter = DateFormat("MMMM d, yyyy");
        // DateTime formatted = formatter.parse(_timeString);
        // int _lastSubmittedTime = formatted.millisecondsSinceEpoch ~/ 1000;
        int _lastSubmittedTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        await http.post(
          url,
          body: json.encode(
            {
              'userId': _userId,
              'basic': int.tryParse(extractedData['solvedStats']['basic']
                          ['count']
                      .toString()) ??
                  0,
              'easy': int.tryParse(extractedData['solvedStats']['easy']['count']
                      .toString()) ??
                  0,
              'medium': int.tryParse(extractedData['solvedStats']['medium']
                          ['count']
                      .toString()) ??
                  0,
              'hard': int.tryParse(extractedData['solvedStats']['hard']['count']
                      .toString()) ??
                  0,
              'numOfSubmissions': _numOfSubmissions,
              'lastSubmittedTime': _lastSubmittedTime,
            },
          ),
        );
        return true;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getLatestGfgState() async {
    if (gfgHandle.isNotEmpty) {
      print("Fetching gfg state...");
      const storage = FlutterSecureStorage();
      try {
        String? _userId = await storage.read(key: "uid");
        var url =
            Uri.https('grammit-gfg-scraping.as.r.appspot.com', '/$gfgHandle');
        final response = await http.get(url);
        if (response.statusCode != 200) {
          print(response.statusCode);
          return;
        }
        final Map<String, dynamic>? extractedData = json.decode(response.body);
        if (extractedData == null || extractedData.isEmpty) {
          return;
        }
        int newBasic = int.tryParse(
                extractedData['solvedStats']['basic']['count'].toString()) ??
            0;
        int newEasy = int.tryParse(
                extractedData['solvedStats']['easy']['count'].toString()) ??
            0;
        int newMedium = int.tryParse(
                extractedData['solvedStats']['medium']['count'].toString()) ??
            0;
        int newHard = int.tryParse(
                extractedData['solvedStats']['hard']['count'].toString()) ??
            0;

        // String _lastSubmittedString = extractedData["lastSubmitted"];
        // int newNumOfSubmissions = int.tryParse(_lastSubmittedString[0]) ?? 0;
        int newNumOfSubmissions = 0;
        // String _timeString = _lastSubmittedString.split('y ').last;
        // DateFormat formatter = DateFormat("MMMM d, yyyy");
        // DateTime formatted = formatter.parse(_timeString);
        // int newLastSubmittedTime = formatted.millisecondsSinceEpoch ~/ 1000;
        int newLastSubmittedTime =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;

        lastSubmissionTimeGfg = newLastSubmittedTime;

        int oldBasic = 0;
        int oldEasy = 0;
        int oldMedium = 0;
        int oldHard = 0;
        int oldNumOfSubmissions = 0;
        int oldLastSubmittedTime = 0;

        var _params = <String, String>{
          'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
          'orderBy': json.encode('userId'),
          'equalTo': json.encode(_userId),
        };

        url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/geeksForGeeks.json',
          _params,
        );

        final dbResponse = await http.get(url);
        final Map<String, dynamic>? extractedDbData =
            json.decode(dbResponse.body);

        if (extractedDbData == null || extractedDbData.isEmpty) {
          url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/geeksForGeeks.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
          );
          // print(extractedData['solvedStats']['basic']['count']);
          await http.post(
            url,
            body: json.encode(
              {
                'userId': _userId,
                'basic': int.tryParse(extractedData['solvedStats']['basic']
                            ['count']
                        .toString()) ??
                    0,
                'easy': int.tryParse(extractedData['solvedStats']['easy']
                            ['count']
                        .toString()) ??
                    0,
                'medium': int.tryParse(extractedData['solvedStats']['medium']
                            ['count']
                        .toString()) ??
                    0,
                'hard': int.tryParse(extractedData['solvedStats']['hard']
                            ['count']
                        .toString()) ??
                    0,
                'numOfSubmissions': newNumOfSubmissions,
                'lastSubmittedTime': newLastSubmittedTime,
              },
            ),
          );
        } else {
          String _gfgKey = "";
          extractedDbData.forEach((key, gfgState) {
            _gfgKey = key;
            oldBasic = gfgState['basic'];
            oldEasy = gfgState['easy'];
            oldMedium = gfgState['medium'];
            oldHard = gfgState['hard'];
            oldNumOfSubmissions = gfgState['numOfSubmissions'];
            oldLastSubmittedTime = gfgState['lastSubmittedTime'];
          });
          if (oldBasic == newBasic &&
              oldEasy == newEasy &&
              oldMedium == newMedium &&
              oldHard == newHard) {
            print("No gfg submissions");
          } else {
            url = Uri.https(
              'grammit-70261-default-rtdb.firebaseio.com',
              '/geeksForGeeks/$_gfgKey.json',
              {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
            );
            await http.patch(
              url,
              body: json.encode(
                {
                  'basic': newBasic,
                  'easy': newEasy,
                  'medium': newMedium,
                  'hard': newHard,
                },
              ),
            );
            int _totalNumOfSubmissions = (newBasic - oldBasic) +
                (newEasy - oldEasy) +
                (newMedium - oldMedium) +
                (newHard - oldHard);
            calculateLagLevelGfg(
                oldLastSubmittedTime,
                newLastSubmittedTime,
                oldNumOfSubmissions,
                newNumOfSubmissions,
                _totalNumOfSubmissions);
            basicSolvedGfg = newBasic - oldBasic;
            easySolvedGfg = newEasy - oldEasy;
            mediumSolvedGfg = newMedium - oldMedium;
            hardSolvedGfg = newHard - oldHard;
            // calculateGfgScoreAndGrammToken(newBasic - oldBasic, newEasy - oldEasy,
            // newMedium - oldMedium, newHard - oldHard);
            // await postGfgRewardToDb(newLastSubmittedTime);
          }
        }
      } catch (error) {
        throw error;
      }
    }
  }

  int lagLevelGfg = 0;
  void calculateLagLevelGfg(
      int oldSubmissionTime,
      int newSubmissionTime,
      int oldNumOfSubmissions,
      int newNumOfSubmissions,
      int totalNumOfSubmissions) {
    if (lastUpgradeTime >= newSubmissionTime) {
      lagLevelGfg = 0;
    }
    if (lastUpgradeTime >= oldSubmissionTime &&
        lastUpgradeTime <= newSubmissionTime) {
      if (newNumOfSubmissions > 25) {
        lagLevelGfg = 25;
      } else if (newNumOfSubmissions < 25 && newNumOfSubmissions > 20) {
        lagLevelGfg = 20;
      } else if (newNumOfSubmissions < 20 && newNumOfSubmissions > 15) {
        lagLevelGfg = 15;
      } else {
        lagLevelGfg = 0;
      }
    }
    if (lastUpgradeTime < oldSubmissionTime) {
      if (oldSubmissionTime == newSubmissionTime) {
        if (totalNumOfSubmissions > 25) {
          lagLevelGfg = 25;
        } else if (totalNumOfSubmissions < 25 && totalNumOfSubmissions > 20) {
          lagLevelGfg = 20;
        } else if (totalNumOfSubmissions < 20 && totalNumOfSubmissions > 15) {
          lagLevelGfg = 15;
        } else {
          lagLevelGfg = 0;
        }
      } else {
        int _rangeOfTime = newSubmissionTime - oldSubmissionTime;
        int _numOfDays = (_rangeOfTime / 24 * 60 * 60).floor();
        int _optimalNumOfSubmissions = 15 * _numOfDays;
        if (totalNumOfSubmissions <= _optimalNumOfSubmissions) {
          lagLevelGfg = 0;
        } else {
          if (totalNumOfSubmissions > 2 * _optimalNumOfSubmissions) {
            lagLevelGfg = 50;
          } else {
            lagLevelGfg = 25;
          }
        }
      }
    }
  }

  int gfgScoreToken = 0;
  int gfgGrammToken = 0;
  void calculateGfgScoreAndGrammToken(
      int basic, int easy, int medium, int hard) {
    int gfgScore = 2 * basic + 4 * easy + 8 * medium + 16 * hard;
    print(gfgScore);
    gfgScoreToken = (gfgScore * scoreFactor).ceil();
    gfgGrammToken = (spaceLevel + timeLevel) * gfgScoreToken;
    gfgGrammToken = 2 * (gfgGrammToken / 100).ceil();
  }

  Future<void> postGfgRewardToDb(int lastRewardTime) async {
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
            'userId': _userId,
            'lastScoreGained': gfgScoreToken,
            'grammToken': gfgGrammToken,
            'lastRewardedTime': lastRewardTime,
            'platform': "gfg",
          },
        ),
      );
    } catch (error) {
      throw error;
    }
  }
}
