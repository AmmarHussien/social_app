
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_app/new_post_screen/new_post_screen.dart';
import 'package:social_app/shared/compmnant/componanets.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';


class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {
        if(state is SocialNewPostState)
          {
            navigateTo(context, NewPostScreen());
          }
      },
      builder: (context , state) {

        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                onPressed: (){},
                icon: Icon(
                  IconBroken.Notification,
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(
                  IconBroken.Search,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.ChangeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
               IconBroken.Home,
                  ),
                label:
                  'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Chat,
                  ),
                  label:
                      'Chat'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Paper_Upload,
                  ),
                  label:
                  'Post'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Location,
                  ),
                  label:
                      'Users'

              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Setting,
                  ),
                  label:
                      'Setting'
              ),
            ],
          ),
        );
      },
    );
  }
}
