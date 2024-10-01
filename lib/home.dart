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
    Icons.history_edu,
  ];

  final List<String> _titleList = [
    'Home',
    'Appointments',
    'History',
  ];

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: _buildProfileHeader(),
      flexibleSpace: _buildAppBarBackground(),
    );
  }

  Widget _buildProfileHeader() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/pogisivenz.png'),
            radius: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Hi, Harold Pogi',
            style: TextStyle(color: Color(0xFFE5D9F2)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/appbar.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
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
          items: _iconList.asMap().entries.map((entry) {
            int index = entry.key;
            IconData icon = entry.value;
            return BottomNavigationBarItem(
              icon: Icon(
                icon,
                color: _bottomNavIndex == index
                    ? const Color.fromARGB(255, 116, 23, 133)
                    : Colors.black,
              ),
              label: _titleList[index],
            );
          }).toList(),
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          },
        ),
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
            child: _pages[_bottomNavIndex],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
