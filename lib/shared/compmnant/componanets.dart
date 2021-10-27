
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import 'package:social_app/shared/styles/icon_broken.dart';


Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue ,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function ,
  required String text ,
}) =>
    Container(
  width: width,
  height: 40.0,
  child: MaterialButton(
    onPressed: () {
      function();
    },
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(
      radius,
    ),
  ),
);


Widget defaultTextButton({
required Function? function,
  required String text,
})=> TextButton(
  onPressed: ()
  {
    function!();
  },
    child: Text(
        text.toUpperCase(),
    ),
);


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function? suffixPressed,
  Function? onTap,
  bool? isClickable,
  Function? onChange,
  Function? onSubmit,
  Function? validate,
})=>
    TextFormField(
      controller: controller,
      keyboardType: type ,
      obscureText: isPassword,
      enabled: isClickable,
      /*onTap: ()
      {
        onTap!();
      },*/
     /* onChanged:(s)
      {
        onChange!(s);
      },*/
      onFieldSubmitted: (s)
      {
        onSubmit!(s);
      },
      /*validator: (s)
      {
        validate!();
      },*/
      decoration: InputDecoration(
        labelText: label ,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
          onPressed: ()
          {
            suffixPressed!();
          },
          icon: Icon(
            suffix,
          ),
        ) : null,
        border: OutlineInputBorder(),
      ),
    );


Widget defaultAppBar (
{
   required BuildContext  context,
   String ? title,
   List<Widget> ? actions,
}) => AppBar(
  leading: IconButton(
    onPressed: ()
    {
      Navigator.pop(context);
    },
    icon: Icon(
      IconBroken.Arrow___Left_2,
    ),
  ),
  titleSpacing: 5.0,
  title: Text(
    title!,
  ),
  actions: actions,
);

Widget buildTaskItem(Map model , context ) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

              '${model['time']}'

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color:  Colors.grey,

                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: ()

            {

                AppCubit.get(context).updateData(

                    status: 'done',

                    id: model['id']);

            },

            icon: Icon(

            Icons.check_box,

              color: Colors.green,

            ),

        ),

        IconButton(

          onPressed: (){

            AppCubit.get(context).updateData(

                status: 'archive',

                id: model['id']);

          },

          icon: Icon(

            Icons.archive,

            color: Colors.black45,

          ),

        )

      ],

    ),

  ),
  onDismissed: (direction)
  {
      AppCubit.get(context).deleteData(id: model['id']);
  },
);


Widget tasksBuilder({
  required List<Map> tasks,
}) =>  ConditionalBuilder(
  builder: (context) => ListView.separated(
    itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index) =>myDivider(),
    itemCount: tasks.length,
  ),
  condition: tasks.length>0,
  fallback: (context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),

);


Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
      start: 20.0
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color:  Colors.grey[300],
  ),
);



void navigateTo( context , widget ) => Navigator.push(
  context,
  MaterialPageRoute(
    builder:(context)=> widget,
    ),
);

void navigateAndFinish(context , widget ) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => widget,
        ),
        (Route<dynamic>route) => false,
    );


void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

