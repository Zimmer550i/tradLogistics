import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';

class UserDriverConfirmed extends StatelessWidget {
  const UserDriverConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Driver Confirmed"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(),
              Text(
                "We’ve matched you with a trusted driver for your scheduled delivery",
                style: AppTexts.txlr,
              ),
              const SizedBox(height: 24),
              // TODO: Complete this Order Widget
              // OrderWidget(
              //   secondaryButtonText: "Cancel Delivery",
              //   secondaryButtonIcon: "close",
              //   secondaryAction: () {
              //     cancelDelivery(context);
              //   },
              //   primaryButtonText: "Message",
              //   primaryButtonIcon: "mail",
              //   primaryAction: () {
              //     Get.to(() => Chat());
              //   },
              // ),
              Spacer(flex: 8),
              Text(
                "You’ll get a reminder 5 minutes before pickup and live tracking will start automatically when the driver is en route",
                style: AppTexts.tsmr.copyWith(
                  color: AppColors.neutral.shade700,
                ),
              ),
              const SizedBox(height: 21),
              CustomButton(
                onTap: () {
                  Get.until((route) {
                    return Get.currentRoute == "/app";
                  });
                },
                text: "Back to Home",
              ),
              const SizedBox(height: 21),
            ],
          ),
        ),
      ),
    );
  }
}
