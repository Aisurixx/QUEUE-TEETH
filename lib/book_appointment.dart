import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AppointmentPage extends StatelessWidget {
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta', 'price': '\$50'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning', 'price': '\$70'},
    {'value': 'braces', 'label': 'Braces', 'price': '\$40000'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening', 'price': '\$100'},
    {'value': 'root_canals', 'label': 'Root Canals', 'price': '\$200'},
    {'value': 'extractions', 'label': 'Extractions', 'price': '\$700'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height as needed
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'), // Your AppBar background image
              fit: BoxFit.cover, // Adjust the image to cover the AppBar
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove the shadow line by setting elevation to 0
            title: Text(
              'Appointments',
              style: TextStyle(
                color: Color(0xFFE5D9F2),
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
                crossAxisCount: 1,  // Single column layout
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0,  // Space between rows
                childAspectRatio: 4.0, // Adjust aspect ratio for button sizing
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
                      width: 80, // Set width to 80
                      height: 35, // Set height to 35
                      decoration: BoxDecoration(
                        color: Color(0xFFE5D9F2), // Button background color
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Label on the left side
                            Text(
                              choices[index]['label']!,
                              style: TextStyle(
                                color: Colors.black, // Ensure text is readable
                                fontSize: 20.0,  // Text size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Price on the right side
                            Text(
                              choices[index]['price']!,
                              style: TextStyle(
                                color: Colors.black, // Ensure text is readable
                                fontSize: 18.0,  // Text size for price
                              ),
                            ),
                          ],
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
