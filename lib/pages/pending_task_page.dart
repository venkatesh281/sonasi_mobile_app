import 'package:flutter/material.dart';
import 'package:sonashi_app/models/file_downloader.dart';
import 'package:sonashi_app/models/ticket.dart';
import 'package:sonashi_app/services/ticket_service.dart';
import 'package:intl/intl.dart';

class PendingTasksPage extends StatefulWidget {
  final String technicianId;

  const PendingTasksPage({super.key, required this.technicianId});

  @override
  State<PendingTasksPage> createState() => _PendingTasksPageState();
}

class _PendingTasksPageState extends State<PendingTasksPage> {
  final TicketService _ticketService = TicketService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  String? _expandedTicketId;
  // Controllers for the new fields
  final Map<String, TextEditingController> _chargesControllers = {};
  final Map<String, TextEditingController> _commentsControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchPendingTickets();
    // Set default values
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  Future<void> _fetchPendingTickets() async {
    try {
      final tickets = await _ticketService.getOngoingTickets(
        widget.technicianId,
      );
      setState(() {
        _tickets = tickets;
        _isLoading = false;

        // Initialize controllers for each ticket
        for (var ticket in tickets) {
          _chargesControllers[ticket.ticketId] = TextEditingController(
            text: '0',
          );
          _commentsControllers[ticket.ticketId] = TextEditingController(
            text: 'Updated by technician',
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pending tickets: $e')),
      );
    }
  }

  Future<void> _updateTicketStatus(
    String ticketId,
    String status,
    String charges,
    String comments,
  ) async {
    try {
      if (double.tryParse(charges) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid number for charges')),
        );
        return;
      }

      await _ticketService.updateTicketStatus(
        ticketId,
        status,
        comments,
        charges: charges,
      );

      _fetchPendingTickets();

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
        title: Text("Pending Tickets", style: TextStyle(color: Colors.white)),
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
                                ticket.ticketStatus == "2"
                                    ? "In Progress"
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
                              ),
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

    //String baseUrl = 'http://192.168.29.92/sonashi_uae';
    String baseUrl = TicketService.baseUrl;
    String fullUrl =
        '$baseUrl/assets/uploads/$attachmentUrl'; // Adjust the path as needed

    return ElevatedButton(
      onPressed: () async {
        final fileName = attachmentUrl.split('/').last;
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
    final chargesController = _chargesControllers[ticketId]!;
    final commentsController = _commentsControllers[ticketId]!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: chargesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Charges',
              border: OutlineInputBorder(),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'د.إ', // Dirham symbol
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: commentsController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Technician Comments',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.comment),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed:
                  () => _updateTicketStatus(
                    ticketId,
                    '3',
                    chargesController.text,
                    commentsController.text,
                  ),
              child: Text(
                'Mark as Closed',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //date format function
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
