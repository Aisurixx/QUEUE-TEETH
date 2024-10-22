import 'package:flutter/material.dart';
import 'login.dart'; // Import the new file
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initializeDateFormatting('en_PH', null);
  await Supabase.initialize(
    url: 'https://ktujgddbdoofejgxphmu.supabase.co',  // Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0dWpnZGRiZG9vZmVqZ3hwaG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc4Nzc1OTksImV4cCI6MjA0MzQ1MzU5OX0.lB7xLbeGm6HjcaEItrpmH_P9Rqw5Q_nUMdetCzYMMNw',         // Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
