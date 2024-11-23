import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/features_list.dart';
import 'package:mpa/presentaion/ui/screens/story_book_screen.dart';
import 'package:mpa/presentaion/ui/screens/video_list_screen.dart';
import 'package:mpa/presentaion/ui/screens/youtube_player_screen.dart';
import 'package:mpa/widgets/app_features_card.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({super.key});

  @override
  State<EntertainmentScreen> createState() => _EntertainmentScreenState();
}

class _EntertainmentScreenState extends State<EntertainmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppPrimaryAppBar(isAppbarWithButton: false),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 40),
              itemCount: FeatureLIst.entertainmentFeaturesList.length,
              itemBuilder: (context, index) => appFeatures(index),
              shrinkWrap: true,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          const BottomNavBar(),
        ],
      ),
    );
  }

  Widget appFeatures(int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Get.to(() => const VideoListScreen());
            break;
          case 1:
            Get.to(() => const BookListScreen());
            break;
        }
      },
      child: FittedBox(
          child: AppFeaturesCard(
        featuresDescription: FeatureLIst.entertainmentFeaturesList[index],
      )),
    );
  }
}
