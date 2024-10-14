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
                  Text("Service: $service", style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text("Date: ${date.toLocal().toIso8601String().split('T')[0]}", style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text("Time: ${time.format(context)}", style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text("Price: $price", style: TextStyle(fontSize: 20, color: Colors.white)),
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
                    child: Text("Back to Home"),
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
