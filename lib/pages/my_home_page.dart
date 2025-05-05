import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonashi_app/components/my_drawer.dart';
import 'package:sonashi_app/pages/dashboard_page.dart';
import 'package:sonashi_app/pages/notification_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String technicianId = '';

  @override
  void initState() {
    super.initState();
    _loadTechnicianId();
  }

  // Fetch technician ID from SharedPreferences
  Future<void> _loadTechnicianId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    technicianId = prefs.getString('user_id') ?? ''; // Use the correct key
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sonashi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF276dcb),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const Mydrawer(),
      
      // Display Dashboard only when technicianId is loaded
      body: technicianId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Dashboard(technicianId: technicianId),
    );
  }
}
