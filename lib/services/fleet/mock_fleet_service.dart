import '../../models/driver_profile_model.dart';
import '../../models/enums.dart';
import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';
import '../demo/demo_data_service.dart';
import 'fleet_service_interface.dart';

/// In-memory mock implementation of [IFleetService].
/// Maintains typed collections of drivers, vehicles, and KYC documents
/// with reactive state updates for the Admin and Driver modules.
class MockFleetService implements IFleetService {
  static final List<VehicleModel> _vehicles = [];
  static final List<DriverProfileModel> _drivers = [];
  static final List<UserModel> _driverUsers = [];
  static bool _seeded = false;

  MockFleetService() {
    if (!_seeded) {
      _initializeSeedData();
      _seeded = true;
    }
  }

  /// Resets mock database for test isolation.
  static void resetSeedData() {
    _vehicles.clear();
    _drivers.clear();
    _driverUsers.clear();
    _seeded = false;
  }

  /// Toggles empty or populated fleet state for testing
  static void setFleetEmpty(bool empty) {
    _vehicles.clear();
    _drivers.clear();
    _driverUsers.clear();
    if (!empty) {
      final s = MockFleetService();
      s._initializeSeedData();
    }
    _seeded = true;
  }

  void _initializeSeedData() {
    if (DemoDataService.instance.isFleetEmpty) {
      return;
    }
    _driverUsers.addAll([
      UserModel(
        id: 'usr_drv_002',
        phone: '+91 9840123456',
        name: 'Murugan K.',
        email: 'murugan.trans@gmail.com',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      UserModel(
        id: 'usr_drv_004',
        phone: '+91 9840998877',
        name: 'Selvam P.',
        email: 'selvam.logistics@gmail.com',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      UserModel(
        id: 'usr_drv_006',
        phone: '+91 9791048291',
        name: 'Dinesh Kumar',
        email: 'dinesh.cargo@gmail.com',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      UserModel(
        id: 'usr_drv_007',
        phone: '+91 9444019283',
        name: 'Arunachalam M.',
        email: 'arunachalam.heavy@gmail.com',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      UserModel(
        id: 'usr_drv_008',
        phone: '+91 9884022331',
        name: 'Gopalakrishnan',
        email: 'gopal.tractor@gmail.com',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      // Drivers with pending KYC verification queue
      UserModel(
        id: 'usr_drv_009',
        phone: '+91 9841029384',
        name: 'K. Anbalagan',
        email: 'anbalagan.tata@gmail.com',
        role: UserRole.driver,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      UserModel(
        id: 'usr_drv_010',
        phone: '+91 9791048291',
        name: 'S. Chandran',
        email: 'chandran.pickup@gmail.com',
        role: UserRole.driver,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UserModel(
        id: 'usr_drv_011',
        phone: '+91 9444019283',
        name: 'V. Rajendran',
        email: 'rajendran.tipper@gmail.com',
        role: UserRole.driver,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ]);

    _drivers.addAll([
      const DriverProfileModel(
        userId: 'usr_drv_002',
        isOnline: true,
        licenseNumber: 'DL-TN-02-2018-0091',
        rating: 4.9,
        totalTrips: 148,
        earningsToday: 2450.0,
        activeVehicleId: 'veh_001',
        isApproved: true,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_004',
        isOnline: true,
        licenseNumber: 'DL-TN-14-2019-4412',
        rating: 4.8,
        totalTrips: 92,
        earningsToday: 1800.0,
        activeVehicleId: 'veh_002',
        isApproved: true,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_006',
        isOnline: true,
        licenseNumber: 'DL-TN-09-2021-3321',
        rating: 4.7,
        totalTrips: 64,
        earningsToday: 1250.0,
        activeVehicleId: 'veh_003',
        isApproved: true,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_007',
        isOnline: true,
        licenseNumber: 'DL-TN-04-2015-8812',
        rating: 4.95,
        totalTrips: 210,
        earningsToday: 4800.0,
        activeVehicleId: 'veh_004',
        isApproved: true,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_008',
        isOnline: false,
        licenseNumber: 'DL-TN-22-2020-5511',
        rating: 4.6,
        totalTrips: 38,
        earningsToday: 0.0,
        activeVehicleId: 'veh_005',
        isApproved: true,
      ),
      // Pending KYC Driver Profiles
      const DriverProfileModel(
        userId: 'usr_drv_009',
        isOnline: false,
        licenseNumber: 'DL-TN-05-2022-7719',
        rating: 5.0,
        totalTrips: 0,
        earningsToday: 0.0,
        activeVehicleId: 'veh_006',
        isApproved: false,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_010',
        isOnline: false,
        licenseNumber: 'DL-TN-10-2020-1123',
        rating: 5.0,
        totalTrips: 0,
        earningsToday: 0.0,
        activeVehicleId: 'veh_007',
        isApproved: false,
      ),
      const DriverProfileModel(
        userId: 'usr_drv_011',
        isOnline: false,
        licenseNumber: 'DL-TN-22-2017-9092',
        rating: 5.0,
        totalTrips: 0,
        earningsToday: 0.0,
        activeVehicleId: 'veh_008',
        isApproved: false,
      ),
    ]);

    _vehicles.addAll([
      VehicleModel(
        id: 'veh_001',
        driverId: 'usr_drv_002',
        type: VehicleType.tipper6Wheeler,
        modelName: '6-Wheeler Tipper (10T)',
        plateNumber: 'TN-02-AL-8921',
        capacityTons: 10.0,
        isAvailable: true,
        documents: [
          VehicleDocumentModel(
            id: 'DOC-8001',
            documentType: 'Vehicle RC Book & Commercial Permit',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_8921.pdf',
            status: DocumentStatus.approved,
            verifiedAt: DateTime.now().subtract(const Duration(days: 60)),
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_002',
        driverId: 'usr_drv_004',
        type: VehicleType.pickup8ft,
        modelName: 'Mahindra Bolero (1.5T)',
        plateNumber: 'TN-14-BD-2311',
        capacityTons: 1.5,
        isAvailable: true,
        documents: [
          VehicleDocumentModel(
            id: 'DOC-8002',
            documentType: 'Vehicle RC Book',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_2311.pdf',
            status: DocumentStatus.approved,
            verifiedAt: DateTime.now().subtract(const Duration(days: 45)),
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_003',
        driverId: 'usr_drv_006',
        type: VehicleType.eeco,
        modelName: 'Maruti Eeco Cargo (0.5T)',
        plateNumber: 'TN-09-PQ-9081',
        capacityTons: 0.5,
        isAvailable: true,
        documents: [
          VehicleDocumentModel(
            id: 'DOC-8003',
            documentType: 'Vehicle RC Book',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_9081.pdf',
            status: DocumentStatus.approved,
            verifiedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_004',
        driverId: 'usr_drv_007',
        type: VehicleType.tipper10Wheeler,
        modelName: '10-Wheeler Heavy Tipper (20T)',
        plateNumber: 'TN-04-XY-6623',
        capacityTons: 20.0,
        isAvailable: true,
        documents: [
          VehicleDocumentModel(
            id: 'DOC-8004',
            documentType: 'Heavy Vehicle Commercial Permit',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_6623.pdf',
            status: DocumentStatus.approved,
            verifiedAt: DateTime.now().subtract(const Duration(days: 90)),
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_005',
        driverId: 'usr_drv_008',
        type: VehicleType.tractorTrolley,
        modelName: 'Tractor Trolley (5T)',
        plateNumber: 'TN-22-KJ-4512',
        capacityTons: 5.0,
        isAvailable: false,
        documents: [
          VehicleDocumentModel(
            id: 'DOC-8005',
            documentType: 'Agricultural & Site Transport RC',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_4512.pdf',
            status: DocumentStatus.approved,
            verifiedAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ],
      ),
      // Pending KYC Vehicles & Documents
      VehicleModel(
        id: 'veh_006',
        driverId: 'usr_drv_009',
        type: VehicleType.tataAce,
        modelName: 'Tata Ace Gold (0.8T)',
        plateNumber: 'TN-05-BK-4921',
        capacityTons: 0.8,
        isAvailable: false,
        documents: [
          const VehicleDocumentModel(
            id: 'DOC-9021',
            documentType: 'Vehicle RC Book & Commercial Permit',
            documentUrl: 'https://cdn.buildmove.in/docs/rc_4921.pdf',
            status: DocumentStatus.pending,
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_007',
        driverId: 'usr_drv_010',
        type: VehicleType.pickup8ft,
        modelName: 'Mahindra Bolero Pickup (1.5T)',
        plateNumber: 'TN-10-AR-7312',
        capacityTons: 1.5,
        isAvailable: false,
        documents: [
          const VehicleDocumentModel(
            id: 'DOC-9022',
            documentType: 'Heavy Transport Driving License (Commercial)',
            documentUrl: 'https://cdn.buildmove.in/docs/dl_7312.pdf',
            status: DocumentStatus.pending,
          ),
        ],
      ),
      VehicleModel(
        id: 'veh_008',
        driverId: 'usr_drv_011',
        type: VehicleType.tipper6Wheeler,
        modelName: 'Ashok Leyland 6-Wheeler Tipper (10T)',
        plateNumber: 'TN-22-CZ-1092',
        capacityTons: 10.0,
        isAvailable: false,
        documents: [
          const VehicleDocumentModel(
            id: 'DOC-9023',
            documentType: 'Goods Carrier Fitness & Pollution Certificate',
            documentUrl: 'https://cdn.buildmove.in/docs/fit_1092.pdf',
            status: DocumentStatus.pending,
          ),
        ],
      ),
    ]);
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_vehicles);
  }

  @override
  Future<List<DriverProfileModel>> getDrivers() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_drivers);
  }

  @override
  Future<List<UserModel>> getDriverUsers() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_driverUsers);
  }

  @override
  Future<VehicleModel?> getVehicleById(String vehicleId) async {
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    return index != -1 ? _vehicles[index] : null;
  }

  @override
  Future<VehicleModel?> getVehicleByDriverId(String driverId) async {
    final index = _vehicles.indexWhere((v) => v.driverId == driverId);
    return index != -1 ? _vehicles[index] : null;
  }

  @override
  Future<DriverProfileModel?> getDriverById(String driverId) async {
    final index = _drivers.indexWhere((d) => d.userId == driverId);
    return index != -1 ? _drivers[index] : null;
  }

  @override
  Future<UserModel?> getDriverUser(String driverId) async {
    final index = _driverUsers.indexWhere((u) => u.id == driverId);
    return index != -1 ? _driverUsers[index] : null;
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id || v.plateNumber == vehicle.plateNumber);
    if (index != -1) {
      _vehicles[index] = vehicle;
    } else {
      _vehicles.add(vehicle);
    }
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
    }
  }

  @override
  Future<void> setVehicleAvailability(String vehicleId, bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final veh = _vehicles[index];
      // A vehicle with pending or rejected documents CANNOT be set available online!
      final hasPendingOrRejected = veh.documents.any((d) => d.status != DocumentStatus.approved);
      final actualAvailable = hasPendingOrRejected ? false : isAvailable;
      _vehicles[index] = veh.copyWith(isAvailable: actualAvailable);
    }
  }

  @override
  Future<void> updateDriverApproval(
    String driverId, {
    required bool isApproved,
    String? rejectionReason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Update driver profile
    final dIndex = _drivers.indexWhere((d) => d.userId == driverId);
    if (dIndex != -1) {
      _drivers[dIndex] = _drivers[dIndex].copyWith(
        isApproved: isApproved,
        isOnline: isApproved ? true : false,
        rejectionReason: rejectionReason,
      );
    }

    // Update driver user verification
    final uIndex = _driverUsers.indexWhere((u) => u.id == driverId);
    if (uIndex != -1) {
      _driverUsers[uIndex] = _driverUsers[uIndex].copyWith(isVerified: isApproved);
    }

    // Update associated vehicle documents
    final vIndex = _vehicles.indexWhere((v) => v.driverId == driverId);
    if (vIndex != -1) {
      final updatedDocs = _vehicles[vIndex].documents.map((doc) {
        if (doc.status == DocumentStatus.pending) {
          return doc.copyWith(
            status: isApproved ? DocumentStatus.approved : DocumentStatus.rejected,
            verifiedAt: isApproved ? DateTime.now() : null,
          );
        }
        return doc;
      }).toList();

      _vehicles[vIndex] = _vehicles[vIndex].copyWith(
        documents: updatedDocs,
        isAvailable: isApproved,
      );
    }
  }

  @override
  Future<void> updateDriverOnlineStatus(String driverId, bool isOnline) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _drivers.indexWhere((d) => d.userId == driverId);
    if (index != -1) {
      _drivers[index] = _drivers[index].copyWith(isOnline: isOnline);
    }
  }

  @override
  Future<void> updateDocumentStatus({
    required String driverId,
    required String documentId,
    required DocumentStatus status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final vIndex = _vehicles.indexWhere((v) => v.driverId == driverId);
    if (vIndex != -1) {
      final vehicle = _vehicles[vIndex];
      final updatedDocs = vehicle.documents.map((doc) {
        if (doc.id == documentId) {
          return doc.copyWith(
            status: status,
            verifiedAt: status == DocumentStatus.approved ? DateTime.now() : null,
          );
        }
        return doc;
      }).toList();

      final allApproved = updatedDocs.every((d) => d.status == DocumentStatus.approved);
      final anyRejected = updatedDocs.any((d) => d.status == DocumentStatus.rejected);

      _vehicles[vIndex] = vehicle.copyWith(
        documents: updatedDocs,
        isAvailable: allApproved,
      );

      // Reflect on driver
      final dIndex = _drivers.indexWhere((d) => d.userId == driverId);
      if (dIndex != -1) {
        _drivers[dIndex] = _drivers[dIndex].copyWith(
          isApproved: allApproved,
          isOnline: allApproved,
          rejectionReason: anyRejected ? 'Document rejected by Admin KYC review' : null,
        );
      }
    }
  }

  @override
  Future<List<DriverVerificationItem>> getPendingVerifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final List<DriverVerificationItem> items = [];

    final submissionTimeLabels = {
      'DOC-9021': '25 mins ago',
      'DOC-9022': '1 hour ago',
      'DOC-9023': '3 hours ago',
    };

    for (final vehicle in _vehicles) {
      for (final doc in vehicle.documents) {
        if (doc.status == DocumentStatus.pending) {
          final user = _driverUsers.firstWhere(
            (u) => u.id == vehicle.driverId,
            orElse: () => UserModel(
              id: vehicle.driverId,
              phone: '+91 9999999999',
              name: 'Driver ${vehicle.driverId}',
              role: UserRole.driver,
              createdAt: DateTime.now(),
            ),
          );

          items.add(DriverVerificationItem(
            id: doc.id,
            driverId: vehicle.driverId,
            driverName: user.name ?? 'Driver',
            phone: user.phone,
            vehicleName: vehicle.modelName,
            plateNumber: vehicle.plateNumber,
            documentType: doc.documentType,
            documentUrl: doc.documentUrl,
            status: doc.status,
            submittedText: submissionTimeLabels[doc.id] ?? 'Recently',
            submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ));
        }
      }
    }

    return items;
  }
}
