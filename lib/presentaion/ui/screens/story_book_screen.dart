import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/book_controller.dart';
import 'package:mpa/presentaion/ui/screens/pdf_viewer_screen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart'; // Adjust the import path accordingly

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookController =
        Get.find<BookController>(); // Initialize the controller

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.textColor,
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookController.books.isEmpty) {
          return const Center(child: Text("No books available"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            return await bookController.fetchBooks();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.6, // Adjust for book cover proportions
            ),
            itemCount: bookController.books.length,
            itemBuilder: (context, index) {
              final book = bookController.books[index];
              return BookCard(
                title: book['title'] ?? 'No Title',
                author: book['author'] ?? 'Unknown Author',
                imageUrl: book['imageUrl'] ?? '',
                pdfUrl: book['pdfUrl'],
                onDelete: () {
                  // Trigger delete when the user presses delete
                  bookController.deleteBook(book['title']);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context, bookController);
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(Icons.add, color: AppColor.textColor),
      ),
    );
  }

  // Function to show the dialog for adding a new book
  void _showAddBookDialog(BuildContext context, BookController bookController) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Book", style: AppFontStyles.playfairDisplay600S20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                bookController.onClickProfileAvatar();
              },
              child: Obx(() {
                return CircleAvatar(
                  backgroundImage: getAvatarBgImage(),
                  radius: 35,
                );
              }),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 16),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () async {
                  await bookController.onClickAddPdf();
                },
                child: Row(
                  children: [
                    SizedBox(
                        height: 30, child: Image.asset(AssetsPath.pdfLogo)),
                    const SizedBox(width: 10),
                    Obx(() {
                      return bookController.isPdfSelected.value
                          ? Flexible(
                              child: Text(
                                "${bookController.bookPdf?.value.path}",
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            )
                          : const Text("Tap To Add Book Pdf");
                    })
                  ],
                ))
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          Obx(() {
            return bookController.isUploading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final title = titleController.text;
                      final author = authorController.text;

                      if (title.isNotEmpty &&
                          author.isNotEmpty &&
                          bookController.isPdfSelected.value == true &&
                          bookController.isPhotoSelected.value == true) {
                        await bookController.uploadBook(
                          // Replace with actual user ID
                          title: title,
                          author: author,
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      } else {
                        Get.snackbar("Error", "All fields are required.");
                      }
                    },
                    child: const Text("Add Book"),
                  );
          })
        ],
      ),
    );
  }
}

dynamic getAvatarBgImage() {
  if (Get.find<BookController>().isPhotoSelected.value) {
    return FileImage(Get.find<BookController>().bookImage!);
  } else {
    return AssetImage(AssetsPath.expanseLogo);
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String pdfUrl;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.pdfUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Show confirmation dialog when long pressed
        _showDeleteDialog(context);
      },
      onTap: () {
        Get.to(() => PdfViewerScreen(firebasePath: pdfUrl, pdfName: title));
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: AppColor.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.broken_image,
                          size: 50,
                        ),
                      )
                    : const Icon(Icons.book, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.textColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
              child: Text(
                author,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show a delete confirmation dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Book'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                onDelete(); // Call the delete function
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
