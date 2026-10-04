class ReviewModel {
  final String id;
  final String bookingId;
  final double rating;
  final String comment;
  final String reviewerRole; // customer or driver
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.reviewerRole,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'rating': rating,
      'comment': comment,
      'reviewer_role': reviewerRole,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String? ?? '',
      reviewerRole: json['reviewer_role'] as String? ?? 'customer',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class AppNotificationModel {
  final String id;
  final String title;
  final String body;
  final String? titleTa;
  final String? bodyTa;
  final String type; // booking_request, accepted, trip_started, trip_completed, payment
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.titleTa,
    this.bodyTa,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.metadata,
  });

  String getDisplayTitle(String localeCode) {
    if (localeCode == 'ta' && titleTa != null && titleTa!.isNotEmpty) {
      return titleTa!;
    }
    return title;
  }

  String getDisplayBody(String localeCode) {
    if (localeCode == 'ta' && bodyTa != null && bodyTa!.isNotEmpty) {
      return bodyTa!;
    }
    return body;
  }

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? titleTa,
    String? bodyTa,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      titleTa: titleTa ?? this.titleTa,
      bodyTa: bodyTa ?? this.bodyTa,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'title_ta': titleTa,
      'body_ta': bodyTa,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      titleTa: json['title_ta'] as String?,
      bodyTa: json['body_ta'] as String?,
      type: json['type'] as String? ?? 'general',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
