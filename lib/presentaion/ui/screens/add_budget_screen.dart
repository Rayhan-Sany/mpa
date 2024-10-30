import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_budget_screen_controller.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class AddBudgetScreen extends StatelessWidget {
  const AddBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetTEController = TextEditingController();
    final budgetNameTEController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This will allow the Scaffold to resize when the keyboard appears
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPrimaryAppBar(
            isAppbarWithButton: false,
          ),
          Expanded(
            // Ensure that this column doesn't overflow
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "First Add Your Budget For This Month",
                      style: AppFontStyles.playfairDisplay700S30,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: budgetTEController,
                      decoration: const InputDecoration(
                          hintText: "Budget",
                          contentPadding: EdgeInsets.only(left: 12)),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: budgetNameTEController,
                      decoration: const InputDecoration(
                          hintText: "Budget Name",
                          contentPadding: EdgeInsets.only(left: 12)),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: Column(
                          children: [
                            suggestBudgetAmountRow(budgetTEController,
                                valu1: "2000", valu2: "2500", valu3: "3000"),
                            const SizedBox(height: 20),
                            suggestBudgetAmountRow(budgetTEController,
                                valu1: "4000", valu2: "4500", valu3: "5000")
                          ],
                        )),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.maxFinite,
                      child: addBudgetButton(
                          budgetTEController, budgetNameTEController),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const BottomNavBar(),
        ],
      ),
    );
  }

  Widget addBudgetButton(TextEditingController budgetTEController,
      TextEditingController budgetNameTEController) {
    return ElevatedButton(
      child: Obx(
        () => Get.find<AddBudgetScreenController>().isInProgress.value
            ? const CircularProgressIndicator(color: AppColor.textColor)
            : const Text("Add"),
      ),
      onPressed: () {
        if (budgetTEController.text.toString().trim().isNotEmpty) {
          onPressAddBudgetButton(
              budget: budgetTEController.text.toString().trim(),
              budgetName: budgetNameTEController.text.toString());
        } else {
          print("Budget Can't Be Empty");
        }
      },
    );
  }

  Widget suggestBudgetAmountRow(TextEditingController budgetTEController,
      {String? valu1, String? valu2, String? valu3}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        suggestAmountButton(budgetTEController, valu1 ?? '0'),
        suggestAmountButton(budgetTEController, valu2 ?? '0'),
        suggestAmountButton(budgetTEController, valu3 ?? "0"),
      ],
    );
  }

  Widget suggestAmountButton(
          TextEditingController budgetTEController, String value) =>
      ElevatedButton(
        onPressed: () {
          budgetTEController.value = TextEditingValue(text: value);
        },
        child: Text(value),
      );

  Future<void> onPressAddBudgetButton(
      {required String budget, String budgetName = 'UnKnown'}) async {
    final addBudgetController = Get.find<AddBudgetScreenController>();
    await addBudgetController.addBudget(budget: budget, budgetName: budgetName);

    Get.back();
  }
}
