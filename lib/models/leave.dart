import 'package:cloud_firestore/cloud_firestore.dart';

class Leave {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Leave({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      userId: json['userId'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      images: List<String>.from(json['images']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  Leave copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? images,
  }) {
    return Leave(
      id: id,
      userId: userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      images: images ?? this.images,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
