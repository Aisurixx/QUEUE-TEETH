import 'package:flutter/material.dart';
import 'login.dart'; // Import the new file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(), // Use the SignInPage class from login.dart
    );
  }
}
