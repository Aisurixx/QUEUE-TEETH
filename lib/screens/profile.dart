import 'package:flutter/material.dart';
import 'package:queueteeth/login.dart';
import 'package:queueteeth/screens/SettingsPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String imagePath = 'assets/pogisivenz.png';
  final String backgroundImagePath = 'assets/splash.png';
  final String appBarBackgroundImagePath = 'assets/appbar.png';
  String userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
  try {
    final user = Supabase.instance.client.auth.currentUser;

    // Check if user is logged in
    if (user == null) {
      // No user is logged in
      setState(() {
        userName = 'User not logged in';
      });
      print('No user is currently logged in.');
      return;
    }

    print('Current User ID: ${user.id}'); // Debugging: Print current user ID

    // Fetch username from the 'profiles' table where id matches the current user ID
    final response = await Supabase.instance.client
        .from('profiles')
        .select('username')
        .eq('id', user.id)
        .single()
        .execute();

    if (response.error != null) {
      // Supabase returned an error
      setState(() {
        userName = 'Error: ${response.error!.message}';
      });
      print('Supabase Error: ${response.error!.message}');
    } else if (response.data == null) {
      // No data found for this user
      setState(() {
        userName = 'No profile found';
      });
      print('No profile found for user ID: ${user.id}');
    } else {
      // Successfully retrieved the username
      final data = response.data as Map<String, dynamic>;
      setState(() {
        userName = data['username'] ?? 'No Name Available';
      });
      print('Username fetched successfully: ${data['username']}');
    }
  } catch (e) {
    // Handle any unexpected exceptions
    setState(() {
      userName = 'Unexpected error occurred: $e';
    });
    print('Unexpected error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(appBarBackgroundImagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(color: Color(0xFFE5D9F2)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE5D9F2)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),

              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),

              // User's Name
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
                  // Log out the user
                  Supabase.instance.client.auth.signOut();
                  // Navigate to sign-in page
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
