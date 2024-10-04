import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: const Text(''),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: buildFrontieSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFrontieSection(BuildContext context) {
    // Use MediaQuery to set a dynamic height
    double containerHeight = MediaQuery.of(context).size.height * 0.25; // 25% of screen height

    return Container(
      width: double.infinity,
      height: containerHeight, // Use dynamic height
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal margin for space on the sides
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE5D9F2), // Lighter color at the top
            Color(0xFFD1C4E9), // Darker color for more contrast
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Soft shadow for depth
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/pogisivenz.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dr. Star ng pasko ko',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Status: Online',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
