class Ticket {
  final String ticketId;
  final String uniqId;
  final String firstName;
  final String lastName;
  final String whatsappNo;
  final String? altContactNumber; // Nullable
  final String productCategory;
  final String productModel;
  final String? purchaseDate; // Nullable
  final String? purchaseStore; // Nullable
  final String? areaLocation; // Nullable
  final String? attachment; // Nullable
  final String? comments; // Nullable
  final String ticketStatus;
  final String warrantyStatus;
  final String? charges;
  final String? technicianComments; // Nullable
  final String? createdDate; // Nullable
  final String? updatedDate; // Nullable
  final String? createdTime; // Nullable

  Ticket({
    required this.ticketId,
    required this.uniqId,
    required this.firstName,
    required this.lastName,
    required this.whatsappNo,
    this.altContactNumber, // Nullable
    required this.productCategory,
    required this.productModel,
    this.purchaseDate, // Nullable
    this.purchaseStore, // Nullable
    this.areaLocation, // Nullable
    this.attachment, // Nullable
    this.comments, // Nullable
    required this.ticketStatus,
    required this.warrantyStatus,
    this.charges,
    this.technicianComments, // Nullable
    this.createdDate, // Nullable
    this.updatedDate, // Nullable
    this.createdTime, // Nullable
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticket_id'],
      uniqId: json['uniq_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      whatsappNo: json['whatsapp_no'],
      altContactNumber: json['alt_contact_number'], // Nullable
      productCategory: json['product_category'],
      productModel: json['product_model'],
      purchaseDate: json['purchase_date'], // Nullable
      purchaseStore: json['purchase_store'], // Nullable
      areaLocation: json['area_location'], // Nullable
      attachment: json['attachment'], // Nullable
      comments: json['comments'], // Nullable
      ticketStatus: json['ticket_status'],
      warrantyStatus: json['warranty_status'],
      charges: json['charges'], 
      technicianComments: json['technician_comments'], // Nullable
      createdDate: json['created_date'], // Nullable
      updatedDate: json['updated_date'], // Nullable
      createdTime: json['created_time'], // Nullable
    );
  }
}