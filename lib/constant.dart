import 'package:shop_app/screens/shop_login_screen.dart';
import 'package:shop_app/service/fuctions/navigator_fun.dart';
import 'package:shop_app/service/local/cache_helper.dart';

void signOut(context) {
  CacheHelper().removeData(key: 'token').then((value) {
    if (value!) {
      navigatAndReplace(
        context,
        ShopLoginScreen(),
      );
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}

String? token = ''; //! i but it in constant to use it in any file