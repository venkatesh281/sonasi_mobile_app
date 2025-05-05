import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonashi_app/pages/assigned_task_page.dart';
import 'package:sonashi_app/pages/closed_task_page.dart';
import 'package:sonashi_app/pages/pending_task_page.dart';
import 'package:sonashi_app/services/ticket_service.dart';

class Dashboard extends StatefulWidget {
  final String technicianId;

  const Dashboard({super.key, required this.technicianId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TicketService _ticketService = TicketService();

  late Future<Map<String, int>> _ticketCountsFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    try {
      _ticketCountsFuture = _fetchTicketCounts(); // Initialize the Future
    } catch (e) {
      print('Error initializing data: $e');
      // Fallback: Initialize with default values
      _ticketCountsFuture = Future.value({
        'assigned': 0,
        'ongoing': 0,
        'closed': 0,
      });
    }
  }

  Future<Map<String, int>> _fetchTicketCounts() async {
    try {
      final assigned = await _ticketService.getAssignedTickets(
        widget.technicianId,
      );
      final ongoing = await _ticketService.getOngoingTickets(
        widget.technicianId,
      );
      final closed = await _ticketService.getClosedTickets(widget.technicianId);

      return {
        'assigned': assigned.length,
        'ongoing': ongoing.length,
        'closed': closed.length,
      };
    } catch (e) {
      print('Error fetching ticket data: $e');
      throw e; // Rethrow the error to handle it in FutureBuilder
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _ticketCountsFuture = _fetchTicketCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sonashi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dashboard Stats (Using FutureBuilder)
              FutureBuilder<Map<String, int>>(
                future: _ticketCountsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Failed to load data. Please try again.",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Total Assigned',
                          data['assigned'].toString(),
                          Icons.work,
                          Colors.blue,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final technicianId =
                                prefs.getString('user_id') ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AssignedTasksPage(
                                      technicianId: technicianId,
                                    ),
                              ),
                            );
                          },
                        ),
                        _buildStatCard(
                          'On Going',
                          data['ongoing'].toString(),
                          Icons.pending,
                          Colors.green,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final technicianId =
                                prefs.getString('user_id') ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PendingTasksPage(
                                      technicianId: technicianId,
                                    ),
                              ),
                            );
                          },
                        ),
                        _buildStatCard(
                          'Closed',
                          data['closed'].toString(),
                          Icons.done_all_rounded,
                          Colors.purple,
                           onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final technicianId =
                                prefs.getString('user_id') ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ClosedTasksPage(
                                      technicianId: technicianId,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),

              const SizedBox(height: 20),

              // Recent Activity Section
              // const Text(
              //   'Recent Task',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
             // const SizedBox(height: 10),
             // _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  // Stat Card Widget
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    void Function()? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent Activity Widget
  // Widget _buildRecentActivity() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           _buildActivityItem('New user registered', '2 hours ago'),
  //           const Divider(),
  //           _buildActivityItem('Project "Sonashi" updated', '5 hours ago'),
  //           const Divider(),
  //           _buildActivityItem(
  //             'Task "Dashboard Design" completed',
  //             '1 day ago',
  //           ),
  //           const Divider(),
  //           _buildActivityItem('Revenue report generated', '2 days ago'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Activity Item Widget
  // Widget _buildActivityItem(String title, String time) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.zero,
  //     leading: const Icon(Icons.notifications, color: Colors.indigo),
  //     title: Text(
  //       title,
  //       style: const TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.black,
  //       ),
  //     ),
  //     subtitle: Text(
  //       time,
  //       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //     ),
  //   );
  // }
}
