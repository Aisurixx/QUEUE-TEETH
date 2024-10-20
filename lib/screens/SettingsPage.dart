import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to the profile edit page or implement functionality
                // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to the change password page or implement functionality
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Other Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Add other settings options here
            ListTile(
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to notifications settings page or implement functionality
              },
            ),
            ListTile(
              title: const Text('Privacy Settings'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to privacy settings page or implement functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
