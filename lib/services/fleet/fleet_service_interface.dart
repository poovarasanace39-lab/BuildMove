import '../../models/driver_profile_model.dart';
import '../../models/enums.dart';
import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';

/// Represents a pending driver/vehicle document verification item for Admin review.
class DriverVerificationItem {
  final String id;
  final String driverId;
  final String driverName;
  final String phone;
  final String vehicleName;
  final String plateNumber;
  final String documentType;
  final String documentUrl;
  final DocumentStatus status;
  final String submittedText;
  final DateTime submittedAt;

  const DriverVerificationItem({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.phone,
    required this.vehicleName,
    required this.plateNumber,
    required this.documentType,
    required this.documentUrl,
    this.status = DocumentStatus.pending,
    required this.submittedText,
    required this.submittedAt,
  });

  DriverVerificationItem copyWith({
    String? id,
    String? driverId,
    String? driverName,
    String? phone,
    String? vehicleName,
    String? plateNumber,
    String? documentType,
    String? documentUrl,
    DocumentStatus? status,
    String? submittedText,
    DateTime? submittedAt,
  }) {
    return DriverVerificationItem(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      phone: phone ?? this.phone,
      vehicleName: vehicleName ?? this.vehicleName,
      plateNumber: plateNumber ?? this.plateNumber,
      documentType: documentType ?? this.documentType,
      documentUrl: documentUrl ?? this.documentUrl,
      status: status ?? this.status,
      submittedText: submittedText ?? this.submittedText,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}

/// Abstract contract for managing fleet vehicles, driver profiles, and KYC verifications.
abstract class IFleetService {
  Future<List<VehicleModel>> getVehicles();
  Future<List<DriverProfileModel>> getDrivers();
  Future<List<UserModel>> getDriverUsers();

  Future<VehicleModel?> getVehicleById(String vehicleId);
  Future<VehicleModel?> getVehicleByDriverId(String driverId);
  Future<DriverProfileModel?> getDriverById(String driverId);
  Future<UserModel?> getDriverUser(String driverId);

  Future<void> addVehicle(VehicleModel vehicle);
  Future<void> updateVehicle(VehicleModel vehicle);
  Future<void> setVehicleAvailability(String vehicleId, bool isAvailable);

  Future<void> updateDriverApproval(
    String driverId, {
    required bool isApproved,
    String? rejectionReason,
  });

  Future<void> updateDriverOnlineStatus(String driverId, bool isOnline);

  Future<void> updateDocumentStatus({
    required String driverId,
    required String documentId,
    required DocumentStatus status,
  });

  Future<List<DriverVerificationItem>> getPendingVerifications();
}
