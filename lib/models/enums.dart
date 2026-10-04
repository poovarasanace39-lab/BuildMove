// Enumerations used throughout BuildMove for type safety.
// Note: String representations match backend PostgreSQL enums.

enum UserRole {
  customer,
  driver,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer / Site Engineer';
      case UserRole.driver:
        return 'Driver / Fleet Owner';
      case UserRole.admin:
        return 'Platform Admin';
    }
  }

  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'driver':
        return UserRole.driver;
      case 'admin':
        return UserRole.admin;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }
}

enum BookingStatus {
  pending,
  searching,
  accepted,
  arriving,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending Dispatch';
      case BookingStatus.searching:
        return 'Assigning Driver...';
      case BookingStatus.accepted:
        return 'Driver Assigned';
      case BookingStatus.arriving:
        return 'Arriving at Pickup';
      case BookingStatus.inProgress:
        return 'In Transit (Loaded)';
      case BookingStatus.completed:
        return 'Delivered & Unloaded';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  static BookingStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'searching':
        return BookingStatus.searching;
      case 'accepted':
        return BookingStatus.accepted;
      case 'arriving':
        return BookingStatus.arriving;
      case 'inprogress':
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }
}

enum VehicleType {
  tataAce(name: 'Tata Ace (Chota Hathi)', capacityTons: 0.8, baseFare: 400, perKm: 30),
  pickup8ft(name: 'Mahindra Bolero Pickup (8ft)', capacityTons: 1.5, baseFare: 650, perKm: 40),
  eeco(name: 'Maruti Eeco Cargo', capacityTons: 0.5, baseFare: 300, perKm: 25),
  tipper6Wheeler(name: '6-Wheeler Tipper / Lorry', capacityTons: 10.0, baseFare: 2500, perKm: 85),
  tipper10Wheeler(name: '10-Wheeler Heavy Dumper', capacityTons: 20.0, baseFare: 4500, perKm: 120),
  tractorTrolley(name: 'Tractor Trolley (Site Supply)', capacityTons: 5.0, baseFare: 1500, perKm: 60);

  final String name;
  final double capacityTons;
  final double baseFare;
  final double perKm;

  const VehicleType({
    required this.name,
    required this.capacityTons,
    required this.baseFare,
    required this.perKm,
  });

  static VehicleType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pickup8ft':
      case 'bolero':
        return VehicleType.pickup8ft;
      case 'eeco':
        return VehicleType.eeco;
      case 'tipper6wheeler':
        return VehicleType.tipper6Wheeler;
      case 'tipper10wheeler':
        return VehicleType.tipper10Wheeler;
      case 'tractortrolley':
        return VehicleType.tractorTrolley;
      case 'tataace':
      default:
        return VehicleType.tataAce;
    }
  }
}

enum ConstructionMaterial {
  cement(name: 'Cement Bags', defaultUnit: 'Bags / Tons'),
  sand(name: 'River / M-Sand', defaultUnit: 'Tons'),
  steel(name: 'TMT Steel Bars', defaultUnit: 'Tons'),
  bricks(name: 'Red / Fly Ash Bricks', defaultUnit: 'Pieces / Tons'),
  aggregates(name: 'Blue Metal Gravel (Jelly)', defaultUnit: 'Tons'),
  tiles(name: 'Tiles & Granite Slabs', defaultUnit: 'Boxes / Tons'),
  timber(name: 'Centering Plywood & Timber', defaultUnit: 'Loads'),
  debris(name: 'Construction Site Debris', defaultUnit: 'Tons');

  final String name;
  final String defaultUnit;

  const ConstructionMaterial({
    required this.name,
    required this.defaultUnit,
  });

  static ConstructionMaterial fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'sand':
        return ConstructionMaterial.sand;
      case 'steel':
        return ConstructionMaterial.steel;
      case 'bricks':
        return ConstructionMaterial.bricks;
      case 'aggregates':
        return ConstructionMaterial.aggregates;
      case 'tiles':
        return ConstructionMaterial.tiles;
      case 'timber':
        return ConstructionMaterial.timber;
      case 'debris':
        return ConstructionMaterial.debris;
      case 'cement':
      default:
        return ConstructionMaterial.cement;
    }
  }
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded;

  static PaymentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'processing':
        return PaymentStatus.processing;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'pending':
      default:
        return PaymentStatus.pending;
    }
  }
}

enum DocumentStatus {
  pending,
  approved,
  rejected;

  static DocumentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'approved':
        return DocumentStatus.approved;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'pending':
      default:
        return DocumentStatus.pending;
    }
  }
}
