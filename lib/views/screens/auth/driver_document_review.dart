import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:template/controllers/auth_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';

class DriverDocumentReview extends StatelessWidget {
  DriverDocumentReview({super.key});

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Lottie.asset("assets/lottie/hourglass.json", height: 200),
              const SizedBox(height: 24),
              Text(
                "Your documents are under review",
                textAlign: TextAlign.center,
                style: AppTexts.dxsr,
              ),
              const SizedBox(height: 8),
              Text(
                "We'll notify you once verified. You can check your status anytime.",
                textAlign: TextAlign.center,
                style: AppTexts.tsmr.copyWith(
                  color: AppColors.neutral.shade500,
                ),
              ),
              const SizedBox(height: 32),
              // CustomButton(
              //   onTap: () => _authController.checkAuthAndNavigate(),
              //   text: "Check Status",
              // ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: TextButton(
            onPressed: () => _authController.logout(),
            child: Text(
              "Logout",
              style: AppTexts.tsmm.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ),
    );
  }
}
