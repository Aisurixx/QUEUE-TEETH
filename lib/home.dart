import 'package:flutter/material.dart';
import 'screens/profile.dart';
import 'home_screen.dart';
import 'book_appointment.dart';
import 'screens/history.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart'; // Import the required package

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Default index for bottom navbar

  final List<Widget> _widgetOptions = [
    HomeScreen(),          // Home Page
    AppointmentPage(),      // Appointments Page
    HistoryPage(),          // History Page
    ProfilePage(),          // Profile Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Displaying the selected page
      ),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        selectedColor: Colors.purple,   // Selected item color
        unSelectedColor: Colors.black54, // Unselected item color
        backgroundColor: Colors.white,  // Navbar background color
        currentIndex: _selectedIndex,   // Current index for navigation
        unselectedIconSize: 15,         // Unselected icon size
        selectedIconSize: 20,           // Selected icon size
        onTap: (index) {
          setState(() {
            _selectedIndex = index;     // Update the index when a tab is tapped
          });
        },
        enableLineIndicator: true,      // Enable line indicator
        lineIndicatorWidth: 3,          // Line indicator width
        indicatorType: IndicatorType.Top, // Line indicator at the top
        customBottomBarItems: [
          CustomBottomBarItems(
            label: 'Home',
            icon: Icons.home, // Home icon
          ),
          CustomBottomBarItems(
            label: 'Appointments',
            icon: Icons.event_available_outlined, // Appointments icon
          ),
          CustomBottomBarItems(
            label: 'History',
            icon: Icons.history_toggle_off_rounded, // History icon
          ),
          CustomBottomBarItems(
            label: 'Profile',
            icon: Icons.person_2_rounded, // Profile icon
          ),
        ],
      ),
    );
  }
}
