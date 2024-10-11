import 'dart:ui'; // Import for BackdropFilter
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String noAppointmentsMessage = 'No upcoming appointments';
  static const String errorMessage = 'Error: ';
  static const double appBarHeight = 60.0;
  static const double frontieContainerHeightFactor = 0.25;

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
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    margin: const EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFE5D9F2),
          Color(0xFFD1C4E9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Row(
      children: [
        ClipOval(
          
          child: Image.asset(
            'assets/pogisivenz.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10), // Space between image and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically beside the image
          children: const [
            Text(
              'Dr. Emelyn Vidal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Status: Online',
              style: TextStyle(color: Colors.green, fontSize: 14),
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          appointments.isNotEmpty
              ? buildAppointmentCard(appointments.first)
              : const Text('No appointments'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildAppointmentCard(Appointment appointment) {
  final formattedDate = DateFormat('MMMM d, yyyy').format(DateTime.parse(appointment.date).toLocal()); // Convert UTC to local
  
  return ClipRRect(
    borderRadius: BorderRadius.circular(20), // Rounded corners for a softer, glassy look
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Light opacity for a translucent effect
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2), // Border to simulate the glass edge
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // Subtle shadow for depth
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // Lifted shadow effect
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Strong blur for glass distortion
        child: Container(
          padding: const EdgeInsets.all(20), // More padding for content spacing
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), // Subtle gradient for depth within the glass
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.service,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // Larger font size
                  color: Colors.white, // Bright white for contrast
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: $formattedDate - Time: ${appointment.time}',
                style: const TextStyle(color: Colors.white70), // Semi-transparent white text
              ),
              const SizedBox(height: 4),
              Text(
                'Duration: ${appointment.duration ?? 'N/A'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                'Status: Confirmed',
                style: const TextStyle(
                  color: Colors.greenAccent, // Green accent for status
                  fontSize: 14,
                ),
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
