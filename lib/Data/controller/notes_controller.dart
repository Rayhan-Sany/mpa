import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to upload a note to Firestore
  Future<void> uploadNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    final docRef = _firestore.collection("users").doc(userId);
    try {
      await docRef.collection('notes').add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Note uploaded successfully");
    } catch (e) {
      print("Failed to upload note: $e");
    }
  }

  // Method to get notes from Firestore for a specific user
  Stream<List<Map<String, dynamic>>> getNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection("notes")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return query.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }
}
