import 'package:car_accident_tracking/authentication/signup_screen.dart';
import 'package:car_accident_tracking/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:car_accident_tracking/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async{
    showDialog(
      context: context,
      builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      if(mounted){
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context)=> const BottomNavigationBarScreen()
            )
        );
      }
    } on FirebaseAuthException catch (e) {
      //print(e.code);
      if(mounted){
        Navigator.pop(context);
      }
      if(e.code == 'invalid-credential'){
        if(mounted) wrongCredentials(context);

      }
      else if(e.code == 'wrong-password'){
        if(mounted) wrongCredentials(context);

      }
    }
  }

  void wrongCredentials(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid Credentials!'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Headlines
            Padding(
              padding: EdgeInsets.only(top: height*.06,left: width*.04),
              child: Text(
                'Good to see you again,',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: lightColor,
                    fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width*.04),
              child: Text(
                'Enter your credentials to sign in!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    color: lightColor,
                    fontSize: 18
                ),
              ),
            ),
            SizedBox(
              height: height*.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height*.02),
              child: Center(
                child: Container(
                  height: height*.22,
                  width: width*.9,
                  decoration: BoxDecoration(
                    color: midDarkColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*.04,vertical: height*.02),
                    child: Column(
                      children: [
                        // Email input field
                        TextField(
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          controller: emailController,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey, // Hint text color
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: lightColor, // Matches the background color
                              ),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: lightColor, // Matches the background color
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, // Minimal padding for single-line appearance
                              horizontal: 4.0,
                            ),
                          ),
                          cursorColor: lightColor, // Cursor color
                          style: GoogleFonts.poppins(
                              color: lightColor,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        // Password input field
                        Padding(
                          padding: EdgeInsets.only(top: height*.02),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey, // Hint text color
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: lightColor, // Matches the background color
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: lightColor, // Matches the background color
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, // Minimal padding for single-line appearance
                                horizontal: 4.0,
                              ),
                            ),
                            cursorColor: lightColor, // Cursor color
                            style: GoogleFonts.poppins(
                                color: lightColor,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Reset Password
            Padding(
              padding: EdgeInsets.only(left: width*.09,bottom: height*.02),
              child: Text(
                  'Forgot password ?',
                style: GoogleFonts.poppins(),
              ),
            ),
            // Sign Up Button
            Center(
              child: ElevatedButton(
                onPressed: signInUser,
                style: ElevatedButton.styleFrom(
                    backgroundColor: lightColor,
                    minimumSize: Size(width*.8, height*.05),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
                child: Text(
                  'Sign in',
                  style: GoogleFonts.poppins(
                      color: darkColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height*.25,
            ),
            // Sign up option
            Padding(
              padding: EdgeInsets.symmetric(vertical: height*.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                        CupertinoPageRoute(
                            builder: (context) => const SignupScreen(),
                        )
                      );
                    },
                    child: Text(
                      'Sign up here',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}