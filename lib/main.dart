import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/compmnant/componanets.dart';
import 'package:social_app/shared/compmnant/conestants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cashe_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'layout/social_app/cubit/cubit.dart';
import 'layout/social_app/social_home_screen.dart';
import 'modules/social_app/social_login_screen/social_login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  await Firebase.initializeApp();
  print(message.data.toString());
  showToast(
    text: 'on background',
    state: ToastStates.SUCCESS,
  );
}
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event){
    print(event.data.toString());
    showToast(
      text: 'on message',
      state: ToastStates.SUCCESS,
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event){
    print(event.data.toString());
    showToast(
      text: 'on message opend app',
      state: ToastStates.SUCCESS,
    );
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getDate(key: 'isDark');
  uId = CacheHelper.getDate(key: 'uId');

  if(uId != null)
  {
    widget = SocialLayout();
  }else
  {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}
class MyApp extends StatelessWidget {

  bool? isDark;
  Widget startWidget;

  MyApp({Key? key,
    this.isDark,
    required this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()..changeAppMode(
          fromShared: isDark,
        ),
        ),
        BlocProvider(
            create: (context) =>
            SocialCubit()
              ..getUserData()
              ..getUsers())
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.light: ThemeMode.dark,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },

      ),
    );
  }
}
