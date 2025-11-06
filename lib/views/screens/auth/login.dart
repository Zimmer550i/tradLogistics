import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/screens/auth/verification.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              Text("Enter your mobile number", style: AppTexts.tlgr),
              const SizedBox(height: 8),
              CustomTextField(hintText: "Enter mobile number"),
              const SizedBox(height: 24),
              CustomButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.neutral[50],
                    builder: (context) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 36),
                              CustomButton(
                                onTap: () {
                                  Get.back();
                                  Get.to(
                                    () => Verification(number: "01825067298"),
                                  );
                                },
                                text: "Register as User",
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                onTap: () {
                                  Get.back();
                                  Get.to(
                                    () => Verification(
                                      isDriver: true,
                                      number: "01825067298",
                                    ),
                                  );
                                },
                                text: "Register as Driver",
                                isSecondary: true,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                text: "Continue",
              ),
              const SizedBox(height: 32),
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(color: Color.fromRGBO(156, 163, 175, 1)),
                  ),
                  Text(
                    "or",
                    style: AppTexts.tsmm.copyWith(
                      color: Color.fromRGBO(156, 163, 175, 1),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Color.fromRGBO(156, 163, 175, 1)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Continue with Facebook",
                isSecondary: true,
                leading: "assets/icons/facebook.svg",
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Continue with Google",
                isSecondary: true,
                leading: "assets/icons/google.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
