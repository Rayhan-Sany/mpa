import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PdfViewerScreenController extends GetxController {
  var isLoading = true.obs;
  var pdfUrl = "".obs;

  Future<void> fetchPdfUrl(String firebasePath) async {
    try {
      if (firebasePath.contains("http")) {
        pdfUrl.value = firebasePath;
      } else {
        final ref = FirebaseStorage.instance.ref(firebasePath);
        final url = await ref.getDownloadURL();
        pdfUrl.value = url;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch PDF: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
