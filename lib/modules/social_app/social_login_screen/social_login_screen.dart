import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_home_screen.dart';
import 'package:social_app/modules/social_app/social_register_screen/social_register_screen.dart';
import 'package:social_app/shared/compmnant/componanets.dart';
import 'package:social_app/shared/network/local/cashe_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {

  var fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context)
  {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();

     return BlocProvider(
       create: (BuildContext context) => SocialLoginCubit(),
       child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
         listener: (context , state) {
           if(state is SocialLoginErrorState)
             {
               showToast(
                   text: state.error,
                   state: ToastStates.ERROR,
               );
             }
           if(state is SocialLoginSuccessState)
             {
               CacheHelper.saveDate(
                   key: 'uId',
                   value: state.uId,
               ).then((value)
               {
                 navigateAndFinish(context, SocialLayout());
               });
             }
         },
         builder: (context , state) {
           return Scaffold(
             appBar: AppBar(),
             body: Center(
               child: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Form(
                     key: fromKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'LOGIN',
                           style: Theme.of(context).textTheme.headline4!.copyWith(
                               color: Colors.black
                           ),
                         ),
                         Text(
                           'Login now to communicate with friends',
                           style: Theme.of(context).textTheme.bodyText1!.copyWith(
                             color: Colors.grey,
                           ),
                         ),
                         SizedBox(
                           height:15.0 ,
                         ),
                         defaultFormField(
                           controller: emailController,
                           type: TextInputType.emailAddress,
                           label: 'Email Address',
                           prefix: Icons.email_outlined,
                           onSubmit: (value)
                           {

                           },
                         ),
                         SizedBox(
                           height:30.0 ,
                         ),
                         defaultFormField(
                             controller: passwordController,
                             type: TextInputType.visiblePassword,
                             label: 'Password',
                             prefix: Icons.lock_outline,
                             suffix: SocialLoginCubit.get(context).suffix,
                             isPassword: SocialLoginCubit.get(context).isPassword,
                             onSubmit: (value)
                             {
                               // SocialLoginCubit.get(context).userLogin(
                               //   email: emailController.text,
                               //   password: passwordController.text,
                               // );
                             },
                             suffixPressed: ()
                             {
                               SocialLoginCubit.get(context).changePasswordVisibility();
                             },
                             validate: (String value)
                             {
                               if(value.isEmpty)
                               {
                                 return 'password is too short';
                               }
                             }
                         ),
                         SizedBox(
                           height:30.0 ,
                         ),
                         ConditionalBuilder(
                           condition:  state is! SocialLoginLoadingState,
                           builder:(context) => defaultButton(
                             function: ()
                             {
                               SocialLoginCubit.get(context).userLogin(
                                 email: emailController.text,
                                 password: passwordController.text,
                               );

                             },
                             text: 'login' ,
                             isUpperCase: true,
                           ),
                           fallback:(context) =>
                               Center(child: CircularProgressIndicator()),
                         ),
                         SizedBox(
                           height:30.0 ,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                                 'Don\'t have an account?'
                             ),
                             defaultTextButton(
                               function:()
                               {
                                 navigateTo(
                                   context,
                                   SocialRegisterScreen(),
                                 );
                               },
                               text: 'register' ,
                             )
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
           );
         },
       ),
     );
  }
}
