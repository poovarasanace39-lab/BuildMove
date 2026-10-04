import 'enums.dart';

class VehicleModel {
  final String id;
  final String driverId;
  final VehicleType type;
  final String modelName;
  final String plateNumber;
  final double capacityTons;
  final bool isAvailable;
  final List<VehicleDocumentModel> documents;

  const VehicleModel({
    required this.id,
    required this.driverId,
    required this.type,
    required this.modelName,
    required this.plateNumber,
    required this.capacityTons,
    this.isAvailable = true,
    this.documents = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'type': type.name,
      'model_name': modelName,
      'plate_number': plateNumber,
      'capacity_tons': capacityTons,
      'is_available': isAvailable,
      'documents': documents.map((d) => d.toJson()).toList(),
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      type: VehicleType.fromString(json['type'] as String?),
      modelName: json['model_name'] as String? ?? '',
      plateNumber: json['plate_number'] as String? ?? '',
      capacityTons: (json['capacity_tons'] as num?)?.toDouble() ?? 1.0,
      isAvailable: json['is_available'] as bool? ?? true,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((d) => VehicleDocumentModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
  VehicleModel copyWith({
    String? id,
    String? driverId,
    VehicleType? type,
    String? modelName,
    String? plateNumber,
    double? capacityTons,
    bool? isAvailable,
    List<VehicleDocumentModel>? documents,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      type: type ?? this.type,
      modelName: modelName ?? this.modelName,
      plateNumber: plateNumber ?? this.plateNumber,
      capacityTons: capacityTons ?? this.capacityTons,
      isAvailable: isAvailable ?? this.isAvailable,
      documents: documents ?? this.documents,
    );
  }
}

class VehicleDocumentModel {
  final String id;
  final String documentType; // RC, Insurance, Fitness, Pollution, DrivingLicense
  final String documentUrl;
  final DocumentStatus status;
  final DateTime? verifiedAt;

  const VehicleDocumentModel({
    required this.id,
    required this.documentType,
    required this.documentUrl,
    this.status = DocumentStatus.pending,
    this.verifiedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'document_url': documentUrl,
      'status': status.name,
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }

  factory VehicleDocumentModel.fromJson(Map<String, dynamic> json) {
    return VehicleDocumentModel(
      id: json['id'] as String,
      documentType: json['document_type'] as String? ?? 'RC',
      documentUrl: json['document_url'] as String? ?? '',
      status: DocumentStatus.fromString(json['status'] as String?),
      verifiedAt: json['verified_at'] != null ? DateTime.tryParse(json['verified_at'].toString()) : null,
    );
  }

  VehicleDocumentModel copyWith({
    String? id,
    String? documentType,
    String? documentUrl,
    DocumentStatus? status,
    DateTime? verifiedAt,
  }) {
    return VehicleDocumentModel(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      documentUrl: documentUrl ?? this.documentUrl,
      status: status ?? this.status,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}
