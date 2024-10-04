import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'time_selection_page.dart'; // Ensure this path is correct

class CalendarPage extends StatefulWidget {
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
        preferredSize: Size.fromHeight(60.0), // Adjust height as needed
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.png'), // Path to your image
              fit: BoxFit.cover, // Cover the AppBar
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar transparent
            title: Text(
              'Select Date',
              style: TextStyle(
                color: Color(0xFFE5D9F2), // Change text color if needed
              ),
            ),
            centerTitle: true, // Center the title
            iconTheme: IconThemeData(
              color: Color(0xFFE5D9F2), // Set back button color
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'), // Path to your image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add a translucent container for better visibility of the calendar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // White background with transparency
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeSelectionPage(selectedDate: _selectedDay),
                      ),
                    );
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue, // Change the selected date color
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.green, // Change today's date color
                      shape: BoxShape.circle,
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // Hide format button
                    titleCentered: true, // Center the title
                    leftChevronVisible: true, // Show left navigation button
                    rightChevronVisible: true, // Show right navigation button
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color.fromARGB(255, 15, 14, 16)), // Customize left icon
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color.fromARGB(255, 15, 14, 16)), // Customize right icon
                  ),
                ),
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
