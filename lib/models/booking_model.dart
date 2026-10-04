import 'enums.dart';
import 'location_model.dart';

class BookingModel {
  final String id;
  final String customerId;
  final String? customerName;
  final String? customerPhone;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final VehicleType vehicleType;
  final ConstructionMaterial materialType;
  final double quantityTons;
  final LocationModel pickupLocation;
  final LocationModel dropLocation;
  final BookingStatus status;
  final double estimatedFare;
  final double? actualFare;
  final double distanceKm;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final String? otpForPickup;

  const BookingModel({
    required this.id,
    required this.customerId,
    this.customerName,
    this.customerPhone,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.vehicleType,
    required this.materialType,
    required this.quantityTons,
    required this.pickupLocation,
    required this.dropLocation,
    required this.status,
    required this.estimatedFare,
    this.actualFare,
    required this.distanceKm,
    required this.scheduledAt,
    required this.createdAt,
    this.otpForPickup,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'vehicle_type': vehicleType.name,
      'material_type': materialType.name,
      'quantity_tons': quantityTons,
      'pickup_location': pickupLocation.toJson(),
      'drop_location': dropLocation.toJson(),
      'status': status.name,
      'estimated_fare': estimatedFare,
      'actual_fare': actualFare,
      'distance_km': distanceKm,
      'scheduled_at': scheduledAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'otp_for_pickup': otpForPickup,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      vehicleType: VehicleType.fromString(json['vehicle_type'] as String?),
      materialType: ConstructionMaterial.fromString(json['material_type'] as String?),
      quantityTons: (json['quantity_tons'] as num?)?.toDouble() ?? 1.0,
      pickupLocation: LocationModel.fromJson(json['pickup_location'] as Map<String, dynamic>),
      dropLocation: LocationModel.fromJson(json['drop_location'] as Map<String, dynamic>),
      status: BookingStatus.fromString(json['status'] as String?),
      estimatedFare: (json['estimated_fare'] as num?)?.toDouble() ?? 0.0,
      actualFare: (json['actual_fare'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      otpForPickup: json['otp_for_pickup'] as String?,
    );
  }

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? driverId,
    String? driverName,
    String? driverPhone,
    VehicleType? vehicleType,
    ConstructionMaterial? materialType,
    double? quantityTons,
    LocationModel? pickupLocation,
    LocationModel? dropLocation,
    BookingStatus? status,
    double? estimatedFare,
    double? actualFare,
    double? distanceKm,
    DateTime? scheduledAt,
    DateTime? createdAt,
    String? otpForPickup,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleType: vehicleType ?? this.vehicleType,
      materialType: materialType ?? this.materialType,
      quantityTons: quantityTons ?? this.quantityTons,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      status: status ?? this.status,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      actualFare: actualFare ?? this.actualFare,
      distanceKm: distanceKm ?? this.distanceKm,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      otpForPickup: otpForPickup ?? this.otpForPickup,
    );
  }
}
