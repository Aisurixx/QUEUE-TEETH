import 'package:flutter/material.dart';
import 'screens/profile.dart'; // Ensure ProfilePage is defined in profile.dart
import 'home_screen.dart'; // Ensure HomeScreen is defined in home_screen.dart
import 'book_appointment.dart'; // Ensure AppointmentPage is defined in book_appointment.dart
import 'screens/history.dart'; // Ensure HistoryPage is defined in history.dart

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentPage(),
    HistoryPage(),
  ];

  final List<IconData> _iconList = [
    Icons.home_filled,
    Icons.add_rounded,
    Icons.history_edu,
  ];

  final List<String> _titleList = [
    'Home',
    'Appointments',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _bottomNavIndex == 0 // Show AppBar only when on Home
          ? PreferredSize(
              preferredSize: Size.fromHeight(60), // Adjust the height of the AppBar
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/appbar.png'), // Path to your background image
                    fit: BoxFit.cover, // Adjust this as needed (e.g., cover, contain, etc.)
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent, // Make AppBar transparent
                  title: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/pogisivenz.png'), // Profile image path
                                radius: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Hi, Harold Pogi',
                              style: TextStyle(color: Color(0xFFE5D9F2)), // Set the text color here
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null, // No AppBar for other pages
      body: Stack(
        children: [
          // Full screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Background image path
              fit: BoxFit.cover,
            ),
          ),
          // Main content displaying the current page
          Positioned.fill(
            child: _pages[_bottomNavIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
            bottom: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
            bottom: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _iconList[0],
                  color: _bottomNavIndex == 0
                      ? const Color.fromARGB(255, 116, 23, 133)
                      : Colors.black,
                ),
                label: _titleList[0],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _iconList[1],
                  color: _bottomNavIndex == 1
                      ? const Color.fromARGB(255, 116, 23, 133)
                      : Colors.black,
                ),
                label: _titleList[1],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _iconList[2],
                  color: _bottomNavIndex == 2
                      ? const Color.fromARGB(255, 116, 23, 133)
                      : Colors.black,
                ),
                label: _titleList[2],
              ),
            ],
            onTap: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}