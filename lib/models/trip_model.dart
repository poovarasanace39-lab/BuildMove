import 'location_model.dart';

class TripModel {
  final String id;
  final String bookingId;
  final String driverId;
  final DateTime startTime;
  final DateTime? endTime;
  final double? startOdometer;
  final double? endOdometer;
  final LocationModel? currentDriverLocation;

  const TripModel({
    required this.id,
    required this.bookingId,
    required this.driverId,
    required this.startTime,
    this.endTime,
    this.startOdometer,
    this.endOdometer,
    this.currentDriverLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'driver_id': driverId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'start_odometer': startOdometer,
      'end_odometer': endOdometer,
      'current_driver_location': currentDriverLocation?.toJson(),
    };
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      driverId: json['driver_id'] as String,
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'].toString()) ?? DateTime.now()
          : DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time'].toString()) : null,
      startOdometer: (json['start_odometer'] as num?)?.toDouble(),
      endOdometer: (json['end_odometer'] as num?)?.toDouble(),
      currentDriverLocation: json['current_driver_location'] != null
          ? LocationModel.fromJson(json['current_driver_location'] as Map<String, dynamic>)
          : null,
    );
  }
}
