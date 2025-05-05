
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonashi_app/pages/login_page.dart';
import 'pages/my_home_page.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? technicianId = prefs.getString('user_id'); // Retrieve technician ID
  print('Technician ID: $technicianId'); 
  runApp(MyApp(isLoggedIn: isLoggedIn, technicianId: technicianId));
}

class MyApp extends StatelessWidget {
 
  final bool isLoggedIn;
  final String? technicianId;
  const MyApp({super.key, required this.isLoggedIn, required this.technicianId});
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF276dcb)),
       // fontFamily: 'Inter', // Apply Inter font globally,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Set all AppBar icons to white
          ),
        ),
      ),
       home: isLoggedIn ? MyHomePage() : LoginPage(),
    );
  }
}