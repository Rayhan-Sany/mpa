import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/features_list.dart';
import 'package:mpa/presentaion/ui/screens/education_screen.dart';
import 'package:mpa/presentaion/ui/screens/entertainment_screen.dart';
import 'package:mpa/presentaion/ui/screens/notes_screen.dart';
import 'package:mpa/presentaion/ui/screens/track_expanses_screen.dart';
import 'package:mpa/presentaion/ui/screens/youtube_player_screen.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';
import 'package:mpa/widgets/app_drawer.dart';
import 'package:mpa/widgets/app_features_card.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () {
            return onRefresh();
          },
          child: Column(
            children: [
              const AppPrimaryAppBar(isAppbarWithButton: true),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 40),
                  itemCount: FeatureLIst.featuresList.length,
                  itemBuilder: (context, index) => appFeatures(index),
                  shrinkWrap: true,
                ),
              ),
              const Spacer(),
              const BottomNavBar()
            ],
          ),
        ));
  }

  Future<void> onRefresh() async {
    setState(() {});
  }

  Widget appFeatures(int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Get.to(() => const TrackExpansesScreen());
            break;
          case 1:
            Get.to(() => const EducationScreen());
            break;
          case 2:
            Get.to(const EntertainmentScreen());
            break;
          case 3:
            Get.to(() => const NotesScreen());
        }
      },
      child: FittedBox(
          child: AppFeaturesCard(
        featuresDescription: FeatureLIst.featuresList[index],
      )),
    );
  }
}
