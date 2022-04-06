import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamma/Models/UserModel.dart';
import 'package:lamma/cubit/states.dart';



class RegisterCubit extends Cubit<SocialStates>{
  RegisterCubit() : super(InitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.uid);
      createUser(
        uId: value.user!.uid,
        name: name,
        phone: phone,
        email: email,
      );
      emit(SignUpSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(SignUpErrorState());
    });
  }

  void createUser({
    required String? uId,
    required String? name,
    required String? phone,
    required String? email,
  }) {
    emit(CreateUserLoadingState());
    UserModel model = UserModel(
        uID: uId,
        name: name,
        phone: phone,
        email: email,
        dateTime: FieldValue.serverTimestamp(),
        coverPic: 'https://static.vecteezy.com/system/resources/previews/001/361/540/large_2x/blue-watercolor-background-free-vector.jpg',
        profilePic: 'https://i.pinimg.com/originals/1c/42/db/1c42dbe4cfb44025ac69d041568cf2c5.jpg',
        bio: 'Write you own bio...'
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState(uId!));
    }).catchError((error) {
      emit(CreateUserErrorState());
    });
  }



  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }


}