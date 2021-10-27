import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/models/social_app/message_model.dart';
import 'package:social_app/models/social_app/post_model.dart';
import 'package:social_app/models/social_app/social_user_model.dart';
import 'package:social_app/modules/social_app/new_post_screen/new_post_screen.dart';
import 'package:social_app/modules/social_app/social_chats_screen/chats_screen.dart';
import 'package:social_app/modules/social_app/social_feeds_screen/feeds_screen.dart';
import 'package:social_app/modules/social_app/social_settings_screen/settings_screen.dart';
import 'package:social_app/modules/social_app/social_users_screen/users_screen.dart';
import 'package:social_app/shared/compmnant/conestants.dart';
class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel ? userModel;

  void getUserData()
  {

    emit(SocialGetUserLoadingState());
    getPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          userModel = SocialUserModel.fromJson(value.data()!);
          emit(SocialGetUserSuccessState());
    })
        .catchError((error)
    {
      print(error);
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  late int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'New Post',
    'Users',
    'Settings',
  ];


  void ChangeBottomNav (int index)
  {
    if(index == 1)
      {
       getUsers();
      }
    if(index == 2)
      emit(SocialNewPostState());
    else
      {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File ? profileImage;
  final picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final  pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('no image selected .');
      emit(SocialProfileImagePickedErrorState());
    }

  }

  File ? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage ({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
          value.ref.getDownloadURL()
              .then((value) {
            //emit(SocialProfileImageUploadSuccessState());
                print(value);
            updateUser(
              name: name,
              phone: phone,
              bio: bio,
              image:  value,
            );
          }).catchError((error){
            emit(SocialProfileImageUploadErrorState());
          });
    }).catchError((error){
      emit(SocialProfileImageUploadErrorState());
    });
  }


  void uploadCoverImage ({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
       // emit(SocialCoverImageUploadSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error){
        emit(SocialCoverImageUploadErrorState());
      });
    }).catchError((error){
      emit(SocialCoverImageUploadErrorState());
    });
  }

//   void updateUserImages({
//     required String name,
//     required String phone,
//     required String bio,
// })
//   {
//     emit(SocialUserUpdateLoadingState());
//     if(coverImage != null)
//       {
//         uploadCoverImage();
//       } else if (profileImage != null)
//         {
//           uploadProfileImage();
//         } else if (coverImage != null && profileImage != null)
//         {
//
//         }else
//           {
//             updateUser(
//               name: name,
//               phone: phone,
//               bio: bio,
//             );
//           }
//   }

  void updateUser ({
    required String name,
    required String phone,
    required String bio,
    String ? cover,
    String ? image,
})
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      email: userModel!.email,
      cover: cover?? userModel!.cover,
      image: image?? userModel!.image,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error){
      emit(SocialUserUpdateErrorState());
    });
  }

  File ? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage ()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }
  void uploadPostImage({
    required String dateTime,
    required String text,
  })
  {
    emit(SocialCretePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        // emit(SocialCoverImageUploadSuccessState());
        createPost(
            dateTime: dateTime,
            text: text,
            postImage: value,
        );
        print(value);

      }).catchError((error){
        emit(SocialCretePostErrorState());
      });
    }).catchError((error){
      emit(SocialCretePostErrorState());
    });
  }


  void createPost ({
    required String dateTime,
    required String text,
    String ? postImage,
  })
  {
    emit(SocialCretePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance.collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCretePostSuccessState());
    }).catchError((error){
      emit(SocialCretePostErrorState());
    });
  }

  List<PostModel> posts =[];
  List<String> postsId =[];
  List<int> likes =[];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            element.reference.collection('likes')
                .get()
                .then((value)
            {
              likes.add(value.docs.length);
              postsId.add(element.id);
              posts.add(PostModel.fromJson(element.data()));
            }).catchError((error){});

          });
          emit(SocialGetPostsSuccessState());
    }).catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'likes' : true
    }).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error)
    {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }

  List<SocialUserModel>  users = [] ;

  void getUsers()
  {
    if(users.length == 0)
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.data()['uId'] != userModel!.uId)
          {
            users.add(SocialUserModel.fromJson(element.data()));
          }
      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error){
      emit(SocialGetAllUserErrorState(error.toString()));
    });
  }

  void sendMessage({
  required String ? receiverId,
    required String dateTime,
    required String text,
})
  {
    MessageModel model = MessageModel (
      senderId: userModel!.uId,
      receiverTd: receiverId,
      dateTime: dateTime,
      text: text,
    );
    // my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState());
    });
    // receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String ? receiverId,
})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event) {
         messages = [];
       event.docs.forEach((element) {
         messages.add(MessageModel.fromJson(element.data()));
       });
       emit(SocialGetMessagesSuccessState());
    });
  }
}


