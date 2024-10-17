import 'dart:ui'; // Import this for BackdropFilter
import 'package:flutter/material.dart';
import 'package:queueteeth/home.dart';
// Import the home screen

class ReceiptPage extends StatelessWidget {
  final String service;
  final DateTime date;
  final TimeOfDay time;
  final String price;

  ReceiptPage({
    required this.service,
    required this.date,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Path to your image
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glassmorphism effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Semi-transparent white
                        borderRadius: BorderRadius.circular(15.0), // Match the ClipRRect
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text("Service: $service", style: TextStyle(fontSize: 20, color: Colors.black)),
                              SizedBox(height: 10),
                              Text("Date: ${date.toLocal().toIso8601String().split('T')[0]}", style: TextStyle(fontSize: 20, color: Colors.black)),
                              SizedBox(height: 10),
                              Text("Time: ${time.format(context)}", style: TextStyle(fontSize: 20, color: Colors.black)),
                              SizedBox(height: 10),
                              Text("Price: $price", style: TextStyle(fontSize: 20, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to HomeScreen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false, // Removes all previous routes
                      );
                    },
                    child: Text(
                      "Back to Home",
                      style: TextStyle(color: Colors.black), // Set button text color to black
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
