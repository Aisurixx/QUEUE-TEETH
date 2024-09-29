import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevents system back button navigation
      child: Scaffold(
        extendBodyBehindAppBar: true, // Ensures the background extends behind the AppBar
        extendBody: true, // Ensures the background extends behind the navigation bar
        appBar: AppBar(
          title: const Text(''),
          automaticallyImplyLeading: false, // Removes the back button
          backgroundColor: Colors.transparent, // Make AppBar transparent to show background
          elevation: 0, // Remove shadow under the AppBar
        ),
        body: Stack(
          children: [
            // Fullscreen background container
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/33.png'), // Replace with your background image path
                  fit: BoxFit.cover, // Ensure the image covers the entire screen
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: buildFrontieSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFrontieSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            // You can add colors to the gradient if needed
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}
