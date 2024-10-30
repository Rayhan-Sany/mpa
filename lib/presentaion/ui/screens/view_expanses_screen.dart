import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/view_expanse_screen_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';
import 'package:mpa/presentaion/ui/screens/predefine_expanse_list_screen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class ViewExpanses extends StatefulWidget {
  const ViewExpanses({super.key});

  @override
  State<ViewExpanses> createState() => _ViewExpansesState();
}

class _ViewExpansesState extends State<ViewExpanses> {
  final viewExpanseController = Get.find<ViewExpanseScreenController>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.textColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return fabButtonAlertDialog(context);
                });
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () => fetchData(),
          child: fullBodyStack(context),
        ),
      );
    });
  }

  Stack fullBodyStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColor.primaryColor,
          height: MediaQuery.of(context).size.height / 3.5,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("My Budget",
                    style: TextStyle(fontSize: 20, color: AppColor.textColor)),
                viewExpanseController.isInProgress.value
                    ? const CircularProgressIndicator(color: AppColor.textColor)
                    : Text(
                        viewExpanseController.monthlyData?.value.totalBudget
                                .toString() ??
                            "00",
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            height: 0.8,
                            color: AppColor.textColor),
                      )
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
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: Colors.white),
          child: Column(
            children: [
              const SizedBox(height: 20),
              todayOrMonthlySelectorSection(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 16, right: 16, bottom: 8),
                child: Row(children: [
                  Text(
                      "${CurrentDateTimeReturnModel.month} - ${CurrentDateTimeReturnModel.day}",
                      style: const TextStyle(
                        fontSize: 30,
                      )),
                  const Spacer(),
                  viewExpanseController.isInProgress.value
                      ? const CircularProgressIndicator()
                      : viewExpanseController.isTodayIsSelected.value
                          ? Text(
                              viewExpanseController
                                      .todaysData?.value.getTodayTotalExapanse
                                      .toString() ??
                                  "0",
                              style: const TextStyle(
                                  fontSize: 30, color: AppColor.primaryColor),
                            )
                          : Text(
                              viewExpanseController
                                      .monthlyData?.value.totalExpanse
                                      .toString() ??
                                  "0",
                              style: const TextStyle(
                                  fontSize: 30, color: AppColor.primaryColor),
                            )
                ]),
              ),
              Expanded(
                  child: viewExpanseController.isInProgress.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              leading: SizedBox(
                                height: 35,
                                width: 35,
                                child: Image.network(
                                  viewExpanseController.isTodayIsSelected.value
                                      ? viewExpanseController.todaysData?.value
                                              .expansesList[index]
                                          ["ExpanseImageUrl"]
                                      : viewExpanseController.monthlyData?.value
                                              .expansesList[index]
                                          ["ExpanseImageUrl"],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      AppSnackbar.showAppSnackbar(
                                          title: "Fetch Image Error",
                                          subtitle:
                                              "Failed : ${error.toString()}",
                                          isErrorSnak: true),
                                ),
                              ),
                              title: Text(
                                  viewExpanseController.isTodayIsSelected.value
                                      ? viewExpanseController.todaysData?.value
                                          .expansesList[index]["ExpanseCause"]
                                      : viewExpanseController.monthlyData?.value
                                          .expansesList[index]["ExpanseCause"],
                                  style: const TextStyle(fontSize: 25)),
                              trailing: Text(
                                  viewExpanseController.isTodayIsSelected.value
                                      ? viewExpanseController.todaysData?.value
                                          .expansesList[index]["ExpanseAmount"]
                                      : viewExpanseController.monthlyData?.value
                                          .expansesList[index]["ExpanseAmount"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColor.primaryColor)),
                              subtitle: Text(
                                  viewExpanseController.isTodayIsSelected.value
                                      ? "Today"
                                      : viewExpanseController.monthlyData?.value
                                              .expansesList[index]["AddedAt"]
                                              .toDate()
                                              .toString()
                                              .replaceRange(10, 23, "") ??
                                          "",
                                  style: const TextStyle(color: Colors.grey)),
                            ),
                          ),
                          itemCount:
                              viewExpanseController.isTodayIsSelected.value
                                  ? viewExpanseController.todaysData?.value
                                          .expansesList.length ??
                                      0
                                  : viewExpanseController.monthlyData?.value
                                          .expansesList.length ??
                                      0,
                          shrinkWrap: true,
                        ))
            ],
          ),
        ),
      ],
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
              viewExpanseController.onClickTodayButton();
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white54)),
                elevation: 8,
                backgroundColor: viewExpanseController.isTodayIsSelected.value
                    ? AppColor.primaryColor
                    : Colors.white,
                surfaceTintColor: viewExpanseController.isTodayIsSelected.value
                    ? AppColor.primaryColor
                    : Colors.white,
                foregroundColor: viewExpanseController.isTodayIsSelected.value
                    ? AppColor.textColor
                    : Colors.black),
            child: const Text('Today'),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              viewExpanseController.onClickMonthButton();
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white54)),
                elevation: 8,
                backgroundColor: viewExpanseController.isTodayIsSelected.value
                    ? Colors.white
                    : AppColor.primaryColor,
                surfaceTintColor: viewExpanseController.isTodayIsSelected.value
                    ? Colors.white
                    : AppColor.primaryColor,
                foregroundColor: viewExpanseController.isTodayIsSelected.value
                    ? Colors.black
                    : AppColor.textColor),
            child: const Text('This Month'),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget fabButtonAlertDialog(BuildContext context) {
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

  Widget addBudgetButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Get.to(const AddBudgetScreen());
        },
        style: elevatedButtonStyle,
        child: const Text("Add Budget"));
  }

  Widget addExpanseButton(BuildContext context) {
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
                        onClickCustomExpanseButton(context,
                            expanseCauseTEController, amountTEController);
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

  Future<dynamic> onClickCustomExpanseButton(
      BuildContext context,
      TextEditingController expanseCauseTEController,
      TextEditingController amountTEController) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text("Add Expanse", style: AppFontStyles.playfairDisplay700S30),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () =>
                  Get.find<AddExpnseController>().onClickCircularAvatarButton(),
              child: Obx(
                () {
                  return CircleAvatar(
                      radius: 30, backgroundImage: getAvatarBgImage());
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: expanseCauseTEController,
              decoration: const InputDecoration(
                  hintText: "Expanse Cause",
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountTEController,
              decoration: const InputDecoration(
                  hintText: "Amount",
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {
              viewExpanseController.onClickAddExpanseButton(
                  amountTEController.text.toString().trim(),
                  expanseCauseTEController.text.toString());
              Navigator.pop(context);
            }, child: Obx(
              () {
                return viewExpanseController.addExpanseIsInProgress.value
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            color: AppColor.textColor))
                    : const Text("Add");
              },
            ))
          ],
        ),
      ),
    );
  }

  dynamic getAvatarBgImage() {
    if (Get.find<AddExpnseController>().isPhotoSelected.value) {
      return FileImage(Get.find<AddExpnseController>().expanseImageFile!);
    } else {
      return AssetImage(AssetsPath.expanseLogo);
    }
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

  Future<void> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 40));
    await viewExpanseController.getMonthlyData();
    await viewExpanseController.getTodaysData();
  }
}
