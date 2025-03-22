import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:shurakhsa_kavach/models/app_user.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/enums/user_type.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class DatabaseRepository {
  final FirebaseFirestore _firestore;

  DatabaseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    Address? address,
    UserType role = UserType.normal,
  }) async {
    try {
      final user = AppUser(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      await _firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
      throw DatabaseException('Failed to create user: $e');
    }
  }

  Future<AppUser> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw DatabaseException('User not found');
      }
      return AppUser.fromJson(doc.data()!..['uid'] = doc.id);
    } catch (e) {
      throw DatabaseException('Failed to get user: $e');
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw DatabaseException('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      final addresses = await _firestore
          .collection('addresses')
          .where('userId', isEqualTo: uid)
          .get();

      final leaves = await _firestore
          .collection('leaves')
          .where('userId', isEqualTo: uid)
          .get();

      final batch = _firestore.batch();

      for (var doc in addresses.docs) {
        batch.delete(doc.reference);
      }

      for (var doc in leaves.docs) {
        batch.delete(doc.reference);
      }

      // Delete user document
      batch.delete(_firestore.collection('users').doc(uid));

      // Commit the batch
      await batch.commit();
    } catch (e) {
      throw DatabaseException('Failed to delete user: $e');
    }
  }

  Stream<AppUser> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
          (doc) => AppUser.fromJson(doc.data()!..['uid'] = doc.id),
        );
  }

  Future<void> addOrUpdateAddress(Address address) async {
    try {
      final docRef = _firestore.collection('addresses').doc(address.userId);

      final docSnapshot = await docRef.get();
      final now = DateTime.now();

      final addressWithId = Address(
        id: address.userId,
        userId: address.userId,
        houseName: address.houseName,
        street: address.street,
        city: address.city,
        state: address.state,
        country: address.country,
        zipCode: address.zipCode,
        landmark: address.landmark,
        coordinates: address.coordinates,
        isLocked: address.isLocked,
        createdAt: docSnapshot.exists
            ? (docSnapshot.data()?['createdAt'] as Timestamp).toDate()
            : now,
        updatedAt: now,
      );

      if (docSnapshot.exists) {
        await docRef.update({
          ...addressWithId.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.set({
          ...addressWithId.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw DatabaseException('Failed to save address: $e');
    }
  }

  Future<Address?> getUserAddress(String userId) async {
    try {
      final doc = await _firestore.collection('addresses').doc(userId).get();
      return Address.fromJson(doc.data()!..['id'] = doc.id);
    } catch (e) {
      throw DatabaseException('Failed to get user address');
    }
  }

  Stream<List<AppUser>> getPoliceOfficersStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: UserType.police.toString().split('.').last)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppUser.fromJson(doc.data()..['uid'] = doc.id))
              .toList(),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNearbyUsers({
    required GeoPoint center,
    required double radiusInKm,
  }) async {
    try {
      // Calculate the rough lat/lng bounds for the query
      final lat = center.latitude;
      final lng = center.longitude;
      final latChange = radiusInKm / 111.2; // 1 degree = 111.2 km
      final lngChange = radiusInKm / (111.2 * cos(lat * pi / 180));

      return await _firestore
          .collection('addresses')
          .where('coordinates.latitude',
              isGreaterThan: lat - latChange, isLessThan: lat + latChange)
          .where('coordinates.longitude',
              isGreaterThan: lng - lngChange, isLessThan: lng + lngChange)
          .get();
    } catch (e) {
      throw DatabaseException('Failed to get nearby users: $e');
    }
  }
}
