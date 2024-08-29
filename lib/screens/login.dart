import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isButtonVisible = true; // Boolean to track the visibility of the button

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleSignIn() {
    if (_controller.isCompleted) {
      _controller.reverse();
      setState(() {
        _isButtonVisible = true; // Show the button when the animation reverses
      });
    } else {
      _controller.forward();
      setState(() {
        _isButtonVisible = false; // Hide the button when the animation starts
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1E9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1E9F6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            child: Image.asset(
              'assets/logo.png',
              height: 400,
              width: 500,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0),
                end: const Offset(0, 1),
              ).animate(_animation),
              child: Container(
                height: 460.0, // Set the height here
                decoration: const BoxDecoration(
                  color: Colors.white, // Ensure the sign-in box is visible against the background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const TextField(
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                      const TextField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle sign-in action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 236, 228, 228), // Set the button color to gray
                        ),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isButtonVisible) // Conditionally display the button
            Center(
              child: ElevatedButton(
                onPressed: _toggleSignIn,
                child: const Text('LOGIN'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
