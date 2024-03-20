import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc_observer.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/cubits/app_cubit/app_cubit.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/screens/shop_login_screen.dart';
import 'package:shop_app/service/local/cache_helper.dart';
import 'package:shop_app/screens/onbording_screen.dart';
import 'package:shop_app/service/remote/dio_helper.dart';
import 'package:shop_app/widgets/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper
      .init(); // ! using async, await becuase the instance will be created only with the app running or change value

  bool? onBoarding = CacheHelper.getData(key: 'isOnBoarding'); // true
  bool? isDark = CacheHelper.getThemeValue(key: 'isDark');
  token = CacheHelper.getData(key: 'token');
  print(token);
  Widget isStartWidget; //!is Start Widget

  if (onBoarding != null) {
    if (token != null) {
      isStartWidget = const ShopLayout();
    } else {
      isStartWidget = ShopLoginScreen();
    }
  } else {
    isStartWidget = const OnboardingScreen();
  }
  Bloc.observer = MyBlocObserver();

  runApp(MyApp(
    isDark: isDark,
    isStartWidget: isStartWidget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isDark, required this.isStartWidget});
  final bool? isDark;
  final Widget isStartWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeAppTheme(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorite()
            ..getProfile(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ligthTheme(),
            darkTheme: darkTheme(),
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: isStartWidget,
          );
        },
      ),
    );
  }
}
