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

    final response = await Supabase.instance.client
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
          style: TextStyle(color: Color(0xFFE5D9F2)), 
        ),
        backgroundColor: Colors.blueAccent, 
        iconTheme: IconThemeData(color: Color(0xFFE5D9F2)),
        flexibleSpace: Image.asset(
          'assets/appbar.png',
          fit: BoxFit.cover,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  firstDay: DateTime.now(),
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
              // "Select Time" button with a narrower width and gradient
             TextButton(
  onPressed: _selectTime,
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero,
  ),
  child: Container(
    width: 200, // Adjusted width
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
              // "Confirm Appointment" button with a narrower width and gradient
             TextButton(
  onPressed: _saveAppointment,
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero,
  ),
  child: Container(
    width: 200, // Adjusted width
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
