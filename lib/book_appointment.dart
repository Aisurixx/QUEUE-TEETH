import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AppointmentPage extends StatelessWidget {
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning'},
    {'value': 'routine_cleanings', 'label': 'Routine Cleanings'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening'},
    {'value': 'root_canals', 'label': 'Root Canals'},
    {'value': 'extractions', 'label': 'Extractions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Adjust the height as needed
        child: Container(
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            title: Text(
              'Appointments',
              style: TextStyle(
                color: Color.fromARGB(255, 9, 1, 18), // Set color to E5D9F2
                fontFamily: 'Roboto', // Set font to Roboto
              ),
            ),
            centerTitle: true, // Center the title
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Main Content (Grid of Appointment Choices)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: choices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,  // Change to 1 column for a single column layout
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0,  // Space between rows
                childAspectRatio: 3.5, // Adjust aspect ratio for button sizing
              ),
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,  // Show click cursor
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage()),
                      );
                    },
                    child: Container(
                      width: 80, // Set width to 80 (smaller than before)
                      height: 30, // Set height to 35 (smaller than before)
                      decoration: BoxDecoration(
                        color: Color(0xFFE5D9F2), // Background color set to E5D9F2
                        borderRadius: BorderRadius.circular(8.0), // Reduced corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          choices[index]['label']!,
                          style: TextStyle(
                            color: Colors.black, // Change text color to ensure readability
                            fontSize: 14.0,  // Reduced text size for compact design
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
