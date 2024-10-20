import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AppointmentPage extends StatelessWidget {
  final List<Map<String, String>> choices = [
    {'value': 'pasta', 'label': 'Pasta', 'price': '₱700', 'category': 'Orthodontics'},
    {'value': 'teeth_clean', 'label': 'Teeth Cleaning', 'price': '₱500', 'category': 'Dental Services'},
    {'value': 'braces', 'label': 'Braces', 'price': '₱30000', 'category': 'Orthodontics'},
    {'value': 'teeth_whitening', 'label': 'Teeth Whitening', 'price': '₱1000', 'category': 'Dental Services'},
    {'value': 'root_canals', 'label': 'Root Canals', 'price': '₱800', 'category': 'Dental Services'},
    {'value': 'extractions', 'label': 'Extractions', 'price': '₱700', 'category': 'Dental Services'},
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
            title: Container(
              padding: EdgeInsets.only(top: 30), // Adjust this value as needed
              child: Text(
                'Appointments',
                style: TextStyle(
                  color: Color(0xFFE5D9F2),
                  fontFamily: 'Roboto',
                ),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedChoices.entries.map((entry) {
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
                          childAspectRatio: 3.5,
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
                                height: 50.0, // Increased height for better usability
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF615792), Color(0xFFE5D9F2)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Increased padding for better spacing
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        service,
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        price,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
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
                        SizedBox(height: 70.0),
                      SizedBox(height: 16.0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],   
      ),
    );
  }
}
