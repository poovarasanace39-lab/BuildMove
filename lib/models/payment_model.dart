import 'enums.dart';

class PaymentModel {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentStatus status;
  final String method; // razorpay, cash_on_delivery, site_credit
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.status,
    this.method = 'razorpay',
    this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'amount': amount,
      'status': status.name,
      'method': method,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: PaymentStatus.fromString(json['status'] as String?),
      method: json['method'] as String? ?? 'razorpay',
      razorpayOrderId: json['razorpay_order_id'] as String?,
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
