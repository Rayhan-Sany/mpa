import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class VideoListScreenController extends GetxController {
  RxBool uploadingIsInProgress = false.obs;
  RxBool getVideosIsInProgress = false.obs;
  RxList videoList = [].obs;
  String? videoId;
  String? videoTitle;

  @override
  void onInit() async {
    super.onInit();
    await getVideos();
  }

  Future<void> uploadVideoId(String videoUrl) async {
    uploadingIsInProgress.value = true;
    String uid = await LocalStorageController.getUid();
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Entertainment")
        .doc("AllVideos");

    await fetchVideoTitleAndId(videoUrl);

    try {
      print(videoId);
      print(videoTitle);
      Map<String, dynamic> videoDetails = {
        "title": videoTitle ?? videoId,
        "id": videoId,
        "image": "https://img.youtube.com/vi/$videoId/sddefault.jpg"
      };
      docRef.set({
        "videoIdList": FieldValue.arrayUnion([videoDetails])
      }, SetOptions(merge: true));
      AppSnackbar.showAppSnackbar(
          title: "Success", subtitle: "Uploaded Sucessfully");
      videoList.add(videoDetails);
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Faild", subtitle: "Uploading Failed : ${e.toString()}");
    }

    uploadingIsInProgress.value = false;
  }

  Future<void> getVideos() async {
    getVideosIsInProgress.value = true;
    videoList.clear();
    String uid = await LocalStorageController.getUid();
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Entertainment")
        .doc("AllVideos");

    try {
      docRef.get().then((value) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        print(data);
        videoList.value = data["videoIdList"];
      });
    } catch (e) {
      print(e.toString());
    }
    getVideosIsInProgress.value = false;
  }

  Future<void> fetchVideoTitleAndId(String url) async {
    try {
      extractVideoId(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String html = response.body;
        String? title = extractTitleFromHtml(html);
        videoTitle = title;
      } else {
        print("Video title not found");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? extractTitleFromHtml(String html) {
    final RegExp regExp =
        RegExp(r'<meta property="og:title" content="([^"]+)"');
    final match = regExp.firstMatch(html);
    return match?.group(1); // Extracts the content from the "og:title" meta tag
  }

  void extractVideoId(String url) {
    final RegExp regExp = RegExp(r'(?:v=|\/)([a-zA-Z0-9_-]{11})');
    final match = regExp.firstMatch(url);
    videoId = match?.group(1); // Extract the video ID
  }
}
