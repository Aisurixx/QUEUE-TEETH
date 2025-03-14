import 'package:flutter/material.dart';
import 'package:queueteeth/screens/paymango_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> patientHistory = [];
  final PayMongoService payMongoService = PayMongoService();

  @override
  void initState() {
    super.initState();
    _fetchPatientHistory();
  }

  Future<void> _fetchPatientHistory() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not authenticated.")),
      );
      return;
    }

    final response = await supabase
        .from('appointments')
        .select('id::text, service, date, time, price, status')
        .eq('user_id', user.id)
        .order('date', ascending: false)
        .execute();

    if (response.error == null) {
      setState(() {
        patientHistory = (response.data as List).cast<Map<String, dynamic>>();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching history: ${response.error!.message}')),
      );
    }
  }

  Future<void> _handlePayment(double price, String description, String appointmentId) async {
    final checkoutUrl = await payMongoService.createPaymentIntent(price, description);
    if (checkoutUrl != null) {
      if (await canLaunch(checkoutUrl)) {
        await launch(checkoutUrl);

        // Assuming the payment was successful (replace this with actual confirmation logic)
        bool paymentSuccess = true;

        if (paymentSuccess) {
          final response = await supabase
              .from('appointments')
              .update({'status': 'paid'})
              .eq('id', appointmentId)
              .execute();

          if (response.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful! Status updated.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful, but failed to update status.')),
            );
          }
        }
      } else {
        throw 'Could not launch $checkoutUrl';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create payment intent.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
               const SizedBox(height: 50.0), // Adds top margin above "History"
              // History Title with Background Image (replacing the AppBar)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Center(
                  child: Text(
                    'History',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Services and Appointments Box
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
                  borderRadius: BorderRadius.circular(10.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white.withOpacity(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Services and Appointments',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
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
              // Patient History List
              Expanded(
                child: ListView.builder(
                  itemCount: patientHistory.length,
                  itemBuilder: (context, index) {
                    final patient = patientHistory[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: ListTile(
                        leading: const Icon(Icons.account_circle, size: 40.0, color: Colors.white),
                        title: Text(
                          patient['service'].toString(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${patient['date'].toString()}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              'Time: ${patient['time'].toString()}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              'Price: ${patient['price'].toString()}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              'Status: ${patient['status'].toString()}',
                              style: TextStyle(
                                color: _getStatusColor(patient['status'].toString()),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (patient['status'].toString() == 'Confirmed') ...[
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  final price = double.parse(patient['price'].toString());
                                  final description = 'Payment for ${patient['service']} on ${patient['date']}';
                                  final appointmentId = patient['id'].toString();
                                  _handlePayment(price, description, appointmentId);
                                },
                                child: const Text('Pay'),
                              ),
                            ],
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

  // Helper method to determine the color of the status text
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      case 'paid':
        return Colors.blue;
      default:
        return Colors.black54;
    }
  }
}

extension on PostgrestResponse {
  get error => null;
}
