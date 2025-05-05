import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sonashi_app/pages/my_home_page.dart';

 import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sonashi_app/services/ticket_service.dart';

class LoginPage extends StatefulWidget {
  
 
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
   bool _isPasswordVisible = false;
  //final _auth = FirebaseAuth.instance;

bool isLoading = false;

  Future<void> login() async {
  setState(() {
    isLoading = true;
  });

  //final url = Uri.parse('http://192.168.29.92/sonashi_uae/Login_api/login');
  
  final url = Uri.parse(TicketService.baseUrl+'Login_api/login');
 
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    }),
  );

  setState(() {
    isLoading = false;
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      // Store user data in shared_preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', responseData['user_id']);
      prefs.setString('firstname', responseData['firstname']);
      prefs.setString('lastname', responseData['lastname']);
      prefs.setString('email', responseData['email']);
      prefs.setString('mobile', responseData['mobile']);
      prefs.setString('uniq_id', responseData['uniq_id']);

       // Add this line to remember login state
      prefs.setBool('isLoggedIn', true);  

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      _showErrorDialog(responseData['message']);
    }
  } else {
    _showErrorDialog('Server error. Try again later.');
  }
}
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                _buildInputField('Email', Icons.email, controller: _emailController),
                SizedBox(height: 20),
                _buildInputField('Password', Icons.lock, isPassword: true, 
                controller: _passwordController,
                isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade800,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, {bool isPassword = false, TextEditingController? controller,
   bool isPasswordVisible = false,VoidCallback? onToggleVisibility,}) {
    
    return TextField(
      controller: controller,
      
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        labelStyle: TextStyle(color: Colors.white70),
         suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}