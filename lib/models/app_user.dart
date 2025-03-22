import 'package:shurakhsa_kavach/enums/user_type.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/models/leave.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final Address address;
  final UserType role;
  final List<Leave> leaves;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? deviceToken;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    required this.address,
    required this.role,
    required this.leaves,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.deviceToken,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      role: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['role']}',
      ),
      leaves: (json['leaves'] as List).map((e) => Leave.fromJson(e)).toList(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isActive: json['isActive'] ?? true,
      deviceToken: json['deviceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address.toJson(),
      'role': role.toString().split('.').last,
      'leaves': leaves.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'deviceToken': deviceToken,
    };
  }

  String get fullName => '$firstName $lastName';

  AppUser copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    Address? address,
    UserType? role,
    List<Leave>? leaves,
    bool? isActive,
    String? deviceToken,
  }) {
    return AppUser(
      uid: uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      leaves: leaves ?? this.leaves,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }
}
