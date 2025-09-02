import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/incident_reporting/all_incidents_report.dart';
import 'package:car_accident_tracking/incident_reporting/incidents_detail_screen.dart';
import 'package:car_accident_tracking/profile_management/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/current_user_name_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light, // Change to Brightness.light for white icons
      ),
    );
    getUserName();
    super.initState();
  }
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String loggedInUserName = '';
  void getUserName() async{
    var snapshot = await FirebaseFirestore.instance
        .collection('registeredUsers')
        .where('userEmail', isEqualTo: userEmail)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        loggedInUserName = snapshot.docs.first['userName'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: darkColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                    left: width * .04, top: height * .02, right: width * .04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const ProfileScreen()));
                      },
                      child: CircleAvatar(
                        backgroundColor: midDarkColor.withAlpha(100),
                        radius: 25,
                        child: Lottie.asset('images/person.json'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              // Incidents occurring graph
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .03,
                          left: width * .04,
                          right: width * .02),
                      child: Container(
                        height: height * .4,
                        width: width * .9,
                        decoration: BoxDecoration(
                            color: midDarkColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Accidents',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: lightColor,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    'November',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        color: lightColor,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '43.0 %',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        color: lightColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              PieChart(PieChartData(sections: [
                                PieChartSectionData(
                                    value: 35,
                                    color: Colors.redAccent,
                                    titleStyle: GoogleFonts.poppins(
                                        color: lightColor,
                                        fontWeight: FontWeight.bold)),
                                PieChartSectionData(
                                    value: 43,
                                    color: Colors.blue,
                                    titleStyle: GoogleFonts.poppins(
                                        color: lightColor,
                                        fontWeight: FontWeight.bold)),
                                PieChartSectionData(
                                    value: 22,
                                    color: Colors.brown,
                                    titleStyle: GoogleFonts.poppins(
                                        color: lightColor,
                                        fontWeight: FontWeight.bold))
                              ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Accidents ratio graph
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .03,
                          left: width * .02,
                          right: width * .04),
                      child: Container(
                        height: height * .4,
                        width: width * .9,
                        decoration: BoxDecoration(
                            color: midDarkColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: LineChart(LineChartData(
                                minX: 0,
                                maxX: 3,
                                minY: 0,
                                maxY: 99,
                                borderData: FlBorderData(
                                  show: true, // Ensures the border is shown
                                  border: const Border(
                                    left: BorderSide(
                                      color:
                                          lightColor, // Set your desired color for the left border
                                      width:
                                          1, // Set the thickness of the border
                                    ),
                                    bottom: BorderSide(
                                      color:
                                          lightColor, // Set your desired color for the bottom border
                                      width:
                                          1, // Set the thickness of the border
                                    ),
                                    right: BorderSide
                                        .none, // Hides the right border
                                    top:
                                        BorderSide.none, // Hides the top border
                                  ),
                                ),
                                titlesData: const FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true, reservedSize: 25)),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                      spots: [
                                        const FlSpot(0, 43),
                                        const FlSpot(0.5, 22),
                                        const FlSpot(1, 35),
                                        const FlSpot(1.5, 53),
                                        const FlSpot(2, 35),
                                        const FlSpot(2.5, 67),
                                        const FlSpot(3, 34),
                                      ],
                                      isCurved: true,
                                      color: Colors.green,
                                      belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.green.withAlpha(100)
                                      )
                                  )
                                ]
                            )
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                    left: width * .05, top: height * .03, bottom: height * .01, right: width * .05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent reports',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: lightColor),

                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context)=> const AllIncidentsReport()
                            )
                        );
                      },
                      child: Text(
                        'View all',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('incidentReports')
                    .limit(4) // Limit to 4 items
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Loading indicator
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Column(
                      children: [
                        SizedBox(height: 100,),
                        Center(
                            child: Text(
                                "No incident reports found."
                            )
                        ),

                      ],
                    );
                  }

                  var incidents = snapshot.data!.docs;

                  return SizedBox(
                    height: height*.30,
                    child: ListView.builder(
                      itemCount: incidents.length,
                      itemBuilder: (context, index) {
                        var incident = incidents[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height * .02, horizontal: width * .04),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => IncidentsDetailScreen(
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
                    ),
                  );
                },
              ),
            ),
            /*SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width*.05,vertical: height*.015),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context)=> const AllIncidentsReport()
                        )
                    );
                  },
                  child: Container(
                    height: height*.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightColor
                    ),
                    child: Center(
                      child: Text(
                          'View all incidents',
                        style: GoogleFonts.aBeeZee(
                          color: darkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )*/
            /*SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * .02, horizontal: width * .04),
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
                                  'M Salman Abid',
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
                                'Wazirabad',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: lightColor),
                              ),
                              Text(
                                'A speeding motorcycle was found accidented near ojala pul point of the damn e koh where to cars were'
                                ' speeding and going very fast. Critical situation, no helping hands have arrived yet',
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
            ),*/
          ],
        ),
      ),
    );
  }
}
