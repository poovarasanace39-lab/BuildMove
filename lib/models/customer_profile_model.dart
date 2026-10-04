import 'location_model.dart';

class CustomerProfileModel {
  final String userId;
  final String? companyName;
  final String? gstNumber;
  final LocationModel? defaultSiteAddress;
  final int totalOrdersPlaced;

  const CustomerProfileModel({
    required this.userId,
    this.companyName,
    this.gstNumber,
    this.defaultSiteAddress,
    this.totalOrdersPlaced = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'company_name': companyName,
      'gst_number': gstNumber,
      'default_site_address': defaultSiteAddress?.toJson(),
      'total_orders_placed': totalOrdersPlaced,
    };
  }

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      userId: json['user_id'] as String,
      companyName: json['company_name'] as String?,
      gstNumber: json['gst_number'] as String?,
      defaultSiteAddress: json['default_site_address'] != null
          ? LocationModel.fromJson(json['default_site_address'] as Map<String, dynamic>)
          : null,
      totalOrdersPlaced: (json['total_orders_placed'] as num?)?.toInt() ?? 0,
    );
  }
}
