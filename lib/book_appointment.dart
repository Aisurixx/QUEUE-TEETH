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
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: choices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // 2 boxes per row
            crossAxisSpacing: 16.0, // Space between columns
            mainAxisSpacing: 16.0,  // Space between rows
            childAspectRatio: 2.5, // Aspect ratio for compact design
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
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0), // Reduced corner radius
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
                        color: Colors.white,
                        fontSize: 16.0,  // Reduced text size for compact design
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
    );
  }
}
