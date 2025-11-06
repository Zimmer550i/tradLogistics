import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/screens/auth/driver_welcome.dart';

class DriverDocumentReview extends StatelessWidget {
  const DriverDocumentReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => DriverWelcome());
                },
                child: Lottie.asset("assets/lottie/hourglass.json"),
              ),
              Text(
                "Your documents are under review. We’ll notify you once verified",
                textAlign: TextAlign.center,
                style: AppTexts.dxsr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
