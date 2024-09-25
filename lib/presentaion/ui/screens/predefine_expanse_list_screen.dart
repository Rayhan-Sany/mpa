import 'package:flutter/material.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';

class PredefineExpanseListScreen extends StatelessWidget {
  const PredefineExpanseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPrimaryAppBar(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Mostly Uses Expanses",
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          showPredefineExpanseList(),
        ],
      ),
    );
  }

  Expanded showPredefineExpanseList() {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          leading: SizedBox(
            height: 30,
            width: 30,
            child: Image.asset(AssetsPath.notesLogo),
          ),
          title: Text("Electric Bill", style: TextStyle(fontSize: 25)),
          trailing: Text("360",
              style: TextStyle(fontSize: 20, color: AppColor.primaryColor)),
        ),
      ),
      itemCount: 20,
      shrinkWrap: true,
    ));
  }
}
