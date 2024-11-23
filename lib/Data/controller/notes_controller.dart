import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpa/presentaion/controllers/user_credential.dart';

class NotesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = UserCredentials.userDetails?.uid ?? "";

  @override
  void onInit() async {
    super.onInit();
  }

  // Method to upload a note to Firestore
  Future<void> uploadNote({
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

  // Method to delete a note
  Future<void> deleteNote({
    required String noteId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete note: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to get notes from Firestore for a specific user
  Stream<List<Map<String, dynamic>>> getNotes() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection("notes")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return query.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include document ID for deletion
        return data;
      }).toList();
    });
  }
}
