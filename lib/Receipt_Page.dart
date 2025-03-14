import 'dart:ui'; // Import this for BackdropFilter
import 'package:flutter/material.dart';
import 'package:queueteeth/home.dart'; // Import the home screen
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> _saveReceipt(BuildContext context) async {
    // Fetch the authenticated user
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // Handle unauthenticated user
      print('No user is currently authenticated.');
      return;
    }

    // Save receipt to the database, including the user ID
    final response = await Supabase.instance.client.from('receipts').insert({
      'user_id': user.id, // Add the user ID to associate the receipt with the user
      'service': service,
      'date': date.toIso8601String(),
      'time': time.format(context),
      'price': price,
    }).execute();

    if (response.error != null) {
      print('Error saving receipt: ${response.error!.message}');
    } else {
      print('Receipt saved successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // "Receipt" text
                  Text(
                    "Appointment Fee",
                    style: TextStyle(
                      fontSize: 30, // Adjust the font size as needed
                      color: Color.fromARGB(255, 248, 248, 248), // Set text color
                    ),
                  ),
                  SizedBox(height: 20), // Space between the title and content
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
                  // Button with smaller width
                  Container(
                    width: 200, // Adjust the width as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF615792), Color(0xFFE5D9F2)], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Make button background transparent to show the gradient
                        shadowColor: Colors.transparent, // Remove shadow to maintain the gradient effect
                      ),
                      onPressed: () async {
                        await _saveReceipt(context); // Pass context here
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

extension on PostgrestResponse {
  get error => null;
}
