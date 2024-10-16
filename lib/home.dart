import 'package:flutter/material.dart';
import 'package:simple_floating_bottom_nav_bar/floating_bottom_nav_bar.dart';
import 'package:simple_floating_bottom_nav_bar/floating_item.dart';
import 'screens/profile.dart'; // Add this line to import the profile page

import 'home_screen.dart';
import 'book_appointment.dart';
import 'screens/history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<FloatingBottomNavItem> bottomNavItems = const [
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.space_dashboard_outlined, color: Colors.black),
      activeIcon: Icon(Icons.space_dashboard_rounded, color: Colors.purple),
      label: "Home",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.event_available_outlined, color: Colors.black),
      activeIcon: Icon(Icons.event_available_rounded, color: Colors.purple),
      label: "Appointments",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.history_toggle_off_outlined, color: Colors.black),
      activeIcon: Icon(Icons.history_toggle_off_rounded, color: Colors.purple),
      label: "History",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.person_2_outlined, color: Colors.black),
      activeIcon: Icon(Icons.person_2_rounded, color: Colors.purple),
      label: "Profile",
    ),
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentPage(),
    HistoryPage(),
    ProfilePage(), // Add ProfilePage here
  ];

  PreferredSizeWidget? _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/pogisivenz.png'),
                radius: 20,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Hi, Harold Pogi',
              style: TextStyle(color: Color(0xFFE5D9F2)),
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index; // Update the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _pages[_bottomNavIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodySmall: TextStyle(
                      color: const Color.fromARGB(255, 6, 0, 0), // Text color for active items
                    ),
                  ),
            ),
            child: FloatingBottomNavBar(
              pages: _pages,
              items: bottomNavItems,
              initialPageIndex: _bottomNavIndex,
              backgroundColor: const Color.fromARGB(255, 235, 233, 233),
              bottomPadding: 5,
              elevation: 0,
              radius: 30,
              width: MediaQuery.of(context).size.width - 20,
              height: 65,
              
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
