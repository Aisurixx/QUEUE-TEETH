import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MyProfile(),
  ];

  final List<IconData> _iconList = [
    Icons.home_filled,
    Icons.add_rounded,
  ];

  final List<String> _titleList = [
    'Home',
    'Appointment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleList[_bottomNavIndex]),
      ),
      body: Stack(
        children: [
          _pages[_bottomNavIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 40.0), // Margin to create space from the bottom
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                  bottom: Radius.circular(30.0),
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
                  top: Radius.circular(16.0),
                  bottom: Radius.circular(16.0),
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
                      icon: Icon(Icons.more_horiz, color: Colors.black), 
                      label: 'Select',
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

  void _showSelectMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows custom height and width
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8, // Set width as 80% of the screen width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month, color: Colors.black), // Changed to black
                  title: const Text('Calendar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.black), // Changed to black
                  title: const Text('Location'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history_edu, color: Colors.black), // Changed to black
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

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page Content'),
    );
  }
}
