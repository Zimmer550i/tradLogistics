import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final void Function(File)? onImagePicked;

  const ImagePickerWidget({super.key, this.imageFile, this.onImagePicked});

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null && onImagePicked != null) {
      onImagePicked!(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 3,
              child: Image.file(imageFile!, fit: BoxFit.cover, width: double.infinity),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CustomSvg(
                    asset: "assets/icons/upload.svg",
                    color: AppColors.blue,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                onTap: () => _pickImage(ImageSource.gallery),
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
                onTap: () => _pickImage(ImageSource.camera),
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
