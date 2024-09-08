import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: buildFrontieSection(context),
    );
  }

  Widget buildFrontieSection(BuildContext context) {
    final theme = Theme.of(context); // Retrieve theme
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0, // Adjust size as needed
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/pogisivenz.png'), // Replace with actual path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.0), // Space between image and text
                Expanded(
                  child: Container(
                    height: 64.0,
                    padding: EdgeInsets.only(left: 8.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Dr. Vidal chccuc",
                            style: theme.textTheme.headlineLarge,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.0,),
                          child: Text(
                            "Occupation",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text(
                              "7:00 P.M",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildAppointmentsSection(context),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 76.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Add your content here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
