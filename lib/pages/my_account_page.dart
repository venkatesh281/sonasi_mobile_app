import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonashi_app/pages/login_page.dart';

class MyAccountPage extends StatefulWidget {
  
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String? _firstname;
  String? _lastname;
  String? _email;
  String? _mobile;
  String? _uniqId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstname = prefs.getString('firstname');
      _lastname = prefs.getString('lastname');
      _email = prefs.getString('email');
      _mobile = prefs.getString('mobile');
      _uniqId = prefs.getString('uniq_id');
    });
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored user data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF276dcb),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle Avatar with First Letter of First Name
              Row(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF276dcb),
                      child: Text(
                        _firstname?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Display Full Name (First Name + Last Name)
                  Center(
                    child: Text(
                      '${_firstname ?? "No Firstname"} ${_lastname ?? "No Lastname"}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Horizontal Divider
              Divider(thickness: 1, color: Colors.grey[400]),
              const SizedBox(height: 20),

              // User Details in List Format
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text("First Name"),
                subtitle: Text(_firstname ?? "No Firstname"),
              ),
              ListTile(
                leading: Icon(Icons.person_outlined, color: Colors.blue),
                title: Text("Last Name"),
                subtitle: Text(_lastname ?? "No Lastname"),
              ),
              ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.blue),
                title: Text("Email"),
                subtitle: Text(_email ?? "No Email"),
              ),
              ListTile(
                leading: Icon(Icons.phone_android_outlined, color: Colors.blue),
                title: Text("Mobile"),
                subtitle: Text(_mobile ?? "No Mobile"),
              ),
              ListTile(
                leading: Icon(Icons.fingerprint_outlined, color: Colors.blue),
                title: Text("Unique ID"),
                subtitle: Text(_uniqId ?? "No Unique ID"),
              ),
              const SizedBox(height: 20),

              // Sign Out Button
              Center(
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
