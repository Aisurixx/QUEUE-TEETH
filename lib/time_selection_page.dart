import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON encoding
import 'receipt_page.dart'; // Ensure the path is correct based on your project structure

class TimeSelectionPage extends StatefulWidget {
  final DateTime selectedDate;
  final String serviceId; // Include service ID

  TimeSelectionPage({required this.selectedDate, required this.serviceId});

  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool isLoading = false; // Track loading state

  Future<void> bookAppointment() async {
    final bookingUrl = Uri.parse('http://127.0.0.1:8000/api/services/'); // Change to your actual URL

    setState(() {
      isLoading = true; // Show loading
    });

    try {
      final response = await http.post(
        bookingUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': widget.serviceId,
          'booking_time':
              DateFormat('yyyy-MM-dd').format(widget.selectedDate) +
                  ' ${_selectedTime.format(context)}',
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print response body for debugging

      if (response.statusCode == 201) {
        final receiptUrl = jsonDecode(response.body)['id']; // Get booking ID for receipt
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptPage(bookingId: receiptUrl),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment booked successfully!')),
        );
      } else {
        print('Failed to book appointment: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment. Please try again.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please check your connection.')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            title: Text(
              'Select Time',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFE5D9F2)),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFE5D9F2)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            toolbarHeight: 80.0,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
                child: Text('Pick Time'),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Text(
                  'Selected Time: ${_selectedTime.format(context)}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : bookAppointment, // Call booking function
                child: isLoading 
                    ? CircularProgressIndicator() // Show loading indicator
                    : Text('Confirm Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
