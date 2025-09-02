import 'package:car_accident_tracking/authentication/signin_screen.dart';
import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/provider/current_user_email_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/current_user_name_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<CurrentUserEmailProvider>(context, listen: false).fetchUserEmail();
  }
  void signUserOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
    // Store context reference before async call
    final navigator = Navigator.of(context);

    FirebaseAuth.instance.signOut().then((_) {
      navigator.pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const SignInScreen()),
            (route) => false, // This removes all previous routes from the stack
      );
    });
  }

  void _showCallOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.local_police),
                  title: Text(
                      'Call Police',
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _makePhoneCall('tel:15');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_hospital),
                  title: Text(
                      'Call Ambulance',
                    style: GoogleFonts.aBeeZee(
                        color: Colors.white
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _makePhoneCall('tel:1122');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _makePhoneCall(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor,
        title: Text(
          'P R O F I L E',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding for alignment
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Navigate back
            },
            child: Container(
              decoration: BoxDecoration(
                color: midDarkColor
                    .withAlpha(100), // Background color of the container
                shape: BoxShape.circle, // Rounded shape
              ),
              child: const Icon(
                Icons.arrow_back, // Back icon
                color: lightColor, // Icon color
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Container(
                height: height * .45,
                width: width * .95,
                decoration: BoxDecoration(
                    color: midDarkColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * .015),
                        child: CircleAvatar(
                          radius: 50,
                          child: Lottie.asset('images/person.json'),
                        ),
                      ),
                      Consumer<CurrentUserNameProvider>(
                        builder: (context, userProvider, child) {
                          return Text(
                            userProvider.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                      Consumer<CurrentUserEmailProvider>(
                        builder: (context, userProvider, child) {
                          return Text(
                            userProvider.email,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _showCallOptions(context),
                            child: Container(
                              height: height * .2,
                              width: width * .2,
                              decoration: const BoxDecoration(
                                color: lightColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.call,
                                  color: darkColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * .2,
                            width: width * .2,
                            decoration: const BoxDecoration(
                              color: lightColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.message,
                                color: darkColor,
                                size: 40,
                              ),
                            ),
                          ),
                          Container(
                            height: height * .2,
                            width: width * .2,
                            decoration: const BoxDecoration(
                              color: lightColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.location_on,
                                color: darkColor,
                                size: 40,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * .02, bottom: height * .04),
              child: Center(
                child: Container(
                  height: height * .08,
                  width: width * .95,
                  decoration: BoxDecoration(
                      color: midDarkColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * .06, vertical: height * .02),
                        child: GestureDetector(
                          onTap: () => signUserOut(context),
                          child: Row(
                            children: [
                              const Icon(Icons.logout),
                              Padding(
                                padding: EdgeInsets.only(left: width * .05),
                                child: Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: lightColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}