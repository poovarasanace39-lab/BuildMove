import '../../models/booking_model.dart';
import '../../models/driver_profile_model.dart';
import '../../models/enums.dart';
import '../../models/location_model.dart';
import '../../models/review_model.dart';
import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';

/// Single source of truth for controlled, deterministic Demo and Test Data.
/// Manages fixtures and state transitions for Customer, Driver, Admin,
/// Bookings, Tracking, Fleet, and Notifications.
class DemoDataService {
  static final DemoDataService instance = DemoDataService._();
  DemoDataService._();

  // Test state flags for empty vs populated verification
  bool _notificationsEmpty = false;
  bool _bookingsEmpty = false;
  bool _fleetEmpty = false;

  bool get isNotificationsEmpty => _notificationsEmpty;
  bool get isBookingsEmpty => _bookingsEmpty;
  bool get isFleetEmpty => _fleetEmpty;

  // --------------------------------------------------------------------------
  // CUSTOMER FIXTURE
  // --------------------------------------------------------------------------
  static final UserModel customerUser = UserModel(
    id: 'usr_cust_001',
    phone: '+91 9876543210',
    name: 'Ramesh Sundaram',
    email: 'ramesh.build@infra.in',
    role: UserRole.customer,
    isVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  static const String customerCompany = 'BuildCon Infra Pvt Ltd';
  static const String customerPhone = '+91 9876543210';

  // --------------------------------------------------------------------------
  // DRIVER FIXTURE
  // --------------------------------------------------------------------------
  static final UserModel driverUser = UserModel(
    id: 'usr_drv_002',
    phone: '+91 9840123456',
    name: 'Murugan K.',
    email: 'murugan.trans@gmail.com',
    role: UserRole.driver,
    isVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  );

  static final DriverProfileModel driverProfile = DriverProfileModel(
    userId: 'usr_drv_002',
    isOnline: true,
    licenseNumber: 'DL-TN-02-2018-0091',
    rating: 4.9,
    totalTrips: 148,
    earningsToday: 2450.0,
    activeVehicleId: 'veh_001',
    isApproved: true,
  );

  // --------------------------------------------------------------------------
  // ADMIN FIXTURE
  // --------------------------------------------------------------------------
  static final UserModel adminUser = UserModel(
    id: 'usr_adm_003',
    phone: '+91 9999900000',
    name: 'Priya Sharma',
    email: 'admin@buildmove.in',
    role: UserRole.admin,
    isVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  );

  // --------------------------------------------------------------------------
  // PRIMARY BOOKING FIXTURE (BM-8492)
  // --------------------------------------------------------------------------
  static BookingModel createPrimaryBooking({
    BookingStatus status = BookingStatus.accepted,
  }) {
    return BookingModel(
      id: 'BM-8492',
      customerId: 'usr_cust_001',
      customerName: 'Ramesh Sundaram',
      customerPhone: '+91 9876543210',
      driverId: 'usr_drv_002',
      driverName: 'Murugan K.',
      driverPhone: '+91 9840123456',
      vehicleType: VehicleType.tipper6Wheeler,
      materialType: ConstructionMaterial.timber,
      quantityTons: 5.5,
      pickupLocation: const LocationModel(
        latitude: 13.0827,
        longitude: 80.2707,
        address: 'Dalmia Cement Depot, Ambattur',
        siteLandmark: 'Opposite Gate 3 Wholesale Depot',
        city: 'Chennai',
        pincode: '600058',
      ),
      dropLocation: const LocationModel(
        latitude: 12.9716,
        longitude: 80.2435,
        address: 'Construction Site, OMR Thoraipakkam',
        siteLandmark: 'Site Phase 2, OMR Navalur',
        city: 'Chennai',
        pincode: '600097',
      ),
      status: status,
      estimatedFare: 1850.0,
      actualFare: status == BookingStatus.completed ? 1850.0 : 1850.0,
      distanceKm: 14.5,
      scheduledAt: DateTime.now().subtract(const Duration(minutes: 20)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      otpForPickup: '4821',
    );
  }

  // --------------------------------------------------------------------------
  // ALL INITIAL BOOKINGS (Active, Completed, Cancelled)
  // --------------------------------------------------------------------------
  static List<BookingModel> createInitialBookings() {
    return [
      createPrimaryBooking(status: BookingStatus.accepted),
      BookingModel(
        id: 'BM-2026-079',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: 'usr_drv_004',
        driverName: 'Selvam P.',
        driverPhone: '+91 9840998877',
        vehicleType: VehicleType.pickup8ft,
        materialType: ConstructionMaterial.sand,
        quantityTons: 1.5,
        pickupLocation: const LocationModel(
          latitude: 13.0405,
          longitude: 80.2337,
          address: 'Sri Ramana M-Sand Yard, Poonamallee High Rd',
          city: 'Chennai',
          pincode: '600056',
        ),
        dropLocation: const LocationModel(
          latitude: 13.0827,
          longitude: 80.2707,
          address: 'Commercial Tower Site, Anna Nagar West',
          city: 'Chennai',
          pincode: '600040',
        ),
        status: BookingStatus.completed,
        estimatedFare: 1100.0,
        actualFare: 1100.0,
        distanceKm: 18.5,
        scheduledAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        otpForPickup: '1903',
      ),
      BookingModel(
        id: 'BM-2026-083',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: null,
        vehicleType: VehicleType.pickup8ft,
        materialType: ConstructionMaterial.steel,
        quantityTons: 1.2,
        pickupLocation: const LocationModel(
          latitude: 13.0102,
          longitude: 80.2156,
          address: 'JSW Steel Stockyard, Guindy Industrial Estate',
          city: 'Chennai',
          pincode: '600032',
        ),
        dropLocation: const LocationModel(
          latitude: 12.9249,
          longitude: 80.1000,
          address: 'Residential Complex, Tambaram West',
          city: 'Chennai',
          pincode: '600045',
        ),
        status: BookingStatus.searching,
        estimatedFare: 980.0,
        distanceKm: 16.0,
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        otpForPickup: '8392',
      ),
      BookingModel(
        id: 'BM-2026-085',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: null,
        vehicleType: VehicleType.tractorTrolley,
        materialType: ConstructionMaterial.bricks,
        quantityTons: 3.0,
        pickupLocation: const LocationModel(
          latitude: 13.1991,
          longitude: 80.1963,
          address: 'Red Bricks Kiln Yard, Red Hills',
          city: 'Chennai',
          pincode: '600052',
        ),
        dropLocation: const LocationModel(
          latitude: 12.8996,
          longitude: 80.2458,
          address: 'Villa Site #42, ECR Akkarai',
          city: 'Chennai',
          pincode: '600119',
        ),
        status: BookingStatus.pending,
        estimatedFare: 1450.0,
        distanceKm: 28.0,
        scheduledAt: DateTime.now().add(const Duration(hours: 4)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        otpForPickup: '6219',
      ),
      BookingModel(
        id: 'BM-2026-071',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: 'usr_drv_005',
        driverName: 'Senthil Nathan',
        driverPhone: '+91 9840998877',
        vehicleType: VehicleType.tipper6Wheeler,
        materialType: ConstructionMaterial.aggregates,
        quantityTons: 8.0,
        pickupLocation: const LocationModel(
          latitude: 12.8912,
          longitude: 80.0812,
          address: 'Blue Metal Quarry, Vandalur',
          city: 'Chennai',
          pincode: '600048',
        ),
        dropLocation: const LocationModel(
          latitude: 13.0067,
          longitude: 80.2024,
          address: 'Metro Rail Pier 118, Guindy',
          city: 'Chennai',
          pincode: '600032',
        ),
        status: BookingStatus.cancelled,
        estimatedFare: 3200.0,
        actualFare: 0.0,
        distanceKm: 22.0,
        scheduledAt: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
    ];
  }

  // --------------------------------------------------------------------------
  // CONTROLLED VEHICLE FIXTURES
  // --------------------------------------------------------------------------
  static List<VehicleModel> createInitialVehicles() {
    return [
      // Vehicle 2: 6-Wheeler Tipper (10T) — Best match for 5.5T load
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
      // Vehicle 1: 2-ton vehicle (Tata Ace / Bolero) — Must be rejected for 5.5T load
      VehicleModel(
        id: 'veh_002',
        driverId: 'usr_drv_004',
        type: VehicleType.pickup8ft,
        modelName: 'Tata Ace / Bolero Maxi (2T)',
        plateNumber: 'TN-14-BD-2311',
        capacityTons: 2.0,
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
      // Vehicle 4: Busy / Off Duty vehicle — Must NOT appear available for new bookings
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
      // Vehicle 3: Pending KYC Vehicle — Must NOT be allowed to go online
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
    ];
  }

  // --------------------------------------------------------------------------
  // CONTROLLED NOTIFICATIONS FIXTURE
  // --------------------------------------------------------------------------
  static List<AppNotificationModel> createInitialNotifications() {
    final now = DateTime.now();
    return [
      AppNotificationModel(
        id: 'notif_001',
        title: 'Booking BM-8492 Accepted',
        titleTa: 'முன்பதிவு BM-8492 ஏற்கப்பட்டது',
        body: 'Driver Murugan K. (TN-02-AL-8921) has accepted your booking.',
        bodyTa: 'ஓட்டுநர் முருகன் கே. (TN-02-AL-8921) உங்கள் முன்பதிவை ஏற்றுக்கொண்டார்.',
        type: 'driver_assigned',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 15)),
        metadata: const {'bookingId': 'BM-8492'},
      ),
      AppNotificationModel(
        id: 'notif_002',
        title: 'Driver has started the trip',
        titleTa: 'ஓட்டுநர் பயணத்தைத் தொடங்கினார்',
        body: 'Murugan K. has started the trip for 5.5T Timber & Plywood to Construction Site, OMR Thoraipakkam.',
        bodyTa: 'முருகன் கே. 5.5 டன் மரம் & பிளைவுட்டுடன் OMR துரைப்பாக்கம் தளத்திற்குப் புறப்பட்டார்.',
        type: 'in_transit',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 10)),
        metadata: const {'bookingId': 'BM-8492'},
      ),
      AppNotificationModel(
        id: 'notif_003',
        title: 'Delivery Completed',
        titleTa: 'டெலிவரி முடிந்தது',
        body: 'Order #BM-2026-079 (M-Sand 1.5T) unloaded and verified with digital slip.',
        bodyTa: 'ஆர்டர் #BM-2026-079 (மணல் 1.5T) தளத்தில் இறக்கப்பட்டு சரிபார்க்கப்பட்டது.',
        type: 'trip_completed',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 18)),
        metadata: const {'bookingId': 'BM-2026-079'},
      ),
      AppNotificationModel(
        id: 'notif_004',
        title: 'Driver Murugan K. Assigned',
        titleTa: 'ஓட்டுநர் முருகன் கே. ஒதுக்கப்பட்டார்',
        body: 'Vehicle TN-02-AL-8921 is dispatched for 5.5T Timber & Plywood to Site Phase 2, OMR.',
        bodyTa: 'TN-02-AL-8921 வாகனம் தளம் ஃபேஸ் 2, OMR-க்கு 5.5 டன் மரம் & பிளைவுட்டுடன் புறப்பட்டது.',
        type: 'driver_assigned',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        metadata: const {'bookingId': 'BM-8492'},
      ),
      AppNotificationModel(
        id: 'notif_005',
        title: 'Material In Transit',
        titleTa: 'சரக்கு பயணத்தில் உள்ளது',
        body: 'Load BM-8492 is en route. Estimated arrival in 28 mins.',
        bodyTa: 'முன்பதிவு BM-8492 பயணத்தில் உள்ளது. 28 நிமிடங்களில் வந்தடையும்.',
        type: 'in_transit',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        metadata: const {'bookingId': 'BM-8492'},
      ),
    ];
  }

  // --------------------------------------------------------------------------
  // RESET MECHANISM
  // --------------------------------------------------------------------------
  void resetToInitialState() {
    _notificationsEmpty = false;
    _bookingsEmpty = false;
    _fleetEmpty = false;
  }

  void setNotificationsEmpty(bool empty) {
    _notificationsEmpty = empty;
  }

  void setBookingsEmpty(bool empty) {
    _bookingsEmpty = empty;
  }

  void setFleetEmpty(bool empty) {
    _fleetEmpty = empty;
  }
}
