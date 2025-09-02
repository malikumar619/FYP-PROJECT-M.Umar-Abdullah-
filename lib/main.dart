import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/provider/accidents_car_image_provider.dart';
import 'package:car_accident_tracking/provider/bottom_navigation_bar_provider.dart';
import 'package:car_accident_tracking/provider/current_user_email_provider.dart';
import 'package:car_accident_tracking/provider/current_user_name_provider.dart';
import 'package:car_accident_tracking/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  // Set the navigation bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: darkColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BottomNavigationBarIndexProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => CurrentUserNameProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => CurrentUserEmailProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => AccidentsCarImageProvider()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
