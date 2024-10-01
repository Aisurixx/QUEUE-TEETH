import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'time_selection_page.dart'; // Make sure this path is correct

class CalendarPage extends StatefulWidget {
  final String serviceId; // Assuming you pass the service ID when navigating to CalendarPage

  CalendarPage({required this.serviceId});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
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
            backgroundColor: Colors.transparent,
            title: Text(
              'Select Date',
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
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  // Navigate to TimeSelectionPage with service ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeSelectionPage(
                        selectedDate: _selectedDay,
                        serviceId: widget.serviceId, // Pass the service ID
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isSameDay(DateTime? day1, DateTime? day2) {
  if (day1 == null || day2 == null) {
    return false;
  }
  return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
}
