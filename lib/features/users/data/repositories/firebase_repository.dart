import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_first/features/users/data/models/address.dart';
import 'package:offline_first/features/users/data/models/company.dart';
import 'package:offline_first/features/users/data/models/user.dart';

@lazySingleton
class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseRepository();

  Future<void> addUsersToFirestore(List<User> users) async {
    for (final user in users) {
      try {
        final addressRef =
            _firestore.collection('addresses').doc(user.address.id.toString());
        await addressRef.set({
          'street': user.address.street,
          'suite': user.address.suite,
          'city': user.address.city,
          'zipcode': user.address.zipcode,
        });

        final companyRef =
            _firestore.collection('companies').doc(user.company.id.toString());
        await companyRef.set(user.company.toJson());

        final userRef = _firestore.collection('users').doc(user.id.toString());
        await userRef.set({
          'name': user.name,
          'username': user.username,
          'email': user.email,
          'addressId': addressRef.id,
          'phone': user.phone,
          'website': user.website,
          'companyId': companyRef.id,
          'changedLocally': user.changedLocally,
        });
      } catch (e) {
        log('Error adding user ${user.name}: $e');
      }
    }
  }

  Future<List<User>> getUsersFromFirestore() async {
    final List<User> users = [];

    try {
      final userDocs = await _firestore.collection('users').get();

      for (final userDoc in userDocs.docs) {
        final userData = userDoc.data();

        final addressDoc = await _firestore
            .collection('addresses')
            .doc(userData['addressId'] as String)
            .get();
        final addressData = addressDoc.data();
        if (addressData == null) return [];

        final companyDoc = await _firestore
            .collection('companies')
            .doc(userData['companyId'] as String)
            .get();
        final companyData = companyDoc.data();

        final address = Address(
          id: int.parse(addressDoc.id),
          street: addressData['street'] as String,
          suite: addressData['suite'] as String,
          city: addressData['city'] as String,
          zipcode: addressData['zipcode'] as String,
        );

        final company = Company(
          id: int.parse(companyDoc.id),
          name: companyData!['name'] as String,
          catchPhrase: companyData['catchPhrase'] as String,
          bs: companyData['bs'] as String,
        );

        final user = User(
          id: int.parse(userDoc.id),
          name: userData['name'] as String,
          username: userData['username'] as String,
          email: userData['email'] as String,
          address: address,
          phone: userData['phone'] as String,
          website: userData['website'] as String,
          company: company,
        );

        users.add(user);
      }
    } catch (e) {
      log('Error fetching users: $e');
      rethrow;
    }

    return users;
  }

  Future<void> updateUserInFirestore(User user) async {
    try {
      final addressRef =
          _firestore.collection('addresses').doc(user.address.id.toString());
      await addressRef.update({
        'street': user.address.street,
        'suite': user.address.suite,
        'city': user.address.city,
        'zipcode': user.address.zipcode,
      });

      final companyRef =
          _firestore.collection('companies').doc(user.company.id.toString());
      await companyRef.update({
        'name': user.company.name,
        'catchPhrase': user.company.catchPhrase,
        'bs': user.company.bs,
      });

      final userRef = _firestore.collection('users').doc(user.id.toString());
      await userRef.update({
        'name': user.name,
        'username': user.username,
        'email': user.email,
        'addressId': addressRef.id,
        'phone': user.phone,
        'website': user.website,
        'companyId': companyRef.id,
        'changedLocally': user.changedLocally,
      });

      log('User ${user.name} updated successfully in Firestore');
    } catch (e) {
      log('Error updating user: $e');
    }
  }

  Future<void> deleteUserFromFirestore(String userId) async {
    try {

      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (!userSnapshot.exists) {
        log('User with ID $userId not found in Firestore.');
        return;
      }

      String addressId = userSnapshot.get('addressId');
      String companyId = userSnapshot.get('companyId');

      await _firestore.collection('users').doc(userId).delete();
      log('User with ID $userId deleted successfully from Firestore.');

      if (addressId.isNotEmpty) {
        await _firestore.collection('addresses').doc(addressId).delete();
        log('Address with ID $addressId deleted successfully from Firestore.');
      }

      if (companyId.isNotEmpty) {
        await _firestore.collection('companies').doc(companyId).delete();
        log('Company with ID $companyId deleted successfully from Firestore.');
      }
    } catch (e) {
      log('Error deleting user or related data: $e');
      rethrow;
    }
  }
}
