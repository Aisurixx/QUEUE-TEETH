import 'package:flutter/material.dart';
import 'screens/profile.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentPage(), 
  ];

  final List<IconData> _iconList = [
    Icons.home_filled,
    Icons.add_rounded, 
  ];

  final List<String> _titleList = [
    '',
    '', 
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
                  MaterialPageRoute(builder: (context) => ProfilePage()), // Updated navigation
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets\pogisivenz.png'), // Replace with your image path
                radius: 20, 
              ),
            ),
            SizedBox(width: 10), // Space between image and text
            Text(_titleList[_bottomNavIndex]),
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
        children: [
          _pages[_bottomNavIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 30.0), // Margin to create space from the bottom
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
                      icon: Icon(_iconList[0], color: Colors.black),
                      label: _titleList[0],
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(_iconList[1], color: Colors.black),
                      label: _titleList[1],
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.format_list_bulleted_sharp, color: Colors.black),
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
          ),
        ],
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Page Content'),
    );
  }
}

class AppointmentPage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Text('Appointment Page Content'),
      ),
    );
  }
}
