import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:lamma/Models/UserModel.dart';
import 'package:lamma/cubit/states.dart';
//import 'package:twitter_login/twitter_login.dart';



class LoginCubit extends Cubit<SocialStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? loginModel;

  void signIn({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState());
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  bool userExist = false;
  Future <void> isUserExist({
    required String? uId,
    required String? name,
    required String? phone,

    required String? email,
    required String? profilePic

  }) async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.id == uId)
          userExist = true;
      });
      if(userExist == false) {
        createGoogleUser(
            uId: uId,
            name: name,
            phone: phone,
            email: email,
            profilePic: profilePic
        );
      }
      else
        emit(LoginGoogleUserSuccessState(uId!));
    });
  }

  void getGoogleUserCredentials() async {
    emit(LoginGoogleUserLoadingState());
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      isUserExist(
          uId: value.user!.uid,
          name: value.user!.displayName,
          phone: value.user!.phoneNumber,
          email: value.user!.email,
          profilePic: value.user!.photoURL
      );

    });
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }


  void createGoogleUser({
    required String? uId,
    required String? name,
    required String? phone,
    required String? email,
    required String? profilePic
  }) {
    UserModel model = UserModel(
      uID: uId,
      name: name,
      phone: phone?? '0000-000-0000',
      email: email,

      coverPic: 'https://static.vecteezy.com/system/resources/previews/001/361/540/large_2x/blue-watercolor-background-free-vector.jpg',
      profilePic: profilePic ?? 'https://i.pinimg.com/originals/1c/42/db/1c42dbe4cfb44025ac69d041568cf2c5.jpg',
      bio: 'Write you own bio...',
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap())
        .then((value) {
      emit(CreateGoogleUserSuccessState(uId!));
    }).catchError((error) {
      emit(CreateGoogleUserErrorState());
    });
  }
  //
  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }



  // Future<UserCredential> signInWithTwitter() async {
  //   // Create a TwitterLogin instance
  //   final twitterLogin = new TwitterLogin(
  //       apiKey: '<your consumer key>',
  //       apiSecretKey:' <your consumer secret>',
  //       redirectURI: '<your_scheme>://'
  //   );
  //
  //   // Trigger the sign-in flow
  //   final authResult = await twitterLogin.login();
  //
  //   // Create a credential from the access token
  //   final twitterAuthCredential = TwitterAuthProvider.credential(
  //     accessToken: authResult.authToken!,
  //     secret: authResult.authTokenSecret!,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  // }







  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }




}