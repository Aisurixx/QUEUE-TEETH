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
          Color(0xFFFFFFFF), // White
          Color(0xFE5FFF), // Grey
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.0), // Rounded corners
      // Removed boxShadow property
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align to the start (top left)
      crossAxisAlignment: CrossAxisAlignment.start, // Align items at the start vertically
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
        Column(
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
          .gte('date', now.toIso8601String()) // Ensure the date comparison is in UTC
          .order('date', ascending: true)
          .execute();

      if (response.error != null) {
        throw Exception('Error fetching appointments: ${response.error!.message}');
      }

      final List<dynamic> data = response.data;
      if (data == null || data.isEmpty) return {}; // Handle empty case

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
    return Column(
      children: [
        buildCategorySection('This Week', appointments['thisWeek'] ?? []),
        buildCategorySection('Next Week', appointments['nextWeek'] ?? []),
      ],
    );
  }

  Widget buildCategorySection(String title, List<Appointment> appointments) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title == 'This Week') // Only add this text for 'This Week'
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row
            children: [
              const Padding( // Add padding to the title
                padding: EdgeInsets.only(right: 8.0), // Space between text and icon
                child: Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const Icon(Icons.notifications, color: Colors.yellow, size: 20),
            ],
          ),
        const SizedBox(height: 8),
        // Title aligned to the left
        Align(
          alignment: Alignment.centerLeft,
          child: Padding( // Add padding to the title
            padding: const EdgeInsets.only(left: 70.0), // Adjust this value as needed
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color.fromARGB(255, 0, 0, 0),
                shadows: [
                  Shadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Centered appointment card
        Center(
          child: appointments.isNotEmpty
              ? buildAppointmentCard(appointments.first)
              : const Text('No appointments', style: TextStyle(color: Colors.white70)),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}






  Widget buildAppointmentCard(Appointment appointment) {
  final formattedDate = DateFormat('MMMM d, yyyy').format(DateTime.parse(appointment.date).toLocal());

  return ClipRRect(
    borderRadius: BorderRadius.circular(15), // Border radius remains unchanged
    child: Container(
      width: 280, // You can adjust this width as needed
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromARGB(255, 86, 29, 94).withOpacity(0.5), // Neon blue border
          width: 1.5, // Border width remains unchanged
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.5), // Neon glow effect
            spreadRadius: 2,
            blurRadius: 20, // Shadow blur remains unchanged
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7), // Blur remains unchanged
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Reduced padding
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.service,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Reduced font size for service name
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.blueAccent,
                      blurRadius: 8, // Shadow blur remains unchanged
                      offset: Offset(0, 0), // Neon text shadow
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4), // Reduced space between elements
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70, size: 14), // Smaller icon size
                  const SizedBox(width: 5),
                  Text(
                    'Date: $formattedDate',
                    style: const TextStyle(color: Colors.white70, fontSize: 12), // Reduced font size
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Time: ${appointment.time}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white70, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Duration: ${appointment.duration ?? 'N/A'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Slightly reduced space
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.greenAccent, size: 14),
                  const SizedBox(width: 5),
                  const Text(
                    'Status: Confirmed',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12), // Smaller status text
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}




}

// Appointment model
class Appointment {
  final String service;
  final String date;
  final String time;
  final String? duration; // Allow duration to be nullable

  Appointment({
    required this.service,
    required this.date,
    required this.time,
    this.duration, // duration is optional
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      service: json['service'],
      date: json['date'],
      time: json['time'],
      duration: json['duration'], // This could be null
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}
