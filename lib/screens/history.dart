import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui'; // Import for BackdropFilter

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> patientHistory = [];  // Update to dynamic

  @override
  void initState() {
    super.initState();
    _fetchPatientHistory();
  }

  Future<void> _fetchPatientHistory() async {
    // Get the current authenticated user
    final user = supabase.auth.currentUser;

    if (user == null) {
      // If the user is not authenticated, return or show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User is not authenticated.")),
      );
      return;
    }

    // Fetch appointments for the authenticated user
    final response = await supabase
        .from('appointments')
        .select('service, date, time, price')
        .eq('user_id', user.id) // Filter by user_id
        .execute();

    if (response.error == null) {
      setState(() {
        patientHistory = (response.data as List).cast<Map<String, dynamic>>(); // Update to cast to List<Map<String, dynamic>>
      });
    } else {
      print('Error fetching patient history: ${response.error!.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching history: ${response.error!.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            'Services and Appointments',
                            style: TextStyle(
                              color: Color(0xFFE5D9F2),
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
                          patient['service'].toString(),  // Use .toString() for dynamic values
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${patient['date'].toString()}',  // Use .toString() for dynamic values
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              'Time: ${patient['time'].toString()}',  // Use .toString() for dynamic values
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              'Price: ${patient['price'].toString()}',  // Use .toString() for dynamic values
                              style: const TextStyle(
                                color: Colors.black54,
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

extension on PostgrestResponse {
  get error => null;
}
