import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String noAppointmentsMessage = 'No upcoming appointments';
  static const String errorMessage = 'Error: ';
  static const double appBarHeight = 60.0;
  static const double frontieContainerHeightFactor = 0.25; // Increased size for more focus

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  buildFrontieSection(context),
                  buildUpcomingAppointmentsTitle(),
                  const SizedBox(height: 10), // Space between title and appointment listdadw
                  buildAppointmentList(),
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
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0), // Add top margin
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/tita.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Dr. Emelyn Vidal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Your Smile is our Priority',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      hintText: 'Feedback',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final userId = Supabase.instance.client.auth.currentUser?.id;
                    final feedback = _feedbackController.text;

                    if (userId != null && feedback.isNotEmpty) {
                      try {
                        final response = await Supabase.instance.client.from('feedback').insert({
                          'user_id': userId,
                          'comments': feedback,
                        }).execute();

                        if (response.error != null) {
                          print('Error submitting feedback: ${response.error!.message}');
                        } else {
                          print('Feedback submitted successfully: ${response.data}');
                          _feedbackController.clear();
                        }
                      } catch (e) {
                        print('Exception submitting feedback: $e');
                      }
                    } else {
                      print('User is not authenticated or feedback is empty');
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget buildUpcomingAppointmentsTitle() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'Upcoming Appointments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 227, 220, 255), // Updated color
            ),
          ),
        ),
        Icon(Icons.calendar_today, color: Color.fromARGB(255, 227, 220, 255)), // Updated color
      ],
    ),
  );
}

  Widget buildAppointmentList() {
    return Expanded(
      child: FutureBuilder<Map<String, List<Appointment>>>(
        future: fetchUpcomingAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('$errorMessage${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              (snapshot.data!['thisWeek']!.isEmpty &&
                  snapshot.data!['nextWeek']!.isEmpty)) {
            return const Center(
                child: Text(noAppointmentsMessage,
                    style: TextStyle(color: Colors.white)));
          } else {
            final appointments = snapshot.data!;
            return buildAppointmentsSections(appointments);
          }
        },
      ),
    );
  }

  Future<Map<String, List<Appointment>>> fetchUpcomingAppointments() async {
    final now = DateTime.now().toUtc(); // Use UTC for consistency
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final startOfNextWeek = endOfWeek.add(const Duration(days: 1));
    final endOfNextWeek = startOfNextWeek.add(const Duration(days: 6));

    try {
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
      if (data.isEmpty) return {'thisWeek': [], 'nextWeek': []};

      final allAppointments = data.map((json) => Appointment.fromJson(json)).toList();

      final thisWeekAppointments = allAppointments.where((appt) {
        final appointmentDate = DateTime.parse(appt.date).toUtc();
        return appointmentDate.isAfter(startOfWeek) && appointmentDate.isBefore(endOfWeek);
      }).toList();

      final nextWeekAppointments = allAppointments.where((appt) {
        final appointmentDate = DateTime.parse(appt.date).toUtc();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          buildCategorySection('This Week', appointments['thisWeek'] ?? []),
          buildCategorySection('Next Week', appointments['nextWeek'] ?? []),
        ],
      ),
    );
  }

  Widget buildCategorySection(String title, List<Appointment> appointments) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final dateTimeUtc = DateTime.parse(appointment.date).toUtc();
              final dateTimePht = dateTimeUtc.add(const Duration(hours: 8));
              final daysRemaining = DateTime.now().toUtc().difference(dateTimeUtc).inDays.abs();

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF39424e),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.service,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          DateFormat.yMMMd('en_PH').format(dateTimePht) +
                              ' ' +
                              DateFormat.jm('en_PH').format(dateTimePht),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Status: ${appointment.status}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF00FF00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Days until appointment: $daysRemaining',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFFA500),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
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

final TextEditingController _feedbackController = TextEditingController();
