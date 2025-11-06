import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/image_picker_widget.dart';
import 'package:template/views/screens/auth/driver_document_review.dart';

class DriverDocumentUpload extends StatefulWidget {
  const DriverDocumentUpload({super.key});

  @override
  State<DriverDocumentUpload> createState() => _DriverDocumentUploadState();
}

class _DriverDocumentUploadState extends State<DriverDocumentUpload> {
  File? regDoc;

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
                  "Driving License",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(),
              const SizedBox(height: 12),
              ImagePickerWidget(),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "National ID (Optional)",
                  style: AppTexts.txsm.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
              ),
              ImagePickerWidget(),
              const SizedBox(height: 12),
              ImagePickerWidget(),
              const SizedBox(height: 12),
              CustomTextField(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                      );
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      regDoc = File(result.files.single.path!);
                    });
                  }
                },
                title: "Registration Document",
                hintText: "Upload document",
                controller: regDoc != null
                    ? TextEditingController(text: regDoc!.path.split('/').last)
                    : null,
                trailing: "assets/icons/attach.svg",
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
                  Get.to(() => DriverDocumentReview());
                },
                text: "Submit",
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
