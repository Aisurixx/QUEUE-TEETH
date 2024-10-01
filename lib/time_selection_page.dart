import 'package:flutter/material.dart';

class TimeSelectionPage extends StatefulWidget {
  final DateTime selectedDate;

  TimeSelectionPage({required this.selectedDate});

  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  TimeOfDay? _selectedTime; // Make _selectedTime nullable

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
              textAlign: TextAlign.center, // Center the text
              style: TextStyle(color: Color(0xFFE5D9F2)), // Set title text color
            ),
            backgroundColor: Colors.transparent, // Make AppBar transparent
            elevation: 0, // Remove shadow
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFE5D9F2)), // Set back button color
              onPressed: () => Navigator.of(context).pop(),
            ),
            toolbarHeight: 80.0, // Ensure the AppBar height is as defined
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'), // Update this to your image path
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Increase button size
                  textStyle: TextStyle(fontSize: 18), // Increase font size
                ),
                child: Text('Pick Time'),
              ),
              SizedBox(height: 30), // Space between button and other elements
              Text(
                'Selected Date: ${widget.selectedDate.toLocal()}',
                style: TextStyle(fontSize: 16, color: Colors.black), // Adjust text color if needed
              ),
              SizedBox(height: 20),
              if (_selectedTime != null) // Conditionally show time if selected
                Text(
                  'Selected Time: ${_selectedTime!.format(context)}',
                  style: TextStyle(fontSize: 16, color: Colors.black), // Adjust text color if needed
                ),
            ],
          ),
        ),
      ),
    );
  }
}
