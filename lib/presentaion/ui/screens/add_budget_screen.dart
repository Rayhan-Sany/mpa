import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/add_budget_screen_Controller.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class AddBudgetScreen extends StatelessWidget {
  const AddBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetTEController = TextEditingController();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPrimaryAppBar(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "First Add Your Budget For This Month",
                  style: AppFontStyles.playfairDisplay700S30,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: budgetTEController,
                  decoration: InputDecoration(
                      hintText: "Budget",
                      contentPadding: EdgeInsets.only(left: 12)),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Column(
                      children: [
                        suggestBudgetAmountRow(budgetTEController,
                            valu1: "2000", valu2: "2500", valu3: "3000"),
                        SizedBox(height: 20),
                        suggestBudgetAmountRow(budgetTEController,
                            valu1: "4000", valu2: "4500", valu3: "5000")
                      ],
                    )),
                SizedBox(height: 50),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text("Add"),
                    onPressed: () {
                      onPressAddBudgetButton();
                    },
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          BottomNavBar(),
        ],
      ),
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
  void onPressAddBudgetButton() {
    final addBudgetController = Get.find<AddBudgetScreenController>();
    //addBudgetController.addBudgetForNewUser();
    addBudgetController.addBudget();
  }
}
