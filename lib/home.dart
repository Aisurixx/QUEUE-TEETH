import 'package:flutter/material.dart';
import 'screens/profile.dart'; // Ensure ProfilePage is defined in profile.dart
import 'screens/home_screen.dart'; // Ensure HomeScreen is defined in home_screen.dart
import 'calendar_page.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentPage(),
    // Add more pages here if needed
  ];

  final List<IconData> _iconList = [
    Icons.home_filled,
    Icons.add_rounded,
    // Add more icons if needed
  ];

  final List<String> _titleList = [
    'Home',
    'Appointments',
    // Add more titles if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/pogisivenz.png'),
                      radius: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Hi, Harold Pogi'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/splash.png', // Ensure this path is correct
            fit: BoxFit.cover,
          ),
          // Main content
          _pages[_bottomNavIndex],
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 30.0),
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
                  color: _bottomNavIndex == 0 ? Colors.blue : Colors.black,
                ),
                label: _titleList[0],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _iconList[1],
                  color: _bottomNavIndex == 1 ? Colors.blue : Colors.black,
                ),
                label: _titleList[1],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.format_list_bulleted_sharp,
                  color: _bottomNavIndex == 2 ? Colors.blue : Colors.black,
                ),
                label: '',
              ),
            ],
            onTap: (index) {
              if (index == 2) {
                _showSelectMenu(context);
              } else {
                setState(() {
                  _bottomNavIndex = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Settings'),
          content: Text('Settings options go here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSelectMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_month, color: Colors.black),
                  title: Text('Calendar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.black),
                  title: Text('Location'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history_edu, color: Colors.black),
                  title: Text('History'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppointmentPage extends StatelessWidget {
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning'},
    {'value': 'routine_cleanings', 'label': 'Routine Cleanings'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening'},
    {'value': 'root_canals', 'label': 'Root Canals'},
    {'value': 'extractions', 'label': 'Extractions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: choices.map((choice) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarPage()),
                  );
                },
                child: Text(choice['label']!),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
