import 'package:flutter/material.dart';
import 'package:queueteeth/loading_screen.dart';
import 'package:queueteeth/splashscreen.dart'; // Import your loading_screen.dart file

class ProfilePage extends StatelessWidget {
  final String imagePath = 'assets/pogisivenz.png';
  final String userName = 'MEOWMEOWMEOW'; 
  final String backgroundImagePath = 'assets/splash.png';
  final String appBarBackgroundImagePath = 'assets/appbar.png'; // AppBar background image path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Set height of AppBar
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
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
            backgroundColor: Colors.transparent, // Make app bar background transparent
            elevation: 0, // Remove app bar shadow
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath), // Background image for body
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center( // Center the profile content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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

                // Action Buttons (e.g., Edit Profile)
                ElevatedButton(
                  onPressed: () {
                    // Implement Edit Profile functionality
                  },
                  child: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5D9F2), // Button color
                  ),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    // Navigate to loading_screen.dart
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()), // Replace with your loading screen widget
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
      ),
    );
  }
}

// Replace this with the actual LoadingScreen widget from loading_screen.dart

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
