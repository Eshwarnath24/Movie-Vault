import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDatabase {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'Users',
  );
  final User? currentUser = FirebaseAuth.instance.currentUser;

  /// Get current user info as a single map inside a list
  Future<List<Map<String, dynamic>>> getCurrentUserInfo() async {
    if (currentUser == null) {
      print('No user currently logged in.');
      return [];
    }

    try {
      DocumentSnapshot doc = await users.doc(currentUser!.uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('Current User Data: $data');
        return [data]; // returning as list for consistency
      } else {
        print('No document found for UID: ${currentUser!.uid}');
        return [];
      }
    } catch (e) {
      print('Error fetching current user info: $e');
      return [];
    }
  }

  /// Update current user info
  Future<void> updateUserInfo(Map<String, dynamic> updatedData) async {
    if (currentUser == null) {
      print('No user currently logged in.');
      return;
    }

    try {
      await users.doc(currentUser!.uid).update(updatedData);
      print('User info updated successfully.');
    } catch (e) {
      print('Error updating user info: $e');
      rethrow;
    }
  }
}
