import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';

Future<dynamic> cancelDelivery(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: SafeArea(
          child: StatefulBuilder(
            builder: (context, modalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to cancel this delivery?",
                    style: AppTexts.txlm,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.neutral.shade200),
                  const SizedBox(height: 16),
                  CustomButton(onTap: () {}, text: "Yes, Cancel"),
                  const SizedBox(height: 12),
                  CustomButton(onTap: () {}, text: "No", isSecondary: true),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
