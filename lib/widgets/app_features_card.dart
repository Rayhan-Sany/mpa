import 'package:flutter/material.dart';
import '../app/utils/app_color.dart';

class AppFeaturesCard extends StatelessWidget {
  const AppFeaturesCard({super.key, required this.featuresDescription});
  final Map<String, String> featuresDescription;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        color: AppColor.primaryColor,
        shadowColor: Colors.purpleAccent,
        elevation: 7,
        child: Container(
          height: (deviceSize.width / 2) - 10,
          width: (deviceSize.width / 2) - 10,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 15),
            child: Column(
              children: [
                Spacer(),
                Image.asset(
                  featuresDescription['Logo'] ?? '',
                  height: 100,
                ),
                Spacer(),
                Text(
                  featuresDescription['Name'] ?? '',
                  style: TextStyle(fontSize: 20, color: AppColor.textColor),
                )
              ],
            ),
          ),
        ));
  }
}
