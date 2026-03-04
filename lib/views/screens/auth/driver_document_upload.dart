import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/auth_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/image_picker_widget.dart';

class DriverDocumentUpload extends StatefulWidget {
  const DriverDocumentUpload({super.key});

  @override
  State<DriverDocumentUpload> createState() => _DriverDocumentUploadState();
}

class _DriverDocumentUploadState extends State<DriverDocumentUpload> {
  final _authController = Get.find<AuthController>();

  File? licenseFront;
  File? licenseBack;
  File? vehicleRegistration;
  File? nationalIdFront;
  File? nationalIdBack;

  bool get _canSubmit =>
      licenseFront != null &&
      licenseBack != null &&
      vehicleRegistration != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Text("Documents Verification", style: AppTexts.tlgr),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Driving License (Front)",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(
                imageFile: licenseFront,
                onImagePicked: (file) {
                  setState(() {
                    licenseFront = file;
                  });
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Driving License (Back)",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(
                imageFile: licenseBack,
                onImagePicked: (file) {
                  setState(() {
                    licenseBack = file;
                  });
                },
              ), const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "National ID - Front (Optional)",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(
                imageFile: nationalIdFront,
                onImagePicked: (file) {
                  setState(() {
                    nationalIdFront = file;
                  });
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "National ID - Back (Optional)",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(
                imageFile: nationalIdBack,
                onImagePicked: (file) {
                  setState(() {
                    nationalIdBack = file;
                  });
                },
              ),
           
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Vehicle Registration",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(
                imageFile: vehicleRegistration,
                onImagePicked: (file) {
                  setState(() {
                    vehicleRegistration = file;
                  });
                },
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
                  if (!_canSubmit) return;
                  _authController.uploadDocuments(
                    drivingLicenseFront: licenseFront!,
                    drivingLicenseBack: licenseBack!,
                    vehicleRegistration: vehicleRegistration!,
                    nationalIdFront: nationalIdFront,
                    nationalIdBack: nationalIdBack,
                  );
                },
                text: "Submit",
                padding: 0,
                width: 110,
                radius: 99,
                isDisabled: !_canSubmit,
                isSecondary: !_canSubmit,
                trailing: "assets/icons/arrow_forward.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
