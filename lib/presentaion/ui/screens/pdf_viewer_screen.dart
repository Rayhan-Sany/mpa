import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:mpa/presentaion/controllers/pdf_viewr_screen_controller.dart';

class PdfViewerScreen extends StatelessWidget {
  final String firebasePath;
  final String pdfName;

  PdfViewerScreen(
      {super.key, required this.firebasePath, required this.pdfName});

  final controller = Get.find<PdfViewerScreenController>();

  @override
  Widget build(BuildContext context) {
    // Fetch PDF URL when the screen is loaded.
    controller.fetchPdfUrl(firebasePath);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pdfName,
        ),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.textColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pdfUrl.isEmpty) {
          return const Center(child: Text("Failed to load PDF"));
        }

        return SfPdfViewer.network(controller.pdfUrl.value);
      }),
    );
  }
}
