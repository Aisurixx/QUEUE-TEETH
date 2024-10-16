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
            // ignore: deprecated_member_use
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
    final now = DateTime.now();
    final appointmentDate = DateTime.parse(appointment.date);

    final formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate.toLocal());
    final daysUntilAppointment = appointmentDate.difference(now).inDays;

    // Progress calculation
    final totalTime = appointmentDate.difference(now).inHours;
    final timePassed = now.difference(appointmentDate.subtract(Duration(days: daysUntilAppointment))).inHours;
    final progress = (timePassed / totalTime).clamp(0.0, 1.0);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // Deep navy blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD0D0D0), // Light gray border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.service,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white, // White text for contrast
            ),
          ),
          const SizedBox(height: 8), // Space between items
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
              const SizedBox(width: 5),
              Text(
                'Date: $formattedDate',
                style: const TextStyle(color: Colors.grey, fontSize: 12), // Use grey for minimalistic style
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 14),
              const SizedBox(width: 5),
              Text(
                'Time: ${appointment.time}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12), // Space before the status
          Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF00FF00), size: 14), // Green for confirmed
              const SizedBox(width: 5),
              const Text(
                'Status: Confirmed',
                style: TextStyle(color: Color(0xFF00FF00), fontSize: 12), // Green accent
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.2), // Lighter background for the bar
            color: const Color(0xFF4CAF50), // Green for the progress indicator
          ),
          const SizedBox(height: 6),
          Text(
            '${daysUntilAppointment > 0 ? "$daysUntilAppointment days" : "Today"} until appointment',
            style: const TextStyle(color: Colors.grey, fontSize: 12), // Simple, understated text
          ),
        ],
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
