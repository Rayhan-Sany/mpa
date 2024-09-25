import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/ui/screens/predefine_expanse_list_screen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';

class ViewExpanses extends StatefulWidget {
  const ViewExpanses({super.key});

  @override
  State<ViewExpanses> createState() => _ViewExpansesState();
}

class _ViewExpansesState extends State<ViewExpanses> {
  bool isTodayIsSelected = true;

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
            child: const Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Budget",
                      style:
                          TextStyle(fontSize: 20, color: AppColor.textColor)),
                  Text(
                    " 4041",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                        color: AppColor.textColor),
                  ),
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
                const Padding(
                  padding: EdgeInsets.only(
                      top: 16.0, left: 16, right: 16, bottom: 8),
                  child: Row(children: [
                    Text("January 29",
                        style: TextStyle(
                          fontSize: 30,
                        )),
                    Spacer(),
                    Text(
                      "360",
                      style:
                          TextStyle(fontSize: 30, color: AppColor.primaryColor),
                    )
                  ]),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(AssetsPath.notesLogo),
                        ),
                        title: Text("Electric Bill",
                            style: TextStyle(fontSize: 25)),
                        trailing: Text("360",
                            style: TextStyle(
                                fontSize: 20, color: AppColor.primaryColor)),
                        subtitle: Text(isTodayIsSelected ? "Today" : "18 July",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    itemCount: 20,
                    shrinkWrap: true,
                  ),
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
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  title: const Column(
                    children: [
                      TextField(
                        enabled: true,
                        decoration: InputDecoration(
                          label: Text("Budget"),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(onPressed: () {}, child: const Text("ok")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                );
              });
        },
        style: elevatedButtonStyle,
        child: const Text("Add Budget"));
  }

  ElevatedButton addExpanseButton(BuildContext context) {
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
                        Get.to(PredefineExpanseListScreen());
                      },
                      style: elevatedButtonStyle,
                      child: const Text("Listed Expanse"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkCollection();
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

  Future<void> checkCollection() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc('q2wkpstixSc7GVgNQJW4dldg3F82')
        .collection("expanseData")
        .doc('m9RhYGWE08Wm3CbkCUeJ')
        .snapshots()
        .listen((DocumentSnapshot profileDoc) {
      final dMap = profileDoc.data() as Map<String, dynamic>;
      print(dMap);
    });
  }
}
