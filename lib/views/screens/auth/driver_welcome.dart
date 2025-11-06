import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';

class DriverWelcome extends StatelessWidget {
  const DriverWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width / 5,
              ),
              const SizedBox(height: 20, width: double.infinity),
              Text(
                "You’re all set!",
                style: AppTexts.dmdr,
                textAlign: TextAlign.center,
              ),
              Text(
                "Start accepting delivery requests",
                style: AppTexts.txlr.copyWith(
                  color: AppColors.neutral.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 2),
              CustomButton(onTap: () {}, text: "Go Online"),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
