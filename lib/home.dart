import 'package:flutter/material.dart';
import 'screens/profile.dart';
import 'home_screen.dart';
import 'book_appointment.dart';
import 'screens/history.dart';

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
    Icons.history,
  ];

  final List<String> _titleList = [
    'Home',
    'Appointments',
    'History',
  ];

  PreferredSizeWidget? _buildAppBar() {
    if (_bottomNavIndex == 0) {
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
    return null;
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        selectedItemColor: const Color.fromARGB(255, 116, 23, 133),
        unselectedItemColor: Colors.black,
        items: _iconList.asMap().entries.map((entry) {
          int idx = entry.key;
          IconData icon = entry.value;
          return BottomNavigationBarItem(
            icon: Icon(icon),
            label: _titleList[idx],
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
