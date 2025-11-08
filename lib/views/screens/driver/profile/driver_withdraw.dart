import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';

class DriverWithdraw extends StatefulWidget {
  const DriverWithdraw({super.key});

  @override
  State<DriverWithdraw> createState() => _DriverWithdrawState();
}

class _DriverWithdrawState extends State<DriverWithdraw> {
  bool saveBankInfo = false;
  int paymentInterval = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Withdraw"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            spacing: 12,
            children: [
              const SizedBox(),
              CustomTextField(title: "Bank Name"),
              CustomTextField(title: "Branch"),
              CustomTextField(title: "Swift/BIC Code"),
              CustomTextField(title: "Account Number"),
              CustomDropDown(
                options: ["Savings", "Checking"],
                title: "Account Type",
              ),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: saveBankInfo,
                      activeColor: AppColors.blue,
                      side: BorderSide(color: AppColors.neutral.shade400),
                      onChanged: (val) {
                        setState(() {
                          saveBankInfo = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("Save bank info", style: AppTexts.tmdr),
                ],
              ),
              const SizedBox(),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Preferred Payment Frequency",
                  style: AppTexts.txlm,
                ),
              ),
              Text(
                "Choose how often you’d like your earnings to be transferred automatically",
                style: AppTexts.txsr.copyWith(
                  color: AppColors.neutral.shade600,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    paymentInterval = 0;
                  });
                },
                child: Row(
                  spacing: 12,
                  children: [
                    CustomSvg(
                      asset:
                          "assets/icons/radio${paymentInterval == 0 ? "_selected" : ""}.svg",
                    ),
                    Text("Weekly", style: AppTexts.tmdr),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    paymentInterval = 1;
                  });
                },
                child: Row(
                  spacing: 12,
                  children: [
                    CustomSvg(
                      asset:
                          "assets/icons/radio${paymentInterval == 1 ? "_selected" : ""}.svg",
                    ),
                    Text("Fortnightly", style: AppTexts.tmdr),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    paymentInterval = 2;
                  });
                },
                child: Row(
                  spacing: 12,
                  children: [
                    CustomSvg(
                      asset:
                          "assets/icons/radio${paymentInterval == 2 ? "_selected" : ""}.svg",
                    ),
                    Text("Monthly", style: AppTexts.tmdr),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              CustomButton(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 1), () {
                        if (context.mounted) {
                          Get.back();
                          Get.back();
                        }
                      });
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomSvg(asset: "assets/icons/tick.svg"),
                              const SizedBox(height: 8),
                              Text(
                                "Withdraw request sent!",
                                style: AppTexts.tlgs,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                text: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
