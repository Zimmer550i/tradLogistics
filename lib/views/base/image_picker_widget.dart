import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral.shade100),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSvg(
                      asset: "assets/icons/upload.svg",
                      color: AppColors.blue,
                      size: 24,
                    ),
                    Text(
                      "Select File",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.neutral.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 80, width: 0.5, color: AppColors.neutral.shade300),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSvg(
                      asset: "assets/icons/camera.svg",
                      color: AppColors.blue,
                      size: 24,
                    ),
                    Text(
                      "Capture Photo",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.neutral.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
