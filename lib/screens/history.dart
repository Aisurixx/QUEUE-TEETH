import 'package:flutter/material.dart';
import 'dart:ui'; // Import this to use BackdropFilter

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data: list of patients and their appointments
    final List<Map<String, String>> patientHistory = [
      {
        'name': 'Harold',
        'appointment': 'Kumasta',
        'date': '2024-02-14',
        'time': '1:00 AM'
      },
      {
        'name': 'Joden',
        'appointment': 'Kinasta',
        'date': '2024-09-30',
        'time': '1:30 PM'
      },
      {
        'name': 'Venz',
        'appointment': 'Kumagat',
        'date': '2024-10-01',
        'time': '11:45 AM'
      },
       {
        'name': 'Paul',
        'appointment': 'Kinagat',
        'date': '2024-10-01',
        'time': '12:45 AM'
      },
       {
        'name': 'Saymon',
        'appointment': 'Kinain',
        'date': '2024-12-25',
        'time': '9:45 AM'
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/appbar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'History',
            style: TextStyle(
              color: Color(0xFFE5D9F2),
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          Column(
            children: [
              const SizedBox(height: 20),
              // Glassmorphism container with BackdropFilter
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Ensures child is also rounded
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
                    child: Container(
                      width: double.infinity, // Fill width
                      height: double.infinity, // Fill height
                      color: Colors.white.withOpacity(0), // Semi-transparent background
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'These are the patients who appointed',
                            style: TextStyle(
                              color:
                              Color(0xFFE5D9F2),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 55,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: patientHistory.length,
                  itemBuilder: (context, index) {
                    final patient = patientHistory[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5), // Semi-transparent white for glass effect
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: ListTile(
                        leading: const Icon(Icons.account_circle, size: 40.0, color: Colors.white),
                        title: Text(
                          patient['name']!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        subtitle: Text(
                          patient['appointment']!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              patient['date']!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              patient['time']!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
