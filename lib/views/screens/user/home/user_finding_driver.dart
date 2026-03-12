import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:template/controllers/user_delivery_controller.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/user/home/user_driver_confirmed.dart';
import 'package:template/views/screens/user/modals/cancel_delivery.dart';

class UserFindingDriver extends StatefulWidget {
  const UserFindingDriver({super.key});

  @override
  State<UserFindingDriver> createState() => _UserFindingDriverState();
}

class _UserFindingDriverState extends State<UserFindingDriver> {
  final controller = Get.find<UserDeliveryController>();
  late Timer _timer;
  late StreamSubscription pageChangeListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      controller.startSearching();
      pageChangeListener = controller.currentDelivery.listen((val) {
        if (val?.status == Status.driverAssigned) {
          Get.to(() => UserDriverConfirmed());
        }
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      controller.updateDelivery();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    pageChangeListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Finding Driver"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(flex: 1),
              Text(
                "Finding the best driver for your pickup time.",
                style: AppTexts.txlr,
              ),
              Spacer(flex: 1),
              Lottie.asset("assets/lottie/ripple.json"),
              Spacer(flex: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.neutral.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      "Cancel this Delivery?",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.neutral.shade600,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        cancelDelivery(context);
                      },
                      child: Text(
                        "Cancel Now",
                        style: AppTexts.txsr.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  Get.until((route) => route.settings.name == "/app");
                },
                text: "Back to Home",
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
