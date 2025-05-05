import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample list of notifications
  List<Map<String, String>> notifications = [
    // {"title": "New Ticket", "subtitle": "You have a new Ticket from Ganesh"},
    // {"title": "App Update", "subtitle": "A new version is available"},
    // {"title": "Reminder", "subtitle": "Your meeting starts in 30 minutes"},
    // {"title": "Offer Alert", "subtitle": "Get 20% off on your next purchase"},
    // {"title": "Security", "subtitle": "New login detected from a different device"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Color(0xFF276dcb),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.deepPurple),
              title: Text(notifications[index]["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notifications[index]["subtitle"]!),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    notifications.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
