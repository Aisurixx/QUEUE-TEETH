import 'package:flutter/material.dart';
import 'dart:ui'; // Import for ImageFilter
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isButtonVisible = true;
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleSignIn() {
    if (_isButtonVisible) {
      _controller.forward();
      setState(() {
        _isButtonVisible = false;
      });
    } else {
      _controller.reverse();
      setState(() {
        _isButtonVisible = true;
      });
    }
  }

  Future<void> _signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == "harold" && password == "123") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 40.0,
              left: MediaQuery.of(context).size.width / 2 - 200,
              child: Image.asset(
                'assets/logo.png',
                width: 400,
                height: 250,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _animation,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 400.0, // Adjusted height
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 236, 228, 228),
                              ),
                              child: const Text('Sign In'),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account yet?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Handle contact admin
                                  },
                                  child: const Text(
                                    'Contact an admin',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isButtonVisible)
              Positioned(
                top: 200,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _toggleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
