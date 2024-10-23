import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
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
        print('Fetched appointments data: $data'); // Debug line to print all data fetched
        setState(() {
          _bookedAppointments.clear(); // Clear existing appointments to refresh data
          for (var item in data) {
            DateTime date = DateTime.parse(item['date']);
            DateTime normalizedDate = DateTime(date.year, date.month, date.day);
            String timeString = item['time'];

            try {
              final timeParts = timeString.split(' ');
              if (timeParts.length == 2) {
                final time = timeParts[0].split(':');
                if (time.length == 2) {
                  int hour = int.parse(time[0]);
                  int minute = int.parse(time[1]);
                  String period = timeParts[1]; // AM or PM

                  if (period.toUpperCase() == 'PM' && hour < 12) {
                    hour += 12;
                  } else if (period.toUpperCase() == 'AM' && hour == 12) {
                    hour = 0;
                  }

                  if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
                    if (_bookedAppointments.containsKey(normalizedDate)) {
                      _bookedAppointments[normalizedDate]!.add(timeOfDay);
                    } else {
                      _bookedAppointments[normalizedDate] = [timeOfDay];
                    }
                  } else {
                    throw FormatException("Invalid time value: $timeString");
                  }
                } else {
                  throw FormatException("Invalid time format: $timeString");
                }
              } else {
                throw FormatException("Invalid time format: $timeString");
              }
            } catch (e) {
              print("Error parsing time: $timeString. Error: $e");
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

    if (_bookedAppointments.containsKey(_selectedDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This date is already fully booked.")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    DateTime startOfWeek = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    final response = await Supabase.instance.client
        .from('appointments')
        .select('date')
        .eq('user_id', user.id)
        .gte('date', DateFormat('yyyy-MM-dd').format(startOfWeek))
        .lte('date', DateFormat('yyyy-MM-dd').format(endOfWeek))
        .execute();

    if (response.status == 200 && response.data != null && (response.data as List).isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only book one appointment per week.")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

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

    final insertResponse = await Supabase.instance.client
        .from('appointments')
        .insert({
          'service': widget.service,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
          'time': _selectedTime!.format(context),
          'price': parsedPrice,
          'user_id': user.id,
          'email': email,
          'status': 'pending',
        })
        .execute();

    if (insertResponse.status == 201) {
      await _fetchBookedAppointments();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
            service: widget.service,
            date: _selectedDay,
            time: _selectedTime!,
            price: '₱50',
          ),
        ),
      );
    } else {
      final errorMessage = insertResponse.data != null
          ? insertResponse.data['message'] ?? 'Unknown error occurred.'
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
            SizedBox(height: 50), // Adjust the height as needed
            // Back button and title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50, // Set the width of the back button
                  height: 50, // Set the height of the back button
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 40), // Adjust icon size if needed
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Book Appointment',
                  style: TextStyle(
                    color: Color.fromARGB(255, 252, 252, 252),
                    fontFamily: 'Roboto',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space between title and calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: TableCalendar(
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (_bookedAppointments.containsKey(selectedDay)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("This date is already fully booked.")),
                    );
                  } else {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },


                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  eventLoader: (day) {
                    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                    return _bookedAppointments[normalizedDay] ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${events.length}',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _selectTime,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF615792), Color(0xFFE5D9F2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : 'Selected Time: ${_selectedTime!.format(context)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _saveAppointment,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF615792), Color(0xFFE5D9F2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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