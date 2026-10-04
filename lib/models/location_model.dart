class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? siteLandmark;
  final String? city;
  final String? pincode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.siteLandmark,
    this.city,
    this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'site_landmark': siteLandmark,
      'city': city,
      'pincode': pincode,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String? ?? '',
      siteLandmark: json['site_landmark'] as String?,
      city: json['city'] as String?,
      pincode: json['pincode'] as String?,
    );
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? siteLandmark,
    String? city,
    String? pincode,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      siteLandmark: siteLandmark ?? this.siteLandmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
    );
  }
}
