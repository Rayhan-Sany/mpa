import 'package:mpa/presentaion/ui/utils/assets_path.dart';

class FeatureLIst {
  static List<Map<String, String>> featuresList = [
    {"Name": "Track Expanses", "Logo": AssetsPath.expanseLogo},
    {"Name": "Education", "Logo": AssetsPath.academicLogo},
    {"Name": "Entertainment", "Logo": AssetsPath.entertainmentLogo},
    {"Name": "Notes", "Logo": AssetsPath.notesLogo},
  ];

  static List<Map<String, String>> entertainmentFeaturesList = [
    {"Name": "Multimedia", "Logo": AssetsPath.videosIcon},
    {"Name": "Books", "Logo": AssetsPath.booksIcon}
  ];
}
