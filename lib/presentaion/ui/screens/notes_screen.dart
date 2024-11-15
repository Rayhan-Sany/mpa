import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/notes_controller.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class NotesScreen extends StatelessWidget {
  final String userId =
      "QGUG2GcEa1f4up03egP8OExX9sl1"; // Replace with the actual user ID

  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPrimaryAppBar(isAppbarWithButton: false),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 12),
            child:
                Text("Your Notes", style: AppFontStyles.playfairDisplay700S30),
          ),
          Expanded(child: buildNotesList(notesController)),
          const BottomNavBar()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.add,
          color: AppColor.textColor,
        ),
      ),
    );
  }

  StreamBuilder<List<Map<String, dynamic>>> buildNotesList(
      NotesController notesController) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: notesController.getNotes(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load notes"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No notes available"));
        }

        final notes = snapshot.data!;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return ListTile(
              title: Text(
                note['title'] ?? 'No Title',
                style: AppFontStyles.playfairDisplay600S20,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(note['content'] ?? 'No Content',
                  style: AppFontStyles.playfairDisplay400S15,
                  overflow: TextOverflow.ellipsis),
              trailing: Text(
                note['timestamp'] != null
                    ? (note['timestamp'] as Timestamp).toDate().toString()
                    : '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  // Show dialog to add a new note
  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final notesController = Get.find<NotesController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Note", style: AppFontStyles.playfairDisplay700S30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 16),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text;
              final content = contentController.text;

              if (title.isNotEmpty && content.isNotEmpty) {
                await notesController.uploadNote(
                  userId: userId,
                  title: title,
                  content: content,
                );
                if (context.mounted) Navigator.of(context).pop();
              } else {
                Get.snackbar("Error", "Title and Content cannot be empty");
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
