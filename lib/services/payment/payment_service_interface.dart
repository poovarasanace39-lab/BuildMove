import '../../core/network/api_result.dart';
import '../../models/payment_model.dart';

abstract class IPaymentService {
  /// Initialize payment gateway with client key ID (never backend secret key)
  bool get isConfigured;

  /// Initiate checkout for a booking order
  Future<ApiResult<PaymentModel>> initiatePayment({
    required String bookingId,
    required double amount,
    required String customerPhone,
    required String customerName,
  });

  /// Verify server signature after payment completion
  Future<ApiResult<bool>> verifyPaymentSignature({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });
}
