import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/app/utils/features_list.dart';
import 'package:mpa/presentaion/ui/screens/track_expanses_screen.dart';
import 'package:mpa/presentaion/ui/screens/youtube_player_screen.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';
import 'package:mpa/widgets/app_features_card.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const AppPrimaryAppBar(),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 40),
            itemCount: FeatureLIst.featuresList.length,
            itemBuilder: (context, index) => appFeatures(index),
            shrinkWrap: true,
          ),
        ),
        const Spacer(),
        const BottomNavBar()
      ],
    ));
  }

  Widget appFeatures(int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Get.to(const TrackExpansesScreen());
          case 2:
            Get.put(GetdataController()).getSingleDayData();
          // Get.to(const YoutubePlayerScreen());
        }
      },
      child: FittedBox(
          child: AppFeaturesCard(
        featuresDescription: FeatureLIst.featuresList[index],
      )),
    );
  }
}
