import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonashi_app/pages/assigned_task_page.dart';
import 'package:sonashi_app/pages/closed_task_page.dart';
import 'package:sonashi_app/pages/my_account_page.dart';
import 'package:sonashi_app/pages/my_home_page.dart';
import 'package:sonashi_app/pages/pending_task_page.dart';
import 'package:sonashi_app/pages/setting_page.dart';
import 'package:sonashi_app/pages/notification_page.dart';
import 'package:sonashi_app/pages/login_page.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
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
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 2.0,
      child: Column(
        children: [
          // Drawer header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E5EB5),
                  Color(0xFF276DCB),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.2),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Sonashi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Ticket Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          
          // Scrollable list of menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Dashboard section
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    "DASHBOARD",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9E9E9E),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.home_rounded,
                  title: "Home",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
                
                // Task Management section
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    "TICKET MANAGEMENT",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9E9E9E),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.assignment_outlined,
                  title: "Assigned Tickets",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final technicianId = prefs.getString('user_id') ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignedTasksPage(technicianId: technicianId),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.pending_actions_outlined,
                  title: "Ongoing Tickets",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final technicianId = prefs.getString('user_id') ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingTasksPage(technicianId: technicianId),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.task_alt_outlined,
                  title: "Completed Tickets",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final technicianId = prefs.getString('user_id') ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClosedTasksPage(technicianId: technicianId),
                      ),
                    );
                  },
                ),
                
                // Account section
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    "ACCOUNT",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9E9E9E),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.account_circle_outlined,
                  title: "My Profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAccountPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  title: "Sign Out",
                  isDestructive: true,
                  onTap: _signOut,
                ),
              ],
            ),
          ),
          
          // Footer with version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Sonashi v1.0.0",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build menu items with consistent styling
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red.shade700 : Color(0xFF276DCB),
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red.shade700 : Colors.grey.shade800,
        ),
      ),
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade100,
    );
  }
}