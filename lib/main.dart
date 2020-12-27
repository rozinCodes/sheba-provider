import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/pages/splash_screen.dart';

Future<void> main() async {
  // firebase initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(40, 53, 147, .1),
  100: Color.fromRGBO(40, 53, 147, .2),
  200: Color.fromRGBO(40, 53, 147, .3),
  300: Color.fromRGBO(40, 53, 147, .4),
  400: Color.fromRGBO(40, 53, 147, .5),
  500: Color.fromRGBO(40, 53, 147, .6),
  600: Color.fromRGBO(40, 53, 147, .7),
  700: Color.fromRGBO(40, 53, 147, .8),
  800: Color.fromRGBO(40, 53, 147, .9),
  900: Color.fromRGBO(40, 53, 147, 1),
};

class MyApp extends StatelessWidget {
  /*
   *  colorCustom is primary color
   */
  final MaterialColor colorCustom = MaterialColor(0xFF283593, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: colorCustom,
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: MyColor.colorBlue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
