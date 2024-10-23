import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AppointmentPage extends StatelessWidget {
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta', 'price': '700', 'category': 'Dental Services'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning', 'price': '500', 'category': 'Dental Services'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening', 'price': '1,000', 'category': 'Dental Services'},
    {'value': 'root_canals', 'label': 'Root Canals', 'price': '800', 'category': 'Dental Services'},
    {'value': 'extractions', 'label': 'Extractions', 'price': '700', 'category': 'Dental Services'},
    {'value': 'braces', 'label': 'Braces', 'price': '30,000', 'category': 'Orthodontics'},
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> groupedChoices = {};

    // Group services by category
    for (var choice in choices) {
      final category = choice['category']!;
      if (!groupedChoices.containsKey(category)) {
        groupedChoices[category] = [];
      }
      groupedChoices[category]!.add(choice);
    }

    return Scaffold(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.0), // Adds top margin above "Appointments"
                  Center(
                    child: Text(
                      'Appointments',
                      style: TextStyle(
                        color: Color.fromARGB(255, 252, 252, 252),
                        fontFamily: 'Roboto',
                        fontSize: 28.0, // Adjust font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0), // Add some space below "Appointments" text
                  ...groupedChoices.entries.map((entry) {
                    final category = entry.key;
                    final services = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 4.5,
                          ),
                          itemBuilder: (context, index) {
                            final service = services[index]['label']!;
                            final price = services[index]['price']!;

                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CalendarPage(service: service, price: price),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 70.0, // Increased height for better usability
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE5D9F2),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          service,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          price,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
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
                        if (services.any((s) => s['label'] == 'Extractions')) 
                          SizedBox(height: 40.0),
                        SizedBox(height: 16.0),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
