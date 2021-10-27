
abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{

  final String error;
  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates{}

class SocialProfileImagePickedErrorState extends SocialStates{}

class SocialCoverImagePickedSuccessState extends SocialStates{}

class SocialCoverImagePickedErrorState extends SocialStates{}

class SocialProfileImageUploadSuccessState extends SocialStates{}

class SocialProfileImageUploadErrorState extends SocialStates{}

class SocialCoverImageUploadSuccessState extends SocialStates{}

class SocialCoverImageUploadErrorState extends SocialStates{}

class SocialUserUpdateLoadingState extends SocialStates{}

class SocialUserUpdateErrorState extends SocialStates{}

//// create post
class SocialCretePostLoadingState extends SocialStates{}

class SocialCretePostSuccessState extends SocialStates{}

class SocialCretePostErrorState extends SocialStates{}

class SocialPostImagePickedSuccessState extends SocialStates{}

class SocialPostImagePickedErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}


//// get posts

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{

  final String error;
  SocialGetPostsErrorState(this.error);
}

//// like posts
class SocialLikePostsSuccessState extends SocialStates{}

class SocialLikePostsErrorState extends SocialStates{

  final String error;
  SocialLikePostsErrorState(this.error);
}

//// chats users
class SocialGetAllUserSuccessState extends SocialStates{}

class SocialGetAllUserLoadingState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates{

  final String error;
  SocialGetAllUserErrorState(this.error);
}


//// chat message

class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}

class SocialGetMessagesSuccessState extends SocialStates{}

class SocialGetMessagesErrorState extends SocialStates{}

