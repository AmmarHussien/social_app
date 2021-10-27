

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_app/social_user_model.dart';
import 'package:social_app/modules/social_app/social_register_screen/cubit/states.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates>
{

  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context)
      => BlocProvider.of(context);

  //SocialLoginModel ? LoginModel;

  void userRegister({
  required String email,
    required String password,
    required String name,
    required String phone,

})
  {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,

      );
      //emit(SocialRegisterSuccessState());
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,

})
  {
    SocialUserModel model = SocialUserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        bio: 'Write your bio',
        image: 'https://image.freepik.com/free-photo/pretty-woman-with-afro-hairstyle-holds-modern-cellphone-takeaway-coffee-spends-free-time-chatting-online_273609-33268.jpg',
        cover: 'https://image.freepik.com/free-photo/pretty-woman-with-afro-hairstyle-holds-modern-cellphone-takeaway-coffee-spends-free-time-chatting-online_273609-33268.jpg',
        isEmailVerified: false,


    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {

        emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true ;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix =isPassword? Icons.visibility_outlined :Icons.visibility_off_outlined;

    emit(SocialChangePasswordVisibilityState());
  }


}