import 'dart:ui'; // Import for BackdropFilter
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String noAppointmentsMessage = 'No upcoming appointments';
  static const String errorMessage = 'Error: ';
  static const double appBarHeight = 60.0;
  static const double frontieContainerHeightFactor = 0.20; // Reduced size

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: buildAppBar(),
        body: Stack(
          children: [
            buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  buildFrontieSection(context),
                  const SizedBox(height: 20), // Space between sections
                  buildAppointmentList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildFrontieSection(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * frontieContainerHeightFactor;

    return Container(
      width: double.infinity,
      height: containerHeight,
      padding: const EdgeInsets.all(20.0), // Adjusted padding for a sleeker look
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1E2F), // Dark background
            Color(0xFF2A2A3C), // Slightly lighter dark
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2), // A blue shadow for a techy feel
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0), // Slightly more rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (top left)
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/pogisivenz.png',
                  width: 50, // Increased size for better visibility
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15), // Space between image and text
              Column( // Use Column for the text
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: const [
                  Text(
                    'Dr. Emelyn Vidal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // White for better contrast
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15), // Space between name and feedback section
          // Feedback section
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Feedback',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white), // White text
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle feedback submission here
                },
                icon: Icon(Icons.arrow_forward, color: Colors.grey), // Arrow icon
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5), // Underline for text field
          ),
        ],
      ),
    );
  }

  Widget buildAppointmentList() {
    return FutureBuilder<Map<String, List<Appointment>>>(
      future: fetchUpcomingAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('$errorMessage${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty || (snapshot.data!['thisWeek']!.isEmpty && snapshot.data!['nextWeek']!.isEmpty)) {
          return const Center(child: Text(noAppointmentsMessage));
        } else {
          final appointments = snapshot.data!;
          return buildAppointmentsSections(appointments);
        }
      },
    );
  }

  Future<Map<String, List<Appointment>>> fetchUpcomingAppointments() async {
    final now = DateTime.now().toUtc(); // Use UTC for consistency
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final startOfNextWeek = endOfWeek.add(const Duration(days: 1));
    final endOfNextWeek = startOfNextWeek.add(const Duration(days: 6));

    try {
      // Fetch all upcoming appointments
      final response = await Supabase.instance.client
          .from('appointments')
          .select()
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          .eq('status', 'paid') // Filter for paid appointments
          .gte('date', now.toIso8601String()) // Ensure the date comparison is in UTC
          .order('date', ascending: true)
          .execute();

      if (response.error != null) {
        throw Exception('Error fetching appointments: ${response.error!.message}');
      }

      final List<dynamic> data = response.data;
      if (data == null || data.isEmpty) return {'thisWeek': [], 'nextWeek': []}; // Return empty lists

      final allAppointments = data.map((json) => Appointment.fromJson(json)).toList();

      // Filter appointments into two categories
      final thisWeekAppointments = allAppointments.where((appt) {
        final appointmentDate = DateTime.parse(appt.date).toUtc(); // Parse as UTC
        return appointmentDate.isAfter(startOfWeek) && appointmentDate.isBefore(endOfWeek);
      }).toList();

      final nextWeekAppointments = allAppointments.where((appt) {
        final appointmentDate = DateTime.parse(appt.date).toUtc(); // Parse as UTC
        return appointmentDate.isAfter(startOfNextWeek) && appointmentDate.isBefore(endOfNextWeek);
      }).toList();

      return {
        'thisWeek': thisWeekAppointments,
        'nextWeek': nextWeekAppointments,
      };
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }

  Widget buildAppointmentsSections(Map<String, List<Appointment>> appointments) {
    return Expanded( // Ensure it takes available space
      child: SingleChildScrollView( // Make the list scrollable
        child: Column(
          children: [
            buildCategorySection('This Week', appointments['thisWeek'] ?? []),
            buildCategorySection('Next Week', appointments['nextWeek'] ?? []),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySection(String title, List<Appointment> appointments) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title == 'This Week')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 14, 117, 206),
                  ),
                ),
              ),
              const Icon(Icons.calendar_today, color: Color.fromARGB(255, 14, 117, 206)),
            ],
          ),
        const SizedBox(height: 8.0),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final dateTimeUtc = DateTime.parse(appointment.date).toUtc(); // Parse as UTC
            final dateTimePht = dateTimeUtc.add(const Duration(hours: 8)); // Convert to PHT (UTC+8)

            return ListTile(
              title: Text(
                '${appointment.service} - ${DateFormat.yMMMd('en_PH').format(dateTimePht)} ${DateFormat.jm('en_PH').format(dateTimePht)}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Status: ${appointment.status}',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
      ],
    ),
  );
}

}

extension on PostgrestResponse {
  get error => null;
}

class Appointment {
  final String service;
  final String date;
  final String status;

  Appointment({required this.service, required this.date, required this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      service: json['service'],
      date: json['date'],
      status: json['status'],
    );
  }
}
