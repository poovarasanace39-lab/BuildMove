class DriverProfileModel {
  final String userId;
  final bool isOnline;
  final String licenseNumber;
  final double rating;
  final int totalTrips;
  final double earningsToday;
  final String? activeVehicleId;
  final bool isApproved;
  final String? rejectionReason;

  const DriverProfileModel({
    required this.userId,
    this.isOnline = false,
    required this.licenseNumber,
    this.rating = 5.0,
    this.totalTrips = 0,
    this.earningsToday = 0.0,
    this.activeVehicleId,
    this.isApproved = false,
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_online': isOnline,
      'license_number': licenseNumber,
      'rating': rating,
      'total_trips': totalTrips,
      'earnings_today': earningsToday,
      'active_vehicle_id': activeVehicleId,
      'is_approved': isApproved,
      'rejection_reason': rejectionReason,
    };
  }

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      userId: json['user_id'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      licenseNumber: json['license_number'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalTrips: (json['total_trips'] as num?)?.toInt() ?? 0,
      earningsToday: (json['earnings_today'] as num?)?.toDouble() ?? 0.0,
      activeVehicleId: json['active_vehicle_id'] as String?,
      isApproved: json['is_approved'] as bool? ?? false,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  DriverProfileModel copyWith({
    String? userId,
    bool? isOnline,
    String? licenseNumber,
    double? rating,
    int? totalTrips,
    double? earningsToday,
    String? activeVehicleId,
    bool? isApproved,
    String? rejectionReason,
  }) {
    return DriverProfileModel(
      userId: userId ?? this.userId,
      isOnline: isOnline ?? this.isOnline,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      earningsToday: earningsToday ?? this.earningsToday,
      activeVehicleId: activeVehicleId ?? this.activeVehicleId,
      isApproved: isApproved ?? this.isApproved,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
