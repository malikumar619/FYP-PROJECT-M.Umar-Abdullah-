import 'package:car_accident_tracking/authentication/signin_screen.dart';
import 'package:car_accident_tracking/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:car_accident_tracking/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
      )
    );
    // Navigate to the next screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if(mounted){
        User? user = FirebaseAuth.instance.currentUser;
      if(user!= null){
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context)=> const BottomNavigationBarScreen()
            )
        );
      }
      else{
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context)=> const SignInScreen()
            )
        );
      }
    }});
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: darkColor,
      body: Stack(
        children: [
          // Centered Text
          Center(
            child: Text(
              'SafeRoads',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: lightColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Loading Indicator at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.05), // Adjust bottom spacing
              child: SizedBox(
                width: width * 0.1,
                height: height * 0.05,
                child: const LoadingIndicator(
                  colors: [
                    midDarkColor,
                    lightColor,
                  ],
                  indicatorType: Indicator.orbit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
