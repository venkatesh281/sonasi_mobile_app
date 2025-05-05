import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonashi_app/models/file_downloader.dart';
import 'package:sonashi_app/models/ticket.dart';
import 'package:sonashi_app/services/ticket_service.dart';

class AssignedTasksPage extends StatefulWidget {
  final String technicianId;

  const AssignedTasksPage({super.key, required this.technicianId});

  @override
  State<AssignedTasksPage> createState() => _AssignedTasksPageState();
}

class _AssignedTasksPageState extends State<AssignedTasksPage> {
  final TicketService _ticketService = TicketService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  String? _expandedTicketId;

  @override
  void initState() {
    super.initState();
    _fetchAssignedTickets();
  }

  Future<void> _fetchAssignedTickets() async {
    try {
      final tickets = await _ticketService.getAssignedTickets(
        widget.technicianId,
      );

      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch tickets: $e')));
    }
  }

  Future<void> _updateTicketStatus(String ticketId, String status) async {
    try {
      await _ticketService.updateTicketStatus(
        ticketId,
        status,
        'Updated by technician',
        charges: '0',
      );
      _fetchAssignedTickets(); // Refresh the list after updating the status
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ticket status updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update ticket status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assigned Tickets", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF276dcb),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: ExpansionTile(
                      key: Key(
                        ticket.ticketId,
                      ), // Helps Flutter differentiate tiles
                      initiallyExpanded:
                          _expandedTicketId ==
                          ticket.ticketId, // Remember expanded state
                      onExpansionChanged: (isExpanded) {
                        setState(() {
                          _expandedTicketId =
                              isExpanded ? ticket.ticketId : null;
                        });
                      },
                      leading: Icon(
                        Icons.assignment,
                        color: Colors.deepPurpleAccent,
                      ),
                      title: Text(
                        'Ticket ID: ${ticket.ticketId}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Customer: ${ticket.firstName} ${ticket.lastName}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader('Customer Details'),
                              _buildDetailRow('First Name', ticket.firstName),
                              _buildDetailRow('Last Name', ticket.lastName),
                              _buildDetailRow('WhatsApp No', ticket.whatsappNo),
                              _buildDetailRow(
                                'Alt Contact',
                                ticket.altContactNumber,
                              ),
                              _buildDetailRow('Location', ticket.areaLocation),
                              _buildDetailRow(
                                'Created Date',
                               _formatDate(ticket.createdDate),
                              ),
                              _buildDetailRow(
                                'Created Time',
                                ticket.createdTime,
                              ),
                              Divider(color: Colors.grey[300], thickness: 1.0),
                              _buildSectionHeader('Product Details'),
                              _buildDetailRow(
                                'Category',
                                ticket.productCategory,
                              ),
                              _buildDetailRow('Model', ticket.productModel),
                              _buildDetailRow(
                                'Purchase Store',
                                ticket.purchaseStore,
                              ),
                              _buildDetailRow(
                                'Purchase Date',
                               _formatDate(ticket.purchaseDate),
                              ),
                              _buildDetailRow(
                                'Customer Comment',
                                ticket.comments,
                              ),
                              Divider(color: Colors.grey[300], thickness: 1.0),
                              _buildSectionHeader('Ticket Details'),
                              _buildDetailRow('Ticket ID', ticket.ticketId),
                              _buildDetailRow(
                                'Status',
                                ticket.ticketStatus == "1"
                                    ? "Assigned"
                                    : ticket.ticketStatus,
                              ),

                              _buildDetailRow(
                                'Warranty Status',
                                ticket.warrantyStatus,
                              ),
                              _buildDetailRow(
                                'Technician Comments',
                                ticket.technicianComments,
                              ),
                              _buildDetailRow(
                                'Created Date',
                               _formatDate(ticket.createdDate),  
                              ),
                              _buildDetailRow(
                                'Updated Date',
                                 _formatDate(ticket.updatedDate),
                              ),
                              SizedBox(height: 16),
                              _buildAttachmentButton(
                                context,
                                ticket.attachment,
                              ), // Add the attachment button
                              SizedBox(height: 16),
                              _buildActionButtons(ticket.ticketId),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Fixed width for labels
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 8), // Spacing between label and value
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(BuildContext context, String? attachmentUrl) {
    if (attachmentUrl == null || attachmentUrl.isEmpty) {
      return SizedBox.shrink(); // Hide the button if there's no attachment
    }

    String baseUrl =
        TicketService.baseUrl; // Replace with your server's base URL
    //String fullUrl = baseUrl + attachmentUrl;
    // Construct the full URL using the baseUrl from TicketService

    //String baseUrl = 'https://sonashi.in/uae/';
    String fullUrl =
        '$baseUrl/assets/uploads/$attachmentUrl'; // Adjust the path as needed

    return ElevatedButton(
      onPressed: () async {
        // Extract the file name from the URL
        final fileName = attachmentUrl.split('/').last;

        // Download and open the file
        await FileDownloader.downloadAndOpenFile(context, fullUrl, fileName);
      },
      child: Text('View Attachment', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildActionButtons(String ticketId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _updateTicketStatus(ticketId, '2'), // Pending
          child: Text(
            'Mark as In Progress',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
  String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return 'N/A';

  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd-MM-yyyy').format(date);
  } catch (e) {
    return dateStr; // fallback if parsing fails
  }
}
}
