import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'book_appointment.dart';
import 'screens/history.dart';
import 'screens/profile.dart'; // Add this line to import the profile page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;
  bool _isNavBarVisible = true; // Add this line

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0); // Set initial index
  }

  void _toggleNavBarVisibility(bool isVisible) {
    setState(() {
      _isNavBarVisible = isVisible;
    });
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      AppointmentPage(),
      HistoryPage(),
      ProfilePage(), // Add ProfilePage here
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.space_dashboard_outlined),
        title: "Home",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.event_available_outlined),
        title: "Appointments",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history_toggle_off_outlined),
        title: "History",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2_outlined),
        title: "Profile",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        backgroundColor: Colors.white,
        navBarHeight: _isNavBarVisible ? 60 : 0, // Adjust height based on visibility
        padding: const EdgeInsets.only(top: 8),
        navBarStyle: NavBarStyle.style9, // Choose your preferred style
      ),
    );
  }
}
