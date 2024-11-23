import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/video_list_screen_controller.dart';
import 'package:mpa/presentaion/ui/screens/youtube_player_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  @override
  Widget build(BuildContext context) {
    final videoUrlTEController = TextEditingController();
    final videoListScreenController = Get.find<VideoListScreenController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text("Videos"),
        foregroundColor: AppColor.textColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onClickFabButton(
              context, videoUrlTEController, videoListScreenController);
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.add,
          color: AppColor.textColor,
        ),
      ),
      body: Column(
        children: [
          Obx(() {
            return Expanded(
                child: videoListScreenController.getVideosIsInProgress.value
                    ? const CircularProgressIndicator()
                    : videoListScreenController.videoList.isEmpty
                        ? const Center(
                            child: Text("No Videos"),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await videoListScreenController.getVideos();
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 10),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return getVideoAndTitle(
                                    context, videoListScreenController, index);
                              },
                              itemCount:
                                  videoListScreenController.videoList.length,
                            ),
                          ));
          }),
        ],
      ),
    );
  }

  Future<dynamic> onClickFabButton(
      BuildContext context,
      TextEditingController videoUrlTEController,
      VideoListScreenController videoListScreenController) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Text("Enter Video Url",
                      style: AppFontStyles.playfairDisplay700S30),
                  const SizedBox(height: 16),
                  TextField(
                    controller: videoUrlTEController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cencel")),
                      const SizedBox(width: 10),
                      Obx(() {
                        return videoListScreenController
                                .uploadingIsInProgress.value
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  videoListScreenController.uploadVideoId(
                                      videoUrlTEController.text.trim());
                                  Navigator.pop(context);
                                },
                                child: const Text("Upload"));
                      })
                    ],
                  )
                ],
              ),
            ));
  }

  Widget getVideoAndTitle(BuildContext context,
      VideoListScreenController videoListScreenController, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => YoutubePlayerScreen(
              videoId: videoListScreenController.videoList[index]["id"],
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                videoListScreenController.videoList[index]["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 300,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    videoListScreenController.videoList[index]["title"],
                    style: AppFontStyles.playfairDisplay600S20
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                    softWrap: true,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
