import 'enums.dart';

class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final UserRole role;
  final bool isVerified;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    required this.role,
    this.isVerified = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'role': role.name,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: UserRole.fromString(json['role'] as String?),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    UserRole? role,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
