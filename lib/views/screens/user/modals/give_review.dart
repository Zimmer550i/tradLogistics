import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/profile_picture.dart';

// TODO: Make it work
Future<dynamic> giveReview(BuildContext context) {
  int value = 0;
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    "Skip",
                    style: AppTexts.tsmr.copyWith(color: AppColors.blue),
                  ),
                ),
              ),
              ProfilePicture(
                image: "https://thispersondoesnotexist.com",
                size: 52,
              ),
              Text("Rate your delivery", style: AppTexts.txls),
              StatefulBuilder(
                builder: (context, modalState) {
                  return Row(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < value; i++)
                        GestureDetector(
                          onTap: () {
                            modalState(() {
                              value = i;
                            });
                          },
                          child: CustomSvg(
                            asset: "assets/icons/star.svg",
                            size: 40,
                          ),
                        ),
                      for (int i = value; i < 5; i++)
                        GestureDetector(
                          onTap: () {
                            modalState(() {
                              value = i;
                            });
                          },
                          child: CustomSvg(
                            asset: "assets/icons/star.svg",
                            size: 40,
                          ),
                        ),
                    ],
                  );
                },
              ),
              CustomButton(
                onTap: () {
                  Get.back();
                },
                text: "Submit",
              ),
            ],
          ),
        ),
      );
    },
  );
}
