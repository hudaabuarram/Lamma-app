import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class hhh extends StatelessWidget{

  void getGoogleUserCredentials() async {

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email']
    );
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn(

    );
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    print(googleSignInAuthentication.accessToken);
    // AuthCredential credential = GoogleAuthProvider.credential(
    //     idToken: googleSignInAuthentication.idToken,
    //     accessToken: googleSignInAuthentication.accessToken);
    // FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    //   isUserExist(
    //       uId: value.user!.uid,
    //       name: value.user!.displayName,
    //       phone: value.user!.phoneNumber,
    //       email: value.user!.email,
    //       profilePic: value.user!.photoURL
    //   );
    //
    // });
  }
  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body:
      MaterialButton(
       color: Colors.teal,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

    onPressed: () {  getGoogleUserCredentials();},
    child: Text(
    'ok',
    style: TextStyle(
    color: Colors.white,
    fontSize: 17,
    ),
    ),
    ),
    );


  }

}