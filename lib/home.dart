import 'package:flutter/material.dart';
import 'screens/profile.dart';
import 'screens/home_screen.dart';

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
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10), // Add space at the top
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/pogisivenz.png'),
                      radius: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Set a static or empty title here
                  Text('Hi, Harold Pogi'), // Or you can use an empty string: Text(''),
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
      body: _pages[_bottomNavIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        decoration: const BoxDecoration(
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
          borderRadius: const BorderRadius.vertical(
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
                  leading: const Icon(Icons.calendar_month, color: Colors.black),
                  title: const Text('Calendar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.black),
                  title: const Text('Location'),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Appointment Page Content'),
    );
  }
}
