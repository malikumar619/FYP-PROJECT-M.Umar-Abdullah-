import 'package:car_accident_tracking/constants.dart';
import 'package:car_accident_tracking/dashboard/dashboard_screen.dart';
import 'package:car_accident_tracking/google_maps_location/google_maps_screen.dart';
import 'package:car_accident_tracking/incident_reporting/incident_reporting_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../provider/bottom_navigation_bar_provider.dart';
import '../provider/current_user_name_provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<CurrentUserNameProvider>(context, listen: false).fetchUserName();
  }

  // List of screens for each bottom navigation item
  final List<Widget> _screens = [
    const DashboardScreen(),
    const GoogleMapsScreen(
      longitude: 73.1180131,
      latitude: 33.6276273,
    ),
    const IncidentReportingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: _screens[context.watch<BottomNavigationBarIndexProvider>().index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          backgroundColor: darkColor,
          selectedIndex: context.watch<BottomNavigationBarIndexProvider>().index,
          onTabChange: (i) => context
              .read<BottomNavigationBarIndexProvider>()
              .changeIndex(newIndex: i),
          haptic: false,
          activeColor: Colors.green,
          textStyle: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white
          ),
          color: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjust padding here
          tabMargin: const EdgeInsets.symmetric(vertical: 5), // Optional: reduce space around tabs
          //rippleColor: Colors.white60,
          gap: 10,
          tabs: const [
            GButton(
              icon: HugeIcons.strokeRoundedDashboardCircle,
              text: 'Dashboard',
            ),
            GButton(
              icon: HugeIcons.strokeRoundedLocation01,
              text: 'Location',
            ),
            GButton(
              icon: HugeIcons.strokeRoundedGoogleDoc,
              text: 'Accident',
            ),
          ],
        ),
      ),
    );
  }
}
