import 'dart:developer';
import 'dart:io';
import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/provider/accidents_car_image_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IncidentReportingScreen extends StatefulWidget {
  const IncidentReportingScreen({super.key});

  @override
  State<IncidentReportingScreen> createState() => _IncidentReportingScreenState();
}

class _IncidentReportingScreenState extends State<IncidentReportingScreen> {
  // List of options
  final List<String> severityOptions = ['Normal', 'Mild', 'Severe'];
  // List of options
  final List<String> carOptions = ['Motorcycle', 'Car', 'Wagon', 'Truck'];
  // Selected severity option
  String? selectedOption;
  // Selected car option
  String? selectedCarOption;
  double latitude= 33.6995;
  double longitude = 73.0363;

  final locationController = TextEditingController();
  final detailsController = TextEditingController();

  Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current location with new settings parameter
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy for better results
      distanceFilter: 10, // Minimum distance (meters) before a location update
    );

    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }



  void submitIncidentReport() async{
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
    if (locationController.text.trim().isNotEmpty
        && selectedOption != null && selectedOption!.isNotEmpty
        && selectedCarOption != null && selectedCarOption!.isNotEmpty) {
      try{
        String? userEmail = FirebaseAuth.instance.currentUser?.email;
        var snapshot = await FirebaseFirestore.instance
            .collection('registeredUsers')
            .where('userEmail', isEqualTo: userEmail)
            .limit(1)
            .get();
        FirebaseFirestore.instance.collection('incidentReports').add(
            {
              'location': locationController.text,
              'detail': detailsController.text,
              'severity': selectedOption,
              'carType': selectedCarOption,
              'reporterName': snapshot.docs.first['userName'],
              'latitude': latitude,
              'longitude': longitude
            }
        );
        if(mounted){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report submitted successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                              'Report Submission Successful!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: darkColor
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Steps that you can take further\nThank you for contributing towards the building of safe roads :)',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: darkColor
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => launchDialer("911"),
                                child: Container(
                                  height: 50,
                                  width: 130,
                                    decoration: BoxDecoration(
                                      color: darkColor,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  child: Center(
                                    child: Text(
                                        'Call Ambulance',
                                      style: GoogleFonts.aBeeZee(
                                        color: lightColor
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: ()=> launchDialer("15"),
                                child: Container(
                                  height: 50,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: darkColor,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Call Police',
                                      style: GoogleFonts.aBeeZee(
                                          color: lightColor
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
      } catch(e){
        log('Error storing data $e');
        if(mounted){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error storing data $e'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }else{
      if(mounted){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: lightColor,
            elevation: 3,
            content: Text(
                'Please enter all input fields!',
              style: GoogleFonts.aBeeZee(
                color: darkColor
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void launchDialer(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<AccidentsCarImageProvider>(context);
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor,
        title: Text(
            'Report an accident',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: lightColor
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width*.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Container(
                height: height*.25,
                width: width*.95,
                decoration: BoxDecoration(
                  color: midDarkColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Lottie.asset('images/accident.json'),
              ),*/
              Padding(
                padding: EdgeInsets.only(top: height*.01),
                child: TextField(
                  controller: locationController,
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    hintText: 'Enter the nearby location',
                    hintStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: lightColor, // Hint text color
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
              Padding(
                padding: EdgeInsets.only(top: height*.02),
                child: DropdownButton<String>(
                  enableFeedback: true,
                  value: selectedOption,
                  hint: Text(
                      'Select the severity of accident',
                    style: GoogleFonts.poppins(
                        color: lightColor,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  items: severityOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                          option,
                        style: GoogleFonts.poppins(
                            color: lightColor,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                  // Make the underline white
                  underline: Container(
                    height: 1, // Thickness of the line
                    color: lightColor,
                  ),
                  // Optional style customizations
                  dropdownColor: darkColor,
                  icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: lightColor
                  ),
                  isExpanded: true, // Makes the dropdown fill the available width
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height*.02),
                child: DropdownButton<String>(
                  enableFeedback: true,
                  value: selectedCarOption,
                  hint: Text(
                    'Select, accident car type',
                    style: GoogleFonts.poppins(
                        color: lightColor,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  items: carOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                            color: lightColor,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCarOption = newValue;
                    });
                  },
                  // Make the underline white
                  underline: Container(
                    height: 1, // Thickness of the line
                    color: lightColor,
                  ),
                  // Optional style customizations
                  dropdownColor: darkColor,
                  icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: lightColor
                  ),
                  isExpanded: true, // Makes the dropdown fill the available width
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height*.02),
                child: Text(
                    'Enter brief detail about accident',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    color: lightColor,
                    fontSize: 16
                  ),
                ),
              ),
              Container(
                height: height * 0.25,
                width: width * 0.95,
                decoration: BoxDecoration(
                  color: midDarkColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: detailsController,
                  maxLines: null, // Allows the user to type multiple lines
                  expands: true, // Expands the TextField to fill the container
                  decoration: InputDecoration(
                    hintText: "Enter the details here...",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none, // Removes the default underline
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adds padding inside the text field
                  ),
                  cursorColor: lightColor,
                  style: GoogleFonts.poppins(
                      color: lightColor
                  ), // Text style inside the input box
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height*.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attach photos/videos',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          color: lightColor,
                          fontSize: 16
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: darkColor,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: Text(
                                          'Take Photo',
                                        style: GoogleFonts.aBeeZee(
                                            color: Colors.white
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context); // Close the bottom sheet
                                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                                        if (image != null) {
                                          imageProvider.addImage(File(image.path));
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.videocam),
                                      title: Text(
                                          'Record Video',
                                        style: GoogleFonts.aBeeZee(
                                          color: Colors.white
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context); // Close the bottom sheet
                                        final XFile? video = await ImagePicker().pickVideo(source: ImageSource.camera);
                                        if (video != null) {
                                          imageProvider.addVideo(File(video.path));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedCamera01,
                        color: lightColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.15,
                width: width * 0.95,
                decoration: BoxDecoration(
                  color: midDarkColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: width * 0.95,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Consumer<AccidentsCarImageProvider>(
                        builder: (context, imageProvider, child) {
                          final mediaFiles = [
                            ...imageProvider.images.map((file) => {'file': file, 'type': 'image'}),
                            ...imageProvider.videos.map((file) => {'file': file, 'type': 'video'}),
                          ];

                          return Row(
                            children: mediaFiles.map((media) {
                              final file = media['file'] as File;
                              final type = media['type'] as String;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: type == 'image'
                                      ? Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                      : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.black54,
                                        child: const Icon(Icons.videocam, color: Colors.white, size: 40),
                                      ),
                                      const Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Icon(Icons.play_circle_fill, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height*.02),
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context); // Store a local reference
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Prevent dismissing while loading
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        try {
                          Position? position = await getUserLocation();

                          if (position != null) {
                            latitude = position.latitude;
                            longitude = position.longitude;
                            log("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
                          }
                        } catch (e) {
                          log("Error: $e");
                        }
                        if (navigator.mounted) {
                          navigator.pop(); // Use the local navigator reference safely

                          ScaffoldMessenger.of(navigator.context).showSnackBar(
                            const SnackBar(
                              content: Text('Location fetched successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(width*.9, height*.055),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: lightColor
                      ),
                      child: Text(
                        'Get Current Location',
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                            fontSize: 18
                        ),
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height*.02),
                child: Center(
                  child: ElevatedButton(
                      onPressed: (){
                        submitIncidentReport();
                      },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width*.9, height*.055),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: lightColor
                    ),
                      child: Text(
                          'SUBMIT',
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                          fontSize: 18
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}