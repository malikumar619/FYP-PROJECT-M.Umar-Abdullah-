import 'package:car_accident_tracking/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  const GoogleMapsScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Makes the status bar transparent
        statusBarIconBrightness: Brightness.dark, // Change to Brightness.light for white icons
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    LatLng myCurrentLocation = LatLng(widget.latitude, widget.longitude);
    return Scaffold(
      backgroundColor: darkColor,
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
            zoom: 15
          ),
        mapToolbarEnabled: true,
      ),
    );
  }
}
