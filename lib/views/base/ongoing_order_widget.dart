import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:template/views/screens/user/modals/cancel_delivery.dart';

class OngoingOrderWidget extends StatelessWidget {
  const OngoingOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.2),
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
              Text("\$120", style: AppTexts.dxsm),
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
              Expanded(child: CustomTextField(hintText: "Message Driver")),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF51C7E1), Color(0xFF0776BD)],
                    stops: [0.012, 0.4431],
                  ),
                ),
                child: Center(
                  child: CustomSvg(
                    asset: "assets/icons/phone.svg",
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}
