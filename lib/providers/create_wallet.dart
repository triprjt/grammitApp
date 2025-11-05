import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class userDetail {
  String userId;
  String xpub;
  String? mnemonic;

  userDetail({
    required this.userId,
    required this.xpub,
    this.mnemonic,
  });
}

class CreateWallet with ChangeNotifier {
  String? _xpub;
  String? _mnemonic;
  String? _userId;
  String? _acctId;

  String? get xpub {
    return _xpub;
  }

  String? get mnemonic {
    return _mnemonic;
  }

  String? get acctId {
    return _acctId;
  }

  // Future<void> getuserId() async {
  //   const storage = FlutterSecureStorage();
  //   try {
  //     _userId = await storage.read(key: "uid");
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> createWalletFromTatum() async {
    var url = Uri.https('api-eu1.tatum.io', '/v3/polygon/wallet');
    try {
      final response = await http.get(
        url,
        headers: {"x-api-key": "dbf46f2e-c036-417c-904e-b43f2840d1b7"},
      );
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      _xpub = extractedData['xpub'];
      _mnemonic = extractedData['mnemonic'];

      url = Uri.https('api-eu1.tatum.io', '/v3/polygon/address/$_xpub/0');
      final acctResponse = await http.get(url);
      final Map<String, dynamic>? extractedAcctResponse =
          json.decode(acctResponse.body);
      if (extractedAcctResponse == null || extractedAcctResponse.isEmpty) {
        return;
      }
      // print(extractedAcctResponse);
      _acctId = extractedAcctResponse['address'];

      await postUserDataToDB();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserDataToDB() async {
    final url = Uri.https(
      'grammit-70261-default-rtdb.firebaseio.com',
      '/userData.json',
      {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'},
    );
    const storage = FlutterSecureStorage();

    try {
      _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode({
          'xpub': _xpub,
          'mnemonic': _mnemonic,
          'acctId': _acctId,
          'userId': _userId,
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserDataFromDB() async {
    const storage = FlutterSecureStorage();
    _userId = await storage.read(key: "uid");
    var _params = <String, String>{
      'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
      'orderBy': json.encode('userId'),
      'equalTo': json.encode(_userId),
    };
    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com', '/userData.json', _params);
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedUserData =
          json.decode(response.body);
      if (extractedUserData == null || extractedUserData.isEmpty) {
        return;
      }
      // print(extractedUserData);
      extractedUserData.forEach((key, userItem) {
        _acctId = userItem['acctId'];
        _mnemonic = userItem['mnemonic'];
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> setPageIndexToDevice(int index) async {
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      String _dbKey = "";
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      var url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/pageIndex.json', _params);

      final response = await http.get(url);
      Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/pageIndex.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});

        await http.post(
          url,
          body: json.encode(
            {
              'index': 0,
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
            '/pageIndex/$_dbKey.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});

        await http.patch(
          url,
          body: json.encode(
            {
              'index': index,
            },
          ),
        );
      }

      // final prefs = await SharedPreferences.getInstance();
      // String pageIndex = "";
      // pageIndex = json.encode({
      //   'index': index,
      // });
      // prefs.setString(userId!, pageIndex);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfInviteCodeExists(String inviteCode) async {
    try {
      final url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/inviteCodes.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      List<String> _inviteCodes = [];
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        return false;
      }
      for (var invite in extractedData.values.first) {
        _inviteCodes.add(invite);
      }
      if (_inviteCodes.contains(inviteCode)) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> postEmailToDB(String email) async {
    try {
      var url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/emailList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      List<String> emailList = [];
      if (extractedData == null || extractedData.isEmpty) {
        await http.post(url,
            body: json.encode({
              '0': email,
            }));
      } else {
        String key = extractedData.keys.first;
        int lengthOfList = 0;
        for (var item in extractedData.values.first) {
          emailList.add(item);
        }
        lengthOfList = emailList.length;
        url = Uri.https(
            'grammit-70261-default-rtdb.firebaseio.com',
            '/emailList/$key.json',
            {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
        await http.patch(url,
            body: json.encode({
              '$lengthOfList': email,
            }));
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfDuplicateCodeforcesHandle(String handle) async {
    try {
      var url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/handleList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      // print(response);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        await http.post(url,
            body: json.encode({
              '0': handle,
            }));
        return false;
      } else {
        List<String> handleList = [];
        String key = extractedData.keys.first;
        int lengthOfList = 0;
        for (var item in extractedData.values.first) {
          handleList.add(item);
        }
        // print(extractedData);
        // print(key);
        lengthOfList = handleList.length;
        if (handleList.contains(handle)) {
          return true;
        } else {
          url = Uri.https(
              'grammit-70261-default-rtdb.firebaseio.com',
              '/handleList/$key.json',
              {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
          await http.patch(url,
              body: json.encode({
                '$lengthOfList': handle,
              }));

          return false;
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfDuplicateLeetcodeHandle(String handle) async {
    try {
      var url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/leetcodeHandleList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      // print(response);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        await http.post(url,
            body: json.encode({
              '0': handle,
            }));
        return false;
      } else {
        List<String> handleList = [];
        String key = extractedData.keys.first;
        int lengthOfList = 0;
        for (var item in extractedData.values.first) {
          handleList.add(item);
        }
        // print(extractedData);
        // print(key);
        lengthOfList = handleList.length;
        if (handleList.contains(handle)) {
          return true;
        } else {
          url = Uri.https(
              'grammit-70261-default-rtdb.firebaseio.com',
              '/leetcodeHandleList/$key.json',
              {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
          await http.patch(url,
              body: json.encode({
                '$lengthOfList': handle,
              }));

          return false;
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfDuplicateGfgHandle(String handle) async {
    try {
      var url = Uri.https(
          'grammit-70261-default-rtdb.firebaseio.com',
          '/gfgHandleList.json',
          {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
      final response = await http.get(url);
      // print(response);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null || extractedData.isEmpty) {
        await http.post(url,
            body: json.encode({
              '0': handle,
            }));
        return false;
      } else {
        List<String> handleList = [];
        String key = extractedData.keys.first;
        int lengthOfList = 0;
        for (var item in extractedData.values.first) {
          handleList.add(item);
        }
        // print(extractedData);
        // print(key);
        lengthOfList = handleList.length;
        if (handleList.contains(handle)) {
          return true;
        } else {
          url = Uri.https(
              'grammit-70261-default-rtdb.firebaseio.com',
              '/gfgHandleList/$key.json',
              {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
          await http.patch(url,
              body: json.encode({
                '$lengthOfList': handle,
              }));

          return false;
        }
      }
    } catch (error) {
      throw error;
    }
  }
}
