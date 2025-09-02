import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/google_maps_location/google_maps_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncidentsDetailScreen extends StatefulWidget {
  const IncidentsDetailScreen({super.key, required this.details, required this.reporterName, required this.carType, required this.accidentType, required this.location, required this.latitude, required this.longitude});

  final String details;
  final String reporterName;
  final String carType;
  final String accidentType;
  final String location;
  final double latitude;
  final double longitude;
  @override
  State<IncidentsDetailScreen> createState() => _IncidentsDetailScreenState();
}

class _IncidentsDetailScreenState extends State<IncidentsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor,
        title: Text(
            'Incident Details',
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width*.04),
        child: Column(
          children: [
            Container(
              height: height*.5,
              decoration: BoxDecoration(
                color: midDarkColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height*.02,horizontal: width*.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Reported by: ',
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: lightColor
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.reporterName,
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.white.withAlpha(150)
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Location: ',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: lightColor
                          ),
                        ),
                        Text(
                          widget.location,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.white.withAlpha(150)
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Accident Type: ',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: lightColor
                          ),
                        ),
                        Text(
                          widget.accidentType,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.white.withAlpha(150)
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Description: ',
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: lightColor
                      ),
                    ),
                    Text(
                      widget.details,
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.white.withAlpha(150)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height*.02),
              child: Container(
                height: height*.2,
                decoration: BoxDecoration(
                    color: midDarkColor,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height*.02),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context)=>GoogleMapsScreen(
                              latitude: widget.latitude,
                              longitude: widget.longitude
                          )
                      )
                  );
                },
                child: Container(
                  height: height*.07,
                  decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                        'View Location',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkColor
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
