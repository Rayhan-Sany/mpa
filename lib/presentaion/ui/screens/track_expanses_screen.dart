import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/controllers/track_expanse_screen_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/ui/screens/view_expanses_screen.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';
import 'package:mpa/widgets/circular_chart.dart';

class TrackExpansesScreen extends StatefulWidget {
  const TrackExpansesScreen({super.key});

  @override
  State<TrackExpansesScreen> createState() => _TrackExpansesScreenState();
}

class _TrackExpansesScreenState extends State<TrackExpansesScreen> {
  final trackExpanseController = Get.find<TrackExpanseScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        budgetTitleBar(context),
        const SizedBox(height: 50),
        const CircularChart(),
        const SizedBox(
          height: 26,
        ),
        pieChartExplainer(Colors.greenAccent, 'First Week'),
        pieChartExplainer(AppColor.primaryColor, '2nd Week'),
        pieChartExplainer(const Color(0xffffb200), '3rd Week'),
        pieChartExplainer(Color.fromARGB(255, 238, 83, 83), 'Last Week'),
        const Spacer(),
        Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ViewExpanses());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.textColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("View Expanses",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500))),
            ),
            const Spacer(),
          ],
        ),
        const BottomNavBar()
      ],
    ));
  }

  Widget pieChartExplainer(Color color, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: ColoredBox(color: color),
          ),
          const SizedBox(width: 10),
          Text(title),
          const Expanded(
            flex: 6,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget budgetTitleBar(BuildContext context) {
    return Row(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: const BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, right: 16, left: 16, bottom: 16),
              child: Obx(
                () {
                  return Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      amountWithTitle(
                          'Budget',
                          trackExpanseController
                                  .monthlyData?.value.totalBudget.value
                                  .toString() ??
                              '00',
                          context),
                      const Spacer(),
                      amountWithTitle('Balance', calculateBalance(), context),
                      const Spacer(),
                      amountWithTitle(
                          'Expanse',
                          trackExpanseController
                                  .monthlyData?.value.totalExpanse.value
                                  .toString() ??
                              '00',
                          context),
                    ],
                  );
                },
              )))
    ]);
  }

  Color? getBalanceAmountColor() {
    Color? color = Colors.yellow[700];
    if ((int.tryParse(calculateBalance())! <= 500)) color = Colors.red[400];
    return color;
  }

  String calculateBalance() {
    int balance =
        (trackExpanseController.monthlyData?.value.totalBudget.value ?? 0) -
            (trackExpanseController.monthlyData?.value.totalExpanse.value ?? 0);
    return balance.toString();
  }

  Widget amountWithTitle(String title, String amount, BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 3) - 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: (title != "Balance")
                    ? AppColor.textColor
                    : Colors.yellow[700],
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Flexible(
              child: Get.find<GetdataController>().isInProgress.value
                  ? const CircularProgressIndicator(
                      color: AppColor.textColor,
                    )
                  : Text(
                      amount,
                      style: TextStyle(
                          color: (title != "Balance")
                              ? AppColor.textColor
                              : getBalanceAmountColor(),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    )),
          if (title == "Balance") const Spacer(),
        ],
      ),
    );
  }
}
