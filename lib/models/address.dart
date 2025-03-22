import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String id;
  final String userId;
  final String houseName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final GeoPoint coordinates;
  final String country;
  final String landmark;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.houseName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.coordinates,
    required this.country,
    required this.landmark,
    this.isLocked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['userId'],
      houseName: json['houseName'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      coordinates: json['coordinates'],
      country: json['country'],
      landmark: json['landmark'],
      isLocked: json['isLocked'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'houseName': houseName,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'coordinates': coordinates,
      'country': country,
      'landmark': landmark,
      'isLocked': isLocked,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String get formattedAddress {
    return '$houseName, $street, $landmark, $city, $state, $country - $zipCode';
  }

  Address copyWith({
    String? houseName,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    GeoPoint? coordinates,
    String? country,
    String? landmark,
    bool? isLocked,
  }) {
    return Address(
      id: id,
      userId: userId,
      houseName: houseName ?? this.houseName,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      coordinates: coordinates ?? this.coordinates,
      country: country ?? this.country,
      landmark: landmark ?? this.landmark,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
