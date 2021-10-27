import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_home_screen.dart';
import 'package:social_app/shared/compmnant/componanets.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialRegisterScreen extends StatelessWidget {


  var fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context)
  {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var isEmailVerified = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),

      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
        listener: (context , state)
        {
          if(state is SocialCreateUserSuccessState)
          {
            navigateAndFinish(
                context,
                SocialLayout(),
            );
          }
        },
        builder:  (context , state){
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
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black
                          ),
                        ),
                        Text(
                          'REGISTER now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height:15.0 ,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'User Name',
                          prefix: Icons.person,
                          onSubmit: (value)
                          {

                          },
                        ),
                        SizedBox(
                          height:30.0 ,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email address',
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
                            suffix: SocialRegisterCubit.get(context).suffix,
                            isPassword: SocialRegisterCubit.get(context).isPassword,
                            onSubmit: (value)
                            {
                              SocialRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,

                              );
                            },
                            suffixPressed: ()
                            {
                              SocialRegisterCubit.get(context).changePasswordVisibility();
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
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: 'phone',
                            prefix: Icons.phone,

                        ),

                        SizedBox(
                          height:30.0 ,
                        ),

                        ConditionalBuilder(
                          condition:  state is! SocialRegisterLoadingState,
                          builder:(context) => defaultButton(
                            function: ()
                            {
                               SocialRegisterCubit.get(context).userRegister(
                                 email: emailController.text,
                                 password: passwordController.text,
                                 name: nameController.text,
                                 phone: phoneController.text,

                               );

                            },
                            text: 'register' ,
                            isUpperCase: true,
                          ),
                          fallback:(context) =>
                              Center(child: CircularProgressIndicator()),
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
