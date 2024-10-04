import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'receipt_page.dart';
import 'package:intl/intl.dart';

class TimeSelectionPage extends StatefulWidget {
  final DateTime selectedDate;
  final String service;
  final String price;

  TimeSelectionPage({
    required this.selectedDate,
    required this.service,
    required this.price,
  });

  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  TimeOfDay? _selectedTime;
  bool _isLoading = false; // State variable for loading

  Future<void> _saveAppointment() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time.")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    final response = await Supabase.instance.client
        .from('appointments')
        .insert({
          'service': widget.service,
          'date': DateFormat('yyyy-MM-dd').format(widget.selectedDate),
          'time': _selectedTime!.format(context),
          'price': double.tryParse(widget.price.replaceAll('\$', '')), // Handle parsing safely
        })
        .execute();

    // Check if the response is successful
    if (response.status == 201) { // Check for success status (201 Created)
      // Navigate to receipt page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
            service: widget.service,
            date: widget.selectedDate,
            time: _selectedTime!,
            price: widget.price,
          ),
        ),
      );
    } else {
      // Handle error (e.g., show a message)
      final errorMessage = response.error?.message ?? 'Unknown error';
      print("Error: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $errorMessage")),
      );
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'), // Update this to your image path
              fit: BoxFit.cover, // Fit the image to cover the AppBar
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
            children: [
              SizedBox(height: 20), // Add some space from the top
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
                child: Text('Pick Time'),
              ),
              SizedBox(height: 30),
              Text(
                'Selected Date: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              if (_selectedTime != null)
                Text(
                  'Selected Time: ${_selectedTime!.format(context)}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedTime == null ? null : () async {
                  await _saveAppointment();
                },
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text("Confirm Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}
