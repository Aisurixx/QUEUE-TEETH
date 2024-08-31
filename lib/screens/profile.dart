import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  final String imagePath = 'assets/pogisivenz.png';
  final String userName = 'MEOWMEOWMEOW'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
              ),
            ),
            const SizedBox(height: 10),

            // Action Buttons (e.g., Edit Profile)
            ElevatedButton(
              onPressed: () {
                // Implement Edit Profile functionality
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Implement Logout functionality
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyProfile(),
  ));
}
