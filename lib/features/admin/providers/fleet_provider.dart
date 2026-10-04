import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/driver_profile_model.dart';
import '../../../models/user_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../services/fleet/fleet_service_interface.dart';
import '../../../services/fleet/mock_fleet_service.dart';

/// Provider for the singleton/mock fleet service instance.
final fleetServiceProvider = Provider<IFleetService>((ref) {
  return MockFleetService();
});

/// Immutable state containing the reactive fleet, driver profiles, and KYC queue.
class FleetState {
  final List<VehicleModel> vehicles;
  final List<DriverProfileModel> drivers;
  final List<UserModel> driverUsers;
  final List<DriverVerificationItem> verificationQueue;
  final bool isLoading;
  final String? errorMessage;

  const FleetState({
    this.vehicles = const [],
    this.drivers = const [],
    this.driverUsers = const [],
    this.verificationQueue = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FleetState copyWith({
    List<VehicleModel>? vehicles,
    List<DriverProfileModel>? drivers,
    List<UserModel>? driverUsers,
    List<DriverVerificationItem>? verificationQueue,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FleetState(
      vehicles: vehicles ?? this.vehicles,
      drivers: drivers ?? this.drivers,
      driverUsers: driverUsers ?? this.driverUsers,
      verificationQueue: verificationQueue ?? this.verificationQueue,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Helper to lookup driver user by ID
  UserModel? getDriverUser(String driverId) {
    try {
      return driverUsers.firstWhere((u) => u.id == driverId);
    } catch (_) {
      return null;
    }
  }

  /// Helper to lookup driver profile by ID
  DriverProfileModel? getDriverProfile(String driverId) {
    try {
      return drivers.firstWhere((d) => d.userId == driverId);
    } catch (_) {
      return null;
    }
  }
}

/// Riverpod notifier managing reactive fleet operations across Admin & Driver modules.
class FleetNotifier extends Notifier<FleetState> {
  @override
  FleetState build() {
    state = const FleetState(isLoading: true);
    // Load initial data asynchronously
    Future.microtask(() => loadFleetData());
    return const FleetState(isLoading: true);
  }

  Future<void> loadFleetData() async {
    final service = ref.read(fleetServiceProvider);
    try {
      final vehicles = await service.getVehicles();
      final drivers = await service.getDrivers();
      final driverUsers = await service.getDriverUsers();
      final queue = await service.getPendingVerifications();

      state = state.copyWith(
        vehicles: vehicles,
        drivers: drivers,
        driverUsers: driverUsers,
        verificationQueue: queue,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load fleet data: $e',
      );
    }
  }

  /// Approves a pending document and activates the driver.
  Future<String?> approveVerification(String documentId) async {
    final service = ref.read(fleetServiceProvider);
    final item = state.verificationQueue.firstWhere(
      (v) => v.id == documentId,
      orElse: () => throw StateError('Verification item $documentId not found in queue'),
    );

    await service.updateDriverApproval(item.driverId, isApproved: true);
    await loadFleetData();
    return item.driverName;
  }

  /// Rejects a pending document with an optional reason.
  Future<String?> rejectVerification(String documentId, {String? reason}) async {
    final service = ref.read(fleetServiceProvider);
    final item = state.verificationQueue.firstWhere(
      (v) => v.id == documentId,
      orElse: () => throw StateError('Verification item $documentId not found in queue'),
    );

    await service.updateDriverApproval(
      item.driverId,
      isApproved: false,
      rejectionReason: reason ?? 'Document rejected by Admin KYC review',
    );
    await loadFleetData();
    return item.driverName;
  }

  /// Toggles vehicle operational availability.
  Future<void> toggleVehicleAvailability(String vehicleId) async {
    final service = ref.read(fleetServiceProvider);
    final vehicle = state.vehicles.firstWhere((v) => v.id == vehicleId);
    await service.setVehicleAvailability(vehicleId, !vehicle.isAvailable);
    await loadFleetData();
  }

  /// Updates driver online/offline presence.
  Future<void> setDriverOnlineStatus(String driverId, bool isOnline) async {
    final service = ref.read(fleetServiceProvider);
    await service.updateDriverOnlineStatus(driverId, isOnline);
    await loadFleetData();
  }

  /// Registers or updates a vehicle.
  Future<void> registerVehicle(VehicleModel vehicle) async {
    final service = ref.read(fleetServiceProvider);
    await service.addVehicle(vehicle);
    await loadFleetData();
  }
}

final fleetNotifierProvider = NotifierProvider<FleetNotifier, FleetState>(() {
  return FleetNotifier();
});
