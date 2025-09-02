import 'package:car_accident_tracking/incident_reporting/incidents_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class AllIncidentsReport extends StatefulWidget {
  const AllIncidentsReport({super.key});

  @override
  State<AllIncidentsReport> createState() => _AllIncidentsReportState();
}

class _AllIncidentsReportState extends State<AllIncidentsReport> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        title: Text(
            'Incident Reports',
          style: GoogleFonts.aBeeZee(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: darkColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('incidentReports').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No incident reports found."));
          }
          var incidents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              var incident = incidents[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * .02, horizontal: width * .04),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context)=> IncidentsDetailScreen(
                              accidentType: incident['severity'],
                              carType: incident['carType'],
                              details: incident['detail'],
                              reporterName: incident['reporterName'],
                              location: incident['location'],
                              latitude: incident['latitude'],
                              longitude: incident['longitude'],
                            )
                        )
                    );
                  },
                  child: Container(
                    height: height * .25,
                    width: width * .8,
                    decoration: BoxDecoration(
                        color: midDarkColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * .03),
                          child: SizedBox(
                            width: width * .25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: height * .04),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: lightColor,
                                    child: Lottie.asset('images/person.json'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: height * .01),
                                  child: Text(
                                    incident['reporterName'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: lightColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .6,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width * .02,
                                right: width * .02,
                                top: height * .02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  incident['location'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      color: lightColor),
                                ),
                                Text(
                                  incident['detail'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: lightColor.withAlpha(100)),
                                  maxLines: 5,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
