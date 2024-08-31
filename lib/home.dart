import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int _bottomNavIndex = 0;

  final List<Widget> pages = [
    HomePage(),
  ];

  final List<IconData> iconList = [
    Icons.home_filled,
    Icons.person,
  ];

  final List<String> titleList = [
    'Home',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleList[_bottomNavIndex]),
      ),
      body: pages[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(iconList[0]),
            label: titleList[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(iconList[1]),
            label: titleList[1],
          ),
        ],
        onTap: (index) {
          // You would normally call setState here, but since this is StatelessWidget,
          // consider converting it to StatefulWidget if you need dynamic behavior.
        },
      ),
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
