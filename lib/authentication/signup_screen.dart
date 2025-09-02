import 'package:car_accident_tracking/authentication/signin_screen.dart';
import 'package:car_accident_tracking/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async{
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
    try{
      if(passwordController.text==confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await FirebaseFirestore.instance.collection('registeredUsers').add(
          {
            'userEmail': emailController.text,
            'userName': nameController.text,
          }
        );
        if(mounted){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on FirebaseAuthException catch(e){
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
                  'Welcome Onboard,',
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
                'Enter your credentials to sign up!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    color: lightColor,
                    fontSize: 18
                ),
              ),
            ),
            SizedBox(height: height*.05,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height*.03),
              child: Center(
                child: Container(
                  height: height*.37,
                  width: width*.9,
                  decoration: BoxDecoration(
                    color: midDarkColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*.04,vertical: height*.02),
                    child: Column(
                      children: [
                        // Name input field
                        TextField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
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
                        // Email input field
                        Padding(
                          padding: EdgeInsets.only(top: height*.02),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.name,
                            autocorrect: false,
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
                        ),
                        // Password input field
                        Padding(
                          padding: EdgeInsets.only(top: height*.02),
                          child: TextField(
                            controller: passwordController,
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
                        // Confirm Password input field
                        Padding(
                          padding: EdgeInsets.only(top: height*.02),
                          child: TextField(
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
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
            // Sign Up Button
            Center(
              child: ElevatedButton(
                  onPressed: (){
                    signUserUp();
                  },
                style: ElevatedButton.styleFrom(

                  backgroundColor: lightColor,
                  maximumSize: Size(width*.8, height*.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Create Account',
                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width*.02),
                        child: const Icon(
                            Icons.arrow_forward,
                          color: darkColor,
                        ),
                      )
                    ],
                  ),
              ),
            ),
            SizedBox(
              height: height*.14,
            ),
            // Sign in option
            Padding(
              padding: EdgeInsets.symmetric(vertical: height*.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Already have an account? ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context)=> const SignInScreen())
                      );
                    },
                    child: Text(
                        'Sign in here',
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
