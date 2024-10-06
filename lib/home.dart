import 'package:flutter/material.dart';
import 'package:simple_floating_bottom_nav_bar/floating_bottom_nav_bar.dart';
import 'package:simple_floating_bottom_nav_bar/floating_item.dart';

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
      inactiveIcon: Icon(Icons.home_outlined, color: Colors.black),
      activeIcon: Icon(Icons.home, color: Colors.black),
      label: "Home",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.add_circle_outline, color: Colors.black),
      activeIcon: Icon(Icons.add_circle, color: Colors.black),
      label: "Add",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.history, color: Colors.black),
      activeIcon: Icon(Icons.history, color: Colors.black),
      label: "History",
    ),
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentPage(),
    HistoryPage(),
    // Removed ProfilePage
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
        title: GestureDetector(
          onTap: () {
            // You can redirect to another page or handle the tap
            // For example, navigate to the HomeScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Row(
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index; // Update the index when an item is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
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
      bottomNavigationBar: FloatingBottomNavBar(
        pages: _pages,
        items: bottomNavItems,
        initialPageIndex: _bottomNavIndex,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottomPadding: 10,
        elevation: 0,
        radius: 20,
        width: 300,
        height: 65,
        // Ensure that _onItemTapped updates the index
   // Add this line to ensure proper tap handling
      ),
      resizeToAvoidBottomInset: true, // Add this property
    );
  }
}
