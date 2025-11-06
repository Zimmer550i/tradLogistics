import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/auth/driver_personal_information.dart';
import 'package:template/views/screens/auth/user_personal_information.dart';

class Verification extends StatefulWidget {
  final bool isDriver;
  final String number;
  const Verification({super.key, this.isDriver = false, required this.number});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final controller = TextEditingController();
  int time = 0;

  void resendOtp() {}

  void startTimer() {
    setState(() {
      time = 10;
    });
    updateTimer();
  }

  void updateTimer() {
    if (time > 0) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          time--;
        });
        updateTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Text(
                "Enter the 4-digit code sent to you at ${widget.number}",
                style: AppTexts.tlgr,
              ),
              const SizedBox(height: 24),
              Pinput(
                length: 4,
                autofocus: true,
                controller: controller,
                onChanged: (value) {
                  setState(() {});
                },
                mainAxisAlignment: MainAxisAlignment.start,
                defaultPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tsmr,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tsmr,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: AppColors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                cursor: Container(
                  height: 16,
                  width: 1.5,
                  decoration: BoxDecoration(
                    color: AppColors.neutral.shade700,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (time > 0) return;

                  resendOtp();
                  startTimer();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.neutral.shade200,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    "I don’t received a code${time > 0 ? " (0:$time)" : ""}",
                    style: AppTexts.tsmr.copyWith(
                      color: time > 0
                          ? AppColors.neutral.shade400
                          : AppColors.neutral.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neutral.shade200,
                  ),
                  child: Center(
                    child: CustomSvg(asset: "assets/icons/back.svg", size: 32),
                  ),
                ),
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  if (widget.isDriver) {
                    Get.to(() => DriverPersonalInformation());
                  } else {
                    Get.to(() => UserPersonalInformation());
                  }
                },
                text: "Next",
                padding: 0,
                width: 90,
                radius: 99,
                isDisabled: controller.text.length < 4,
                isSecondary: controller.text.length < 4,
                trailing: "assets/icons/arrow_forward.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
