import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isPaymentLoading = false;
  List<DateTime> _bookedDates = []; // List to hold booked dates

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _fetchBookedDates(); // Fetch booked dates on init
  }

  Future<void> _fetchBookedDates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch booked dates from the Supabase database
      final response = await Supabase.instance.client
          .from('appointments')
          .select('date')
          .execute();

      if (response.status == 200) {
        final List<dynamic> data = response.data;

        // Convert fetched date strings to DateTime objects and add to the list
        setState(() {
          _bookedDates = data.map((e) => DateTime.parse(e['date'])).toList();
        });
      } else {
        print("Error fetching booked dates: ${response.error?.message}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time.")),
      );
      return;
    }

    if (widget.price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Price is required.")),
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

    print('Inserting appointment with price: $parsedPrice');

    final response = await Supabase.instance.client
        .from('appointments')
        .insert({
          'service': widget.service,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
          'time': _selectedTime!.format(context),
          'price': parsedPrice,
          'user_id': user.id,
        })
        .execute();

    if (response.status == 201) {
      await _initiatePayment(widget.price);
      _fetchBookedDates(); // Refresh booked dates after saving
    } else {
      final errorMessage = response.error?.message ?? 'Unknown error';
      print("Error: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving appointment: $errorMessage")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _initiatePayment(String price) async {
    setState(() {
      _isPaymentLoading = true;
    });

    final String url = 'https://api.paymongo.com/v1/links';
    final String secretKey = 'sk_test_JwWDRviSQGg1qajfGmQhrVGN';

    final body = {
      "data": {
        "attributes": {
          'amount': (double.tryParse(price.replaceAll('₱', '').replaceAll(',', '')) ?? 0) * 100,
          'description': 'Payment for ${widget.service} on ${DateFormat('yyyy-MM-dd').format(_selectedDay)} at ${_selectedTime!.format(context)}',
          'currency': 'PHP',
        },
      },
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$secretKey:')),
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
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
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final errorMessage = decodedBody['errors']?.isNotEmpty ?? false
            ? decodedBody['errors'][0]['detail']
            : 'Unknown error occurred during payment.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Error: $errorMessage")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Error: Unable to process request.")),
      );
    } finally {
      setState(() {
        _isPaymentLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Select Date & Time',
              style: TextStyle(
                color: Color(0xFFE5D9F2),
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Color(0xFFE5D9F2),
            ),
          ),
        ),
      ),
      body: Container(
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    // Check if the selected day is in the past
                    if (selectedDay.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot select a date in the past.")),
                      );
                      return; // Do not update selected day if it's in the past
                    }

                    // Check if the selected day is already booked
                    if (_bookedDates.contains(selectedDay)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("This date is already booked.")),
                      );
                      return; // Do not update selected day if it's booked
                    }

                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _bookedDates.contains(_focusedDay)
                          ? Colors.red.withOpacity(0.5) // Change color for booked dates
                          : Colors.white, // Default color for available dates
                    ),
                    outsideDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _bookedDates.contains(_focusedDay)
                          ? Colors.red.withOpacity(0.5) // Change color for booked dates
                          : Colors.white, // Default color for available dates
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronVisible: true,
                    rightChevronVisible: true,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color.fromARGB(255, 15, 14, 16)),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color.fromARGB(255, 15, 14, 16)),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                child: _isLoading || _isPaymentLoading
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

bool isSameDay(DateTime? day1, DateTime? day2) {
  if (day1 == null || day2 == null) {
    return false;
  }
  return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
}
