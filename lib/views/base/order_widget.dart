import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/profile_picture.dart';

class OrderWidget extends StatelessWidget {
  final bool isCompleted;
  const OrderWidget({super.key, this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: AppColors.black.withValues(alpha: 0.2),
          ),
        ],
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              ProfilePicture(
                image: "https://thispersondoesnotexist.com",
                size: 52,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rahim Uddin", style: AppTexts.txls),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvg(asset: "assets/icons/star.svg", size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "4.9",
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.neutral,
                          // height: 1
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neutral.shade100,
                ),
                child: Center(
                  child: CustomSvg(
                    asset: "assets/icons/phone.svg",
                    color: AppColors.neutral.shade900,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neutral.shade100,
                ),
                child: Center(
                  child: CustomSvg(
                    asset: "assets/icons/mail.svg",
                    color: AppColors.neutral.shade900,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              CustomSvg(asset: "assets/icons/vehicle.svg"),
              const SizedBox(width: 4),
              Text(
                "Blue-Toyota Hiace • DHK-1243",
                style: AppTexts.tmdm.copyWith(
                  color: AppColors.neutral.shade700,
                ),
              ),
            ],
          ),

          Row(
            children: [
              CustomSvg(asset: "assets/icons/from_to.svg"),
              const SizedBox(width: 16),
              Column(
                children: [
                  Text("Mirpur, Dhaka", style: AppTexts.tsmr),
                  const SizedBox(height: 13),
                  Text("Banani, Dhaka", style: AppTexts.tsmr),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CustomSvg(asset: "assets/icons/clock.svg"),
              const SizedBox(width: 16),
              Text("Now", style: AppTexts.tsmr),
            ],
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("\$120", style: AppTexts.dxsm),
          ),

          isCompleted
              ? CustomButton(text: "Give a Review")
              : Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {},
                        text: "Cancel Delivery",
                        leading: "assets/icons/close.svg",
                        isSecondary: true,
                        padding: 0,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        onTap: () {},
                        text: "Start Tracking",
                        leading: "assets/icons/tracking.svg",
                        padding: 0,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
