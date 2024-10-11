import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';
import 'package:mpa/presentaion/ui/screens/view_expanses_screen.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';
import 'package:mpa/widgets/circular_chart.dart';

class TrackExpansesScreen extends StatefulWidget {
  const TrackExpansesScreen({super.key});

  @override
  State<TrackExpansesScreen> createState() => _TrackExpansesScreenState();
}

class _TrackExpansesScreenState extends State<TrackExpansesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    final userController = Get.find<UserController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          budgetTitleBar(context),
          const SizedBox(height: 50),
          const CircularChart(),
          const SizedBox(
            height: 20,
          ),
          pieChartExplainer(Colors.greenAccent, 'Balance'),
          pieChartExplainer(AppColor.primaryColor, 'Amount'),
          pieChartExplainer(const Color(0xffffb200), 'Amount'),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(ViewExpanses());
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
      ),
    );
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
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                amountWithTitle('Budget', '4041', context),
                const Spacer(),
                amountWithTitle('Balance', '3000', context),
                const Spacer(),
                amountWithTitle('Expanse', '1041', context),
              ],
            ),
          ))
    ]);
  }

  Color? getBalanceAmountColor() {
    Color? color = Colors.yellow[700];
    if (true) color = Colors.red[400];
    return color;
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
            child: Text(
              amount,
              style: TextStyle(
                  color: (title != "Balance")
                      ? AppColor.textColor
                      : getBalanceAmountColor(),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
              maxLines: 2,
            ),
          ),
          if (title == "Balance") const Spacer(),
        ],
      ),
    );
  }
}
//
// Container(
// height: 60,
// width: 60,
// margin: EdgeInsets.only(bottom: 20, right: 20),
// child: Card(
// color: AppColor.primaryColor,
// elevation: 10,
// child: Center(
// child: Icon(
// Icons.add,
// color: AppColor.textColor,
// ),
// ),
// ),
// )