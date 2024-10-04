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
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'), // Your AppBar background image
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Appointments',
              style: TextStyle(
                color: Color(0xFFE5D9F2),
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: choices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 4.0,
              ),
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final service = choices[index]['label']!;
                      final price = choices[index]['price']!;
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage(service: service, price: price)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE5D9F2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              choices[index]['label']!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              choices[index]['price']!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
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
