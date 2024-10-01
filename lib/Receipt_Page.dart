import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON encoding

class ReceiptPage extends StatefulWidget {
  final String bookingId;

  ReceiptPage({required this.bookingId});

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  Map<String, dynamic>? receipt;

  @override
  void initState() {
    super.initState();
    fetchReceipt();
  }

  Future<void> fetchReceipt() async {
    final receiptUrl = Uri.parse('http://127.0.0.1:8000/api/bookings/{id}/receipt'); 
    
    final response = await http.get(receiptUrl);

    if (response.statusCode == 200) {
      setState(() {
        receipt = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to fetch receipt: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: receipt == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service: ${receipt!['service']}', style: TextStyle(fontSize: 18)),
                  Text('Price: ${receipt!['price']}', style: TextStyle(fontSize: 18)),
                  Text('Total Price: ${receipt!['total_price']}', style: TextStyle(fontSize: 18)),
                  Text('Booking Time: ${receipt!['booking_time']}', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
