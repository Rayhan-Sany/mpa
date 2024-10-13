import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/Data/model/single_day_data_model.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';
import 'package:mpa/presentaion/ui/screens/predefine_expanse_list_screen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';

class ViewExpanses extends StatefulWidget {
  const ViewExpanses({super.key});

  @override
  State<ViewExpanses> createState() => _ViewExpansesState();
}

class _ViewExpansesState extends State<ViewExpanses> {
  bool isTodayIsSelected = true;
  FullMonthDataModel? monthlyData;
  SingleDayDataModel? todaysData;
  @override
  void initState() {
    getMonthlyData();
    getTodaysData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.textColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return FabButtonAlertDialog(context);
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Container(
            color: AppColor.primaryColor,
            height: MediaQuery.of(context).size.height / 3.5,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Budget",
                      style:
                          TextStyle(fontSize: 20, color: AppColor.textColor)),
                  GetBuilder<GetdataController>(builder: (getdataController) {
                    return getdataController.isInProgress
                        ? const CircularProgressIndicator(
                            color: AppColor.textColor)
                        : Text(
                            monthlyData?.totalBudget.toString() ?? "00",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                height: 0.8,
                                color: AppColor.textColor),
                          );
                  }),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height / 3.5) - 15),
            height: 15 +
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 3.5,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Colors.white),
            child: Column(
              children: [
                const SizedBox(height: 20),
                todayOrMonthlySelectorSection(),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 16.0, left: 16, right: 16, bottom: 8),
                  child: Row(children: [
                    Text(
                        CurrentDateTimeReturnModel.month +
                            " - " +
                            CurrentDateTimeReturnModel.day,
                        style: TextStyle(
                          fontSize: 30,
                        )),
                    const Spacer(),
                    GetBuilder<GetdataController>(builder: (getdataController) {
                      return getdataController.isInProgress
                          ? const CircularProgressIndicator()
                          : Text(
                              monthlyData?.totalExpanse.toString() ?? "0",
                              style: const TextStyle(
                                  fontSize: 30, color: AppColor.primaryColor),
                            );
                    })
                  ]),
                ),
                Expanded(
                  child: GetBuilder<GetdataController>(
                      builder: (getdataController) {
                    return getdataController.isInProgress
                        ? Center(child: const CircularProgressIndicator())
                        : ListView.builder(
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(AssetsPath.notesLogo),
                                ),
                                title: Text(
                                    isTodayIsSelected
                                        ? todaysData?.expansesList[index]
                                            ["ExpanseCause"]
                                        : monthlyData?.expansesList[index]
                                            ["ExpanseCause"],
                                    style: TextStyle(fontSize: 25)),
                                trailing: Text(
                                    isTodayIsSelected
                                        ? todaysData?.expansesList[index]
                                            ["ExpanseAmount"]
                                        : monthlyData?.expansesList[index]
                                            ["ExpanseAmount"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColor.primaryColor)),
                                subtitle: Text(
                                    isTodayIsSelected
                                        ? "Today"
                                        : monthlyData?.expansesList[index]
                                                    ["AddedAt"]
                                                .toDate()
                                                .toString()
                                                .replaceRange(10, 23, "") ??
                                            "",
                                    style: const TextStyle(color: Colors.grey)),
                              ),
                            ),
                            itemCount: isTodayIsSelected
                                ? todaysData?.expansesList.length ?? 0
                                : monthlyData?.expansesList.length ?? 0,
                            shrinkWrap: true,
                          );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row todayOrMonthlySelectorSection() {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              isTodayIsSelected = true;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white54)),
                elevation: 8,
                backgroundColor:
                    isTodayIsSelected ? AppColor.primaryColor : Colors.white,
                surfaceTintColor:
                    isTodayIsSelected ? AppColor.primaryColor : Colors.white,
                foregroundColor:
                    isTodayIsSelected ? AppColor.textColor : Colors.black),
            child: const Text('Today'),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              isTodayIsSelected = false;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white54)),
                elevation: 8,
                backgroundColor:
                    isTodayIsSelected ? Colors.white : AppColor.primaryColor,
                surfaceTintColor:
                    isTodayIsSelected ? Colors.white : AppColor.primaryColor,
                foregroundColor:
                    isTodayIsSelected ? Colors.black : AppColor.textColor),
            child: const Text('This Month'),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  AlertDialog FabButtonAlertDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        children: [
          addExpanseButton(context),
          const SizedBox(
            height: 10,
          ),
          addBudgetButton(context),
        ],
      ),
    );
  }

  ElevatedButton addBudgetButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Get.to(const AddBudgetScreen());
        },
        style: elevatedButtonStyle,
        child: const Text("Add Budget"));
  }

  ElevatedButton addExpanseButton(BuildContext context) {
    final TextEditingController expanseCauseTEController =
        TextEditingController();
    final TextEditingController amountTEController = TextEditingController();
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(const PredefineExpanseListScreen());
                      },
                      style: elevatedButtonStyle,
                      child: const Text("Listed Expanse"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Column(
                              children: [
                                Text("Add Expanse",
                                    style: AppFontStyles.playfairDisplay700S30),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextField(
                                  controller: expanseCauseTEController,
                                  decoration: const InputDecoration(
                                      hintText: "Expanse Cause",
                                      contentPadding:
                                          EdgeInsets.only(left: 10)),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: amountTEController,
                                  decoration: const InputDecoration(
                                      hintText: "Amount",
                                      contentPadding:
                                          EdgeInsets.only(left: 10)),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(onPressed: () {
                                  Get.find<AddExpnseController>().addExpanse(
                                      amountTEController.text.toString().trim(),
                                      expanseCauseTEController.text.toString());
                                  Navigator.pop(context);
                                }, child: GetBuilder<AddExpnseController>(
                                    builder: (addExpnseController) {
                                  return addExpnseController.inProgress
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                              color: AppColor.textColor))
                                      : const Text("Add");
                                }))
                              ],
                            ),
                          ),
                        );
                      },
                      style: elevatedButtonStyle,
                      child: const Text("Custom Expanse"),
                    ),
                  ],
                ),
              );
            });
      },
      style: elevatedButtonStyle,
      child: const Text("Add Expanse"),
    );
  }

  ButtonStyle get elevatedButtonStyle {
    return ElevatedButton.styleFrom(
      foregroundColor: AppColor.textColor,
      backgroundColor: AppColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future<void> getMonthlyData() async {
    monthlyData = await Get.find<GetdataController>().getFullMonthData();
  }

  Future<void> getTodaysData() async {
    todaysData = await Get.find<GetdataController>().getSingleDayData();
  }
}
