import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/weekly_data_controller.dart';

import '../app/utils/app_color.dart';

class CircularChart extends StatelessWidget {
  const CircularChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weeklyDataController = Get.find<WeeklyDataController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 250,
            child: Obx(() {
              return Stack(
                children: [
                  PieChart(
                    //set the values of offset

                    PieChartData(
                      startDegreeOffset: 250,
                      sectionsSpace: 0,
                      centerSpaceRadius: 90, //100

                      // you can assign values according to your need
                      sections: [
                        //now we will set values
                        PieChartSectionData(
                          value: double.tryParse(
                              "${weeklyDataController.firstWeekExpancesData?.value.totalExpanse ?? 0}"),
                          color: Colors.greenAccent,
                          radius: 30, //45
                          showTitle: false,
                        ),
                        PieChartSectionData(
                            value: double.tryParse(
                                "${weeklyDataController.secondWeekExpancesData?.value.totalExpanse ?? 0}"),
                            color: AppColor.primaryColor,
                            radius: 30,
                            showTitle: false),
                        PieChartSectionData(
                          value: double.tryParse(
                              "${weeklyDataController.thirdWeekExpancesData?.value.totalExpanse ?? 0}"),
                          color:
                              const Color(0xffffb200), //Colors.grey.shade400,
                          radius: 30,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: double.tryParse(
                              "${weeklyDataController.lastWeekExpancesData?.value.totalExpanse ?? 0}"),
                          color: const Color.fromARGB(
                              255, 238, 83, 83), //Colors.grey.shade400,
                          radius: 30,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                  //now we will set position of contain
                  Positioned.fill(
                    //now perfect
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 8.0, //10
                                  spreadRadius: 8.0, //10
                                  offset: const Offset(3.0, 3.0)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${getAvarageWeeklyExpanse()}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }))
      ],
    );
  }

  double getAvarageWeeklyExpanse() {
    final weeklyDataController = Get.find<WeeklyDataController>();
    double avgWeeklyExpanse = 0;
    for (int i = 1; i <= 4; i++) {
      if (i == 1) {
        avgWeeklyExpanse +=
            weeklyDataController.firstWeekExpancesData?.value.totalExpanse ?? 0;
      } else if (i == 2) {
        avgWeeklyExpanse +=
            weeklyDataController.secondWeekExpancesData?.value.totalExpanse ??
                0;
      } else if (i == 3) {
        avgWeeklyExpanse +=
            weeklyDataController.thirdWeekExpancesData?.value.totalExpanse ?? 0;
      } else {
        avgWeeklyExpanse +=
            weeklyDataController.lastWeekExpancesData?.value.totalExpanse ?? 0;
      }
    }
    return avgWeeklyExpanse / 4;
  }
}
