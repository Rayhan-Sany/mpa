import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app/utils/app_color.dart';

class CircularChart extends StatelessWidget {
  const CircularChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: Stack(
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
                      value: 4041,
                      color: Colors.greenAccent,
                      radius: 30, //45
                      showTitle: false,
                    ),
                    PieChartSectionData(
                        value: 3000,
                        color: AppColor.primaryColor,
                        radius: 30,
                        showTitle: false),
                    PieChartSectionData(
                      value: 1041,
                      color: const Color(0xffffb200), //Colors.grey.shade400,
                      radius: 30,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 1041,
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
                      child: const Center(
                        child: Text(
                          "3000",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
