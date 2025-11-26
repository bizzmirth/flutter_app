class Booking {
  String? id;
  String? invoiceId;
  String? bookingId;
  String? bookedOn;
  String? tourOn;
  String? status;
  String? paymentStatus;
  String? paymentStatusColor;
  String? transactionId;
  String? invoiceDate;

  Booking(
      {this.id,
      this.invoiceId,
      this.bookingId,
      this.bookedOn,
      this.tourOn,
      this.status,
      this.paymentStatus,
      this.paymentStatusColor,
      this.transactionId});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceId = json['invoice_id'];
    bookingId = json['booking_id'];
    bookedOn = json['booked_on'];
    tourOn = json['tour_on'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentStatusColor = json['payment_status_color'];
    transactionId = json['transaction_id'];
    invoiceDate = json['invoice_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['invoice_id'] = invoiceId;
    data['booking_id'] = bookingId;
    data['booked_on'] = bookedOn;
    data['tour_on'] = tourOn;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['payment_status_color'] = paymentStatusColor;
    data['transaction_id'] = transactionId;
    data['invoice_date'] = invoiceDate;
    return data;
  }
}
