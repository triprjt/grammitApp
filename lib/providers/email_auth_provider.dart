import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/toggle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  final storage = FlutterSecureStorage();

  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await storage.write(key: "uid", value: userCredential.user?.uid);

    notifyListeners();
  }
}

// FirebaseAuth.instance.currentUser().then((firebaseUser){
//   if(firebaseUser == null)
//    {
//      //signed out
//    }
//    else{
//     //signed in
//   }
// });
