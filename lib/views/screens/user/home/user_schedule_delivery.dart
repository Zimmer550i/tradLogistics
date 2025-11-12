import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/utils/formatter.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/screens/user/home/user_finding_driver.dart';

class UserScheduleDelivery extends StatefulWidget {
  const UserScheduleDelivery({super.key});

  @override
  State<UserScheduleDelivery> createState() => _UserScheduleDeliveryState();
}

class _UserScheduleDeliveryState extends State<UserScheduleDelivery> {
  TimeOfDay? time;
  DateTime? date;
  int payment = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Schedule Your Delivery"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              CustomTextField(
                onTap: () async {
                  final temp = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  );

                  setState(() {
                    date = temp;
                  });
                },
                leading: "assets/icons/calendar.svg",
                hintText: "Select Date",
                trailing: "assets/icons/drop_down.svg",
                controller: date == null
                    ? null
                    : TextEditingController(
                        text: Formatter.dateFormatter(date!),
                      ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                onTap: () async {
                  final temp = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  setState(() {
                    time = temp;
                  });
                },
                leading: "assets/icons/clock.svg",
                hintText: "Select Time",
                trailing: "assets/icons/drop_down.svg",
                controller: time == null
                    ? null
                    : TextEditingController(
                        text: Formatter.timeFormatter(time: time),
                      ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Payment methode",
                  style: AppTexts.txlm,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    payment = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.neutral.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: payment == 0
                        ? Border.all(width: 2, color: AppColors.blue)
                        : null,
                  ),
                  child: Row(
                    children: [
                      CustomSvg(asset: "assets/icons/cash.svg"),
                      const SizedBox(width: 8),
                      Text("Cash", style: AppTexts.tsmr),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    payment = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.neutral.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: payment == 1
                        ? Border.all(width: 2, color: AppColors.blue)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/stripe.png",
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      Text("Stripe", style: AppTexts.tsmr),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              CustomButton(
                onTap: () {
                  Get.to(() => UserFindingDriver());
                },
                text: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
