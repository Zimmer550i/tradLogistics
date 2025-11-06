import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/screens/auth/user_welcome.dart';

class UserPersonalInformation extends StatelessWidget {
  const UserPersonalInformation({super.key});

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
              Text("Personal Information", style: AppTexts.tlgr),
              const SizedBox(height: 24),
              CustomTextField(
                title: "First Name",
                hintText: "Enter your first name",
              ),
              const SizedBox(height: 12),
              CustomTextField(
                title: "Last Name",
                hintText: "Enter your last name",
              ),
              const SizedBox(height: 12),
              CustomTextField(title: "Email", hintText: "Enter your email"),
              const SizedBox(height: 12),
              CustomTextField(
                title: "Phone Number",
                hintText: "Enter your mobile number",
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
                  Get.to(() => UserWelcome());
                },
                text: "Next",
                padding: 0,
                width: 90,
                radius: 99,
                // isDisabled: controller.text.length < 4,
                // isSecondary: controller.text.length < 4,
                trailing: "assets/icons/arrow_forward.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
