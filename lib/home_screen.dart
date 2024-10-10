import 'dart:ui'; // Import for BackdropFilter
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// For date formatting

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(appBarHeight),
          child: AppBar(
            title: const Text(''),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: Stack(
          children: [
            buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  buildFrontieSection(context),
                  const SizedBox(height: 20), // Space between sections
                  FutureBuilder<Map<String, List<Appointment>>>(
                    future: fetchUpcomingAppointments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('$errorMessage${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(noAppointmentsMessage);
                      } else {
                        final appointments = snapshot.data!;
                        return buildAppointmentsSections(appointments);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ],
      ),
    );
  }

  Future<Map<String, List<Appointment>>> fetchUpcomingAppointments() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final startOfNextWeek = endOfWeek.add(const Duration(days: 1));
    final endOfNextWeek = startOfNextWeek.add(const Duration(days: 6));

    final response = await Supabase.instance.client
        .from('appointments') // Replace with your table name
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .gt('date', now.toIso8601String())
        .order('date', ascending: true)
        .execute();

    if (response.error != null) {
      throw Exception('Error fetching appointments: ${response.error!.message}');
    }

    final List<dynamic> data = response.data;
    final allAppointments = data.map((json) => Appointment.fromJson(json)).toList();

    // Filter appointments into two categories
    final thisWeekAppointments = allAppointments.where((appt) {
      final appointmentDate = DateTime.parse(appt.date);
      return appointmentDate.isAfter(startOfWeek) && appointmentDate.isBefore(endOfWeek);
    }).toList();

    final nextWeekAppointments = allAppointments.where((appt) {
      final appointmentDate = DateTime.parse(appt.date);
      return appointmentDate.isAfter(startOfNextWeek) && appointmentDate.isBefore(endOfNextWeek);
    }).toList();

    return {
      'thisWeek': thisWeekAppointments,
      'nextWeek': nextWeekAppointments,
    };
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        appointments.isNotEmpty
            ? buildAppointmentCard(appointments.first)
            : const Text('No appointments'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildAppointmentCard(Appointment appointment) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // Translucent white background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.service,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${appointment.date} - Time: ${appointment.time}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}

// Appointment model
class Appointment {
  final String service;
  final String date;
  final String time;

  Appointment({required this.service, required this.date, required this.time});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      service: json['service'],
      date: json['date'],
      time: json['time'],
    );
  }
}
