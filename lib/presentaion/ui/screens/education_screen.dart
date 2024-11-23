import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/education_screen_controller.dart';
import 'package:mpa/presentaion/ui/screens/homscreen.dart';
import 'package:mpa/presentaion/ui/screens/pdf_viewer_screen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final educationScreenController = Get.find<EducationScreenController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (isPopAvailable()) {
          Get.off(() => const HomePage());
        }
        if (educationScreenController.pathStack.length > 1) {
          educationScreenController.pathStack.removeLast();
          educationScreenController.currentPath.value =
              educationScreenController.pathStack.last;

          educationScreenController.getEducationFileAndFolders(
              educationScreenController.currentPath.value);
        }
        print("Back----${educationScreenController.currentPath.value}");
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showFabMenu(context);
            },
            backgroundColor: AppColor.primaryColor,
            child: const Icon(Icons.add, color: AppColor.textColor),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppPrimaryAppBar(isAppbarWithButton: false),
              filesAndFolderSection()
            ],
          )),
    );
  }

  bool isPopAvailable() =>
      (educationScreenController.currentPath.value == "Education")
          ? true
          : false;

  Future<dynamic> createFolderDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController folderNameTEController =
              TextEditingController();
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Column(
              children: [
                Text("Enter Folder Name",
                    style: AppFontStyles.playfairDisplay700S30),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: folderNameTEController,
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cencel")),
                    const SizedBox(width: 16),
                    ElevatedButton(
                        onPressed: () {
                          if (folderNameTEController.text.isNotEmpty) {
                            educationScreenController
                                .createEmptyFolder(folderNameTEController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Create")),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget filesAndFolderSection() {
    return Obx(() {
      return educationScreenController.isInProgress.value
          ? const Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(() {
                        return Text(educationScreenController.currentPath.value,
                            style: AppFontStyles.playfairDisplay400S15
                                .copyWith(color: AppColor.primaryColor));
                      })),
                  Expanded(
                    child: Obx(() {
                      return (educationScreenController.pathContent.isEmpty)
                          ? const Center(
                              child: Text("Empty Folder"),
                            )
                          : filesAndFolderListView();
                    }),
                  )
                ],
              ),
            );
    });
  }

  Widget filesAndFolderListView() {
    return RefreshIndicator(
      onRefresh: () => educationScreenController.getEducationFileAndFolders(
          educationScreenController.currentPath.value),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            minVerticalPadding: 20,
            onTap: () => onTap(index),
            leading: Image.asset(
              educationScreenController.pathContent[index]["isFolder"]
                  ? AssetsPath.directoryLogo
                  : AssetsPath.pdfLogo,
              height: 45,
            ),
            title: Text(
              educationScreenController.pathContent[index]["name"],
              style: AppFontStyles.playfairDisplay600S20
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            trailing: trailingPopUpMenuButton(index),
          );
        },
        itemCount: educationScreenController.pathContent.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
      ),
    );
  }

  PopupMenuButton<String> trailingPopUpMenuButton(int index) {
    return PopupMenuButton<String>(
      surfaceTintColor: AppColor.primaryColor,
      padding: const EdgeInsets.all(0),
      onSelected: (value) {
        if (value == "delete") {
          // Handle delete action
          handleDelete(index);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete"),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  Future<void> onTap(int index) async {
    if (educationScreenController.pathContent[index]["isFolder"]) {
      educationScreenController.pathWithIndicator.value +=
          " > ${educationScreenController.pathContent[index]["name"]}";
      educationScreenController.pathStack.add(
          "${educationScreenController.pathStack.last}/${educationScreenController.pathContent[index]["name"]}");
      educationScreenController.currentPath.value =
          educationScreenController.pathStack.last;
      await educationScreenController.getEducationFileAndFolders(
          educationScreenController.currentPath.value);
      print(educationScreenController.currentPath);
    } else {
      Get.to(() => PdfViewerScreen(
            firebasePath:
                "${educationScreenController.pathStack.last}/${educationScreenController.pathContent[index]["name"]}",
            pdfName: "${educationScreenController.pathContent[index]["name"]}",
          ));
    }
  }

  Future<void> handleDelete(int index) async {
    if (educationScreenController.pathContent[index]["isFolder"]) {
      await educationScreenController.deleteFolder(
          folderPath:
              "${educationScreenController.currentPath.value}/${educationScreenController.pathContent[index]["name"]}",
          index: index);
    } else {
      await educationScreenController.deleteFile(
          "${educationScreenController.currentPath.value}/${educationScreenController.pathContent[index]["name"]}",
          index);
    }
  }

  void showFabMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 571, 0, 0),

      // Adjust position
      items: [
        const PopupMenuItem(
          value: 'uploadFile',
          child: Row(
            children: [
              Icon(Icons.add, color: AppColor.primaryColor),
              SizedBox(width: 10),
              Text("Upload File"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'createFolder',
          child: Row(
            children: [
              Icon(Icons.add, color: AppColor.primaryColor),
              SizedBox(width: 10),
              Text("Create Folder"),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        handleFabMenuSelection(value, context);
      }
    });
  }

  void handleFabMenuSelection(String value, BuildContext context) {
    if (value == 'createFolder') {
      createFolderDialog(context);
    } else if (value == 'uploadFile') {
      uploadFileDialog(context);
      print("File Upload");
    }
  }

  Future<dynamic> uploadFileDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController fileNameTEController = TextEditingController();
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter File Name",
                    style: AppFontStyles.playfairDisplay700S30),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: fileNameTEController,
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text("Attach File", style: AppFontStyles.playfairDisplay700S30),
                const SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      hoverColor: AppColor.primaryColor,
                      onTap: () async {
                        await educationScreenController.pickFile();
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          side: BorderSide(color: AppColor.primaryColor)),
                      leading: const Icon(
                        Icons.attachment,
                        color: AppColor.primaryColor,
                      ),
                      title: educationScreenController.isFileSelected.value
                          ? Text(educationScreenController.file?.value.path
                                  .toString() ??
                              "")
                          : Text("No File Selected"));
                }),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cencel")),
                    const SizedBox(width: 16),
                    Obx(() {
                      return educationScreenController
                              .isFileUploadingIsInProgress.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (fileNameTEController.text.isNotEmpty) {
                                  await educationScreenController.uploadFile(
                                      "${educationScreenController.currentPath.string}/${fileNameTEController.text.trim()}.pdf");
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text("Upload"));
                    }),
                  ],
                )
              ],
            ),
          );
        });
  }
}
