import 'package:flutter/material.dart';
import 'package:queueteeth/home.dart';
import 'package:queueteeth/login.dart';

class ProfilePage extends StatelessWidget {
  final String imagePath = 'assets/pogisivenz.png';
  final String userName = 'Harold nag LULU'; 
  final String backgroundImagePath = 'assets/splash.png';
  final String appBarBackgroundImagePath = 'assets/appbar.png'; // AppBar background image path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set height of AppBar
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(appBarBackgroundImagePath), // Background image for AppBar
              fit: BoxFit.cover, // Cover the AppBar
            ),
          ),
          child: AppBar(
            title: const Text('Profile', style: TextStyle(color: Color(0xFFE5D9F2))), // Set title color
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE5D9F2)), // Set back button color
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate directly to the home screen
                );
              },
            ),
            backgroundColor: Colors.transparent, // Make app bar background transparent
            elevation: 0, // Remove app bar shadow
          ),
        ),
      ),
      body: Container(
        width: double.infinity, // Fill the width of the screen
        height: double.infinity, // Fill the height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath), // Background image for body
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column( // Remove Center widget to align items to the top
            mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40), // Add some space from the top

              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),

              // User's Name
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color for user's name
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  // Navigate to loading_screen.dart
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your loading screen widget
                  );
                },
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE5D9F2), // Button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
