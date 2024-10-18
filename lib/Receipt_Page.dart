import 'dart:ui'; // Import this for BackdropFilter
import 'package:flutter/material.dart';
import 'package:queueteeth/home.dart'; // Import your HomePage

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
        title: Center(
          child: Text(
            "Receipt",
            style: TextStyle(color: Color(0xFFE5D9F2)), // Change text color
          ),
        ),
        automaticallyImplyLeading: false, // Remove the back button
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'), // Background image for the AppBar
              fit: BoxFit.cover, // Cover the entire AppBar area
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Make AppBar background transparent so the image shows
        elevation: 0, // Remove shadow
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
                      // Go back to the HomePage without creating a new instance
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFE5D9F2), // Set button text color to #E5D9F2
                      backgroundColor: Color(0xFF615792), // Set background color to #615792
                      minimumSize: Size(200, 50), // Adjust button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "Back to Appointments",
                      style: TextStyle(fontSize: 18), // Adjust text size
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
