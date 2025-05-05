import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF276dcb), 
        toolbarHeight: 100,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Theme Mode Toggle
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Dark Mode'),
            subtitle: Text('Enable or disable dark theme'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                // Add logic to change app theme
              },
            ),
          ),
          Divider(),

          // Notifications Toggle
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Enable or disable notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // Add logic to update notification settings
              },
            ),
          ),
          Divider(),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Select app language'),
            onTap: () {
              // Add logic to open language selection
            },
          ),
          Divider(),

          // Privacy Settings
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
            subtitle: Text('View privacy policy'),
            onTap: () {
              // Add logic to open privacy policy
            },
          ),
          Divider(),

          // About Section
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('App version 1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'My App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 My App',
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}