import 'package:flutter/material.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay before transitioning to the HomePage
    Timer(const Duration(seconds: 10), () {
      // Ensure widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'), // Your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dental clinic logo
              Image.asset(
                'assets/logo.png', // Your logo image path
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 30),
              // Loading text
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // Text color for visibility
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Circular progress indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
