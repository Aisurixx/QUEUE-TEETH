import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'receipt_page.dart'; // Ensure receipt_page.dart is imported

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
      await _fetchBookedAppointments();
      // Navigate to the ReceiptPage and pass the appointment details
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selected != null && selected != _selectedTime) {
      if (_isTimeBooked(_selectedDay, selected)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This time is already booked.")),
        );
        return;
      }

      setState(() {
        _selectedTime = selected;
      });
    }
  }

  bool _isTimeBooked(DateTime date, TimeOfDay time) {
    return _bookedAppointments[date]?.contains(time) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date & Time'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash.png'), // Ensure the path is correct
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // White background for the calendar
                  Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                  ),

                  // Selected date display (outside the white background)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  // Select Time button (outside the white background)
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      _selectedTime != null
                          ? 'Selected Time: ${_selectedTime!.format(context)}'
                          : 'Select Time',
                    ),
                  ),

                  SizedBox(height: 20),

                  // Confirm Appointment button (outside the white background)
                  ElevatedButton(
                    onPressed: _saveAppointment,
                    child: Text('Confirm Appointment'),
                  ),
                ],
              ),
            ),
    );
  }
}
