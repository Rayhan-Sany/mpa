import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/user_credential.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class BookController extends GetxController {
  final RxList<Map<String, dynamic>> books = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  RxBool isUploading = false.obs;
  RxBool isPhotoSelected = false.obs;
  RxBool isPdfSelected = false.obs;
  File? bookImage;
  Rx<File>? bookPdf;
  final userId = UserCredentials.userDetails?.uid ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    isLoading.value = true; // Set loading to true before fetching data
    books.clear();
    final booksCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("books")
        .doc("storyBooks"); // Document where bookList is stored

    // Fetch the document containing the bookList
    booksCollection.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        // Extract the bookList from the document data
        final bookList = docSnapshot.data()?['bookList'] as List<dynamic>?;

        if (bookList != null && bookList.isNotEmpty) {
          // Convert the List<dynamic> to a List<Map<String, dynamic>> to work with
          final fetchedBooks = bookList.map((book) {
            return book as Map<String, dynamic>;
          }).toList();

          books.assignAll(
              fetchedBooks); // Update the books list with the fetched data
        } else {
          books.clear(); // Clear the list if no books are available
        }
      } else {
        books.clear(); // Clear the list if document does not exist
      }
      isLoading.value = false; // Set loading to false once the data is fetched
    }).catchError((error) {
      isLoading.value = false; // Set loading to false if there's an error
      Get.snackbar(
          "Error", "Failed to load books: $error"); // Show error snackbar
    });
  }

  Future<void> uploadBook({
    required String title,
    required String author,
  }) async {
    isUploading.value = true;
    // Reference to the Firestore user's books collection
    final booksCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("books")
        .doc("storyBooks");

    String bookPhotoUrl = await uploadBookImage(userId, title) ??
        AssetsPath.defaultProfileImageUrl;
    String? pdfUrl = await uploadBookFile("$userId/books/$title.pdf");

    try {
      Map<String, dynamic> bookDetails = {
        'title': title,
        'author': author,
        'imageUrl': bookPhotoUrl,
        'pdfUrl': pdfUrl,
        'timestamp': DateTime.timestamp() // Add a timestamp for sorting
      };
      // Add a new document with the book details
      await booksCollection.set({
        "bookList": FieldValue.arrayUnion([bookDetails])
      }, SetOptions(merge: true)).onError((e, stackTrace) {
        throw e.toString();
      });

      // Show a success message using GetX Snackbar
      Get.snackbar(
        "Success",
        "Book uploaded successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      print("---------------------");
      print(error.toString());
      print("---------------------");
      // Show an error message using GetX Snackbar
      Get.snackbar(
        "Error",
        "Failed to upload book: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isUploading.value = false;
  }

  Future<String?> uploadBookFile(String fullPath) async {
    try {
      final fileRef = FirebaseStorage.instance.ref(fullPath);

      if (bookPdf?.value != null) {
        final readyFile = bookPdf!.value.readAsBytesSync();
        await fileRef.putData(readyFile).onError((e, stackTrace) {
          throw e.toString();
        });
        isPdfSelected.value = false;
        bookPdf?.value.delete();
        AppSnackbar.showAppSnackbar(
            title: "Successfull", subtitle: "File Uploaded Successfully");

        String pdfUrl = await fileRef.getDownloadURL();
        return pdfUrl;
      }
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Unsuccessfull",
          subtitle: "File Upload Error ${e.toString()}");

      print(e.toString());
      return null;
    }

    return null;
  }

  Future<String?> uploadBookImage(String uid, String bookName) async {
    if (bookImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(uid).child("bookImages");
      String fileName = "$bookName.jpg";
      final spaceRef = imagesRef.child(fileName);

      try {
        await spaceRef.putFile(bookImage!);
        final storageRef =
            FirebaseStorage.instance.ref("$uid/bookImages/$bookName.jpg");
        final bookPhotoUrl = await storageRef.getDownloadURL();
        return bookPhotoUrl;
      } on FirebaseException catch (e) {
        print(e.toString());
        // ...
      }
    } else {
      print("Image Not Found To Uplaod");
    }
    return null;
  }

  Future<void> onClickProfileAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      bookImage = File(result.files.single.path!);
      isPhotoSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }

  Future<void> onClickAddPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      bookPdf = File(result.files.single.path!).obs;
      isPdfSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }

  void deleteBook(String title) async {
    final booksCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("books")
        .doc("storyBooks"); // Reference to the document storing bookList

    try {
      // Fetch the current document to get the bookList
      final docSnapshot = await booksCollection.get();
      if (docSnapshot.exists) {
        // Extract the bookList from the document, ensuring proper type handling
        final bookList = docSnapshot.data()?['bookList'] as List<dynamic>?;

        if (bookList != null && bookList.isNotEmpty) {
          // Filter the list and remove the book with the specific title
          final updatedBookList = bookList.where((book) {
            // Ensure the 'title' field exists in each book entry
            return book['title'] != title;
          }).toList();

          // Update the document by setting the updated bookList
          await booksCollection.update({
            'bookList': updatedBookList,
          });
          await FirebaseStorage.instance
              .ref("$userId/bookImages/$title")
              .delete();
          await FirebaseStorage.instance.ref("$userId/books/$title").delete();

          // Optionally update the local books list
          books.assignAll(updatedBookList
              .map((book) => book as Map<String, dynamic>)
              .toList());

          AppSnackbar.showAppSnackbar(
              title: "Success", subtitle: "Book deleted successfully");
        } else {
          AppSnackbar.showAppSnackbar(
              title: "Error",
              subtitle: "No books available to delete",
              isErrorSnak: true);
        }
      } else {
        AppSnackbar.showAppSnackbar(
            title: "Error", subtitle: "No books found to delete");
      }
    } catch (error) {
      print(error.toString());
      AppSnackbar.showAppSnackbar(
          title: "Error", subtitle: "Failed to delete the book: $error");
    }
  }
}
