import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/user/home/user_driver_confirmed.dart';

class UserFindingDriver extends StatelessWidget {
  const UserFindingDriver({super.key});

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
              CustomButton(
                onTap: () {
                  Get.to(() => UserDriverConfirmed());
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
