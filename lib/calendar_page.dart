import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'receipt_page.dart';

class CalendarPage extends StatefulWidget {
  final String service;
  final String price;

  CalendarPage({required this.service, required this.price});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  Map<DateTime, List<TimeOfDay>> _bookedAppointments = {};
  
  String? _paymentId;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _fetchBookedAppointments();
  }

  Future<void> _fetchBookedAppointments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('appointments')
          .select('date, time')
          .execute();

      if (response.status == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          for (var item in data) {
            DateTime date = DateTime.parse(item['date']);
            TimeOfDay time = TimeOfDay(
              hour: int.parse(item['time'].split(':')[0]),
              minute: int.parse(item['time'].split(':')[1]),
            );
            if (_bookedAppointments.containsKey(date)) {
              _bookedAppointments[date]!.add(time);
            } else {
              _bookedAppointments[date] = [time];
            }
          }
        });
      } else {
        final errorMessage = response.data != null
            ? response.data['message'] ?? 'Unknown error occurred.'
            : 'Error fetching booked appointments.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching booked appointments: $errorMessage")),
        );
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _makePayment(double amount) async {
    final String paymongoUrl = 'https://api.paymongo.com/v1/links';
    final String apiKey = 'sk_test_JwWDRviSQGg1qajfGmQhrVGN';

    final response = await http.post(
      Uri.parse(paymongoUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'amount': (amount * 100).toInt(),
            'currency': 'PHP',
            'payment_method_allowed': ['gcash', 'card'],
            'description': 'Payment for ${widget.service} on ${DateFormat('yyyy-MM-dd').format(_selectedDay)} at ${_selectedTime!.format(context)}',
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _paymentId = responseData['data']['id'];
      return responseData['data']['attributes']['checkout_url'];
    } else {
      print('Payment intent creation failed: ${response.body}');
      return null;
    }
  }

  Future<bool> _checkPaymentStatus(String paymentId) async {
    final String paymongoPaymentUrl = 'https://api.paymongo.com/v1/payments/$paymentId';
    final String apiKey = 'sk_test_JwWDRviSQGg1qajfGmQhrVGN';

    final response = await http.get(
      Uri.parse(paymongoPaymentUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data']['attributes']['status'] == 'paid';
    } else {
      print('Payment status check failed: ${response.body}');
      return false;
    }
  }

  Future<void> _saveAppointment() async {
  if (_selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select a time.")),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User is not authenticated.")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  // Get the user's email
  final String? email = user.email;

  double? parsedPrice = double.tryParse(widget.price.replaceAll('₱', '').replaceAll(',', ''));
  if (parsedPrice == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid price format.")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  String? checkoutUrl = await _makePayment(parsedPrice);
  if (checkoutUrl == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed. Please try again.")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  if (await canLaunch(checkoutUrl)) {
    await launch(checkoutUrl);
  } else {
    throw 'Could not launch $checkoutUrl';
  }

  // Insert the appointment into Supabase with the user's email
  final response = await Supabase.instance.client
      .from('appointments')
      .insert({
        'service': widget.service,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
        'time': _selectedTime!.format(context),
        'price': parsedPrice,
        'user_id': user.id,
        'email': email,  // Include the user's email here
      })
      .execute();

  if (response.status == 201) {
    await _fetchBookedAppointments();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          service: widget.service,
          date: _selectedDay,
          time: _selectedTime!,
          price: widget.price,
        ),
      ),
    );
  } else {
    final errorMessage = response.data != null
        ? response.data['message'] ?? 'Unknown error occurred.'
        : 'Unknown error occurred.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving appointment: $errorMessage")),
    );
  }

  setState(() {
    _isLoading = false;
  });
}


  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(color: Color(0xFFE5D9F2)), // Set AppBar text color
        ),
        backgroundColor: Colors.blueAccent, // Optional: Set AppBar background color
        iconTheme: IconThemeData(color: Color(0xFFE5D9F2)), // Set back button color
        flexibleSpace: Image.asset(
          'assets/appbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container for the date selection area with a white background
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.all(16.0), // Padding around the calendar
                child: TableCalendar(
                  focusedDay: _focusedDay,
  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  onDaySelected: (selectedDay, focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  },
  firstDay: DateTime.now(), // Disable past dates
  lastDay: DateTime.now().add(Duration(days: 365)),
  calendarStyle: CalendarStyle(
    todayDecoration: BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
    selectedDecoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _selectTime,
                child: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : 'Selected Time: ${_selectedTime!.format(context)}',
                  style: TextStyle(color: Color(0xFFE5D9F2)), // Set text color
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _saveAppointment,
                child: Text(
                  'Confirm Appointment',
                  style: TextStyle(color: Color(0xFFE5D9F2)), // Set text color
                ),
              ),
              if (_isLoading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}