import 'package:flutter/material.dart';
import 'package:queueteeth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String imagePath = 'assets/pogiako.jpg';
  final String backgroundImagePath = 'assets/splash.png';
  String userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        setState(() {
          userName = 'User not logged in';
        });
        return;
      }

      final response = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('id', user.id)
          .single()
          .execute();

      if (response.error != null) {
        setState(() {
          userName = 'Error: ${response.error!.message}';
        });
      } else if (response.data == null) {
        setState(() {
          userName = 'No profile found';
        });
      } else {
        final data = response.data as Map<String, dynamic>;
        setState(() {
          userName = data['username'] ?? 'No Name Available';
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Unexpected error occurred: $e';
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Fill the width of the screen
        height: double.infinity, // Fill the height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath), // Background image for body
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60), // Add space from the top for the "Profile" text


              const Text(
                'Profile',
                style: TextStyle(
                 fontFamily: 'Roboto',
                  fontSize: 28.0, // Adjust font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),

              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5D9F2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ktujgddbdoofejgxphmu.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0dWpnZGRiZG9vZmVqZ3hwaG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc4Nzc1OTksImV4cCI6MjA0MzQ1MzU5OX0.lB7xLbeGm6HjcaEItrpmH_P9Rqw5Q_nUMdetCzYMMNw', // Replace with your Supabase anon key
  );
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
