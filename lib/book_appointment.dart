import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AppointmentPage extends StatelessWidget {
  // List of services, now with IDs for each service
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta', 'price': '\₱100', 'id': '1'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning', 'price': '\₱50', 'id': '2'},
    {'value': 'routine_cleanings', 'label': 'Routine Cleanings', 'price': '\₱80', 'id': '3'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening', 'price': '\₱150', 'id': '4'},
    {'value': 'root_canals', 'label': 'Root Canals', 'price': '\₱500', 'id': '5'},
    {'value': 'extractions', 'label': 'Extractions', 'price': '\₱300', 'id': '6'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          ),
          child: AppBar(
            title: Text(
              'Appointments',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove the AppBar shadow
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: choices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1, // Responsive layout
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3.5,
              ),
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Pass the selected service ID to the CalendarPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(serviceId: choices[index]['id']!),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4.0, // Added elevation for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE5D9F2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                choices[index]['label']!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0, // Increased text size
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                choices[index]['price']!,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
