import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sonashi_app/models/ticket.dart';

class TicketService {
  
  // this for local url for test
 //static final String baseUrl = 'http://192.168.29.92/sonashi_uae'; 
  
  // this for live url
 static final String baseUrl = 'https://sonashi.in/uae/'; 

  // Fetch assigned tickets
  Future<List<Ticket>> getAssignedTickets(String technicianId) async {
    final response = await http.get(Uri.parse('$baseUrl/Ticket_mobile/get_assigned_tickets?technician_id=$technicianId'));
    
    // print('Response Status Code: ${response.statusCode}'); // Debugging
    // print('Response Body: ${response.body}'); // Debugging
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
     
      
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load assigned tickets');
    }
  }


   // Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status, String comments,  {required String charges}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Ticket_mobile/update_status'), // Ensure this matches the backend endpoint
      body: {
        'action': 'edit-now', // Required by the backend
        'ticket_id': ticketId, // Required by the backend
        'ticket_status': status, // Required by the backend
        'charges': charges,
        'technician_comments': comments, // Required by the backend
       
        // 'technician_id': technicianId, // Optional, uncomment if needed
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update ticket status: ${response.body}');
    }
  }


  Future<List<Ticket>> getOngoingTickets(String technicianId) async {
  final response = await http.get(Uri.parse('$baseUrl/Ticket_mobile/get_ongoing_tickets?technician_id=$technicianId'));
 
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Ticket.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load ongoing tickets');
  }
}

Future<List<Ticket>> getClosedTickets(String technicianId) async {
  final response = await http.get(Uri.parse('$baseUrl/Ticket_mobile/get_closed_tickets?technician_id=$technicianId'));
  
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Ticket.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load closed tickets');
  }
}

}