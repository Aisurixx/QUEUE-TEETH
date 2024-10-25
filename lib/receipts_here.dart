import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReceiptsHere extends StatefulWidget {
  @override
  _ReceiptsHereState createState() => _ReceiptsHereState();
}

class _ReceiptsHereState extends State<ReceiptsHere> {
  // Function to fetch receipts for the authenticated user
  Future<List<Map<String, dynamic>>> _fetchReceipts() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently authenticated.');
    }

    final response = await Supabase.instance.client
        .from('receipts')
        .select()
        .eq('user_id', user.id)
        .execute();

    if (response.error != null) {
      throw Exception('Error fetching receipts: ${response.error!.message}');
    }

    // Return list of receipts if successful
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipts'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.PNG'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // FutureBuilder to fetch and display receipts
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchReceipts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while fetching data
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Show error message if there was an error
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Show message if no receipts are found
                return Center(
                  child: Text(
                    'No receipts found.',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                );
              }

              // Display list of receipts
              final receipts = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: receipts.length,
                itemBuilder: (context, index) {
                  final receipt = receipts[index];
                  return Card(
                    color: Colors.white.withOpacity(0.8), // Semi-transparent card
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Service: ${receipt['service']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Appointment Fee:'),
                          Text('Date: ${receipt['date']}'),
                          Text('Time: ${receipt['time']}'),
                          Text('Price: ${receipt['price']}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}
