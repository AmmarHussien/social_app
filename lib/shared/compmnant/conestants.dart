
import 'package:social_app/shared/network/local/cashe_helper.dart';


import 'componanets.dart';

void signOut (context)
{
  CacheHelper.removeDate(
    key: 'token',
  ).then((value)
  {
    if(value)
    {
      //navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text)
{
  final pattern = RegExp('.(1,800)');
  pattern.allMatches(text).forEach((element) {
    print(element.group(0));
  });
}

String token = '';

String uId = '';