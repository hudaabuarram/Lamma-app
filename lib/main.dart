
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'Layout/SocialLayout.dart';
import 'Screens/hhh.dart';
import 'Screens/loginScreen.dart';
import 'Shared/bloc_observer.dart';
import 'Shared/cacheHelper.dart';
import 'Shared/constants.dart';
import 'Shared/dioHelper.dart';
import 'Shared/themes.dart';
import 'package:lamma/cubit/SocialCubit.dart';
import 'package:lamma/cubit/states.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  //when the app is opened
  FirebaseMessaging.onMessage.listen((event) {});
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  // background notification
 // var firebaseMessagingBackgroundHandler;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();


  Widget widget;

  bool ?isDark = CacheHelper.getData('isDark');
  uId = CacheHelper.getData('uId');

  if (uId != null)
    widget = SocialLayout(0);
  else
    widget = LoginScreen();

  if(kDebugMode)
    await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(false);

  runApp(
      EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('ar')
        ],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp(
          isDark: isDark,
          startWidget: widget,
        ),
      ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  late final Widget startWidget;

  MyApp({this.isDark, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
    SocialCubit()
      ..changeMode(fromCache: isDark),
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  home:
                  SplashScreenView(
                    navigateRoute: startWidget,
                    duration: 5000,
                    imageSize: 150,
                    imageSrc: "assets/images/s.png",
                    text: "Lamma",
                    textType: TextType.ColorizeAnimationText,
                    textStyle: TextStyle(

                      fontSize: 40.0,
                    ),
                    colors: [
                      Colors.teal,
                      Colors.tealAccent,
                      Colors.yellow,
                      Colors.transparent,
                    ],
                    backgroundColor: Colors.white,
                  ),
                  theme: lightMode(),
                  darkTheme: darkMode(),
                  themeMode: appMode
              );
            }
        )
    );
  }
}



