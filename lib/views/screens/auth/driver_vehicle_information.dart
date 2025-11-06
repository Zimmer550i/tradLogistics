import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/image_picker_widget.dart';
import 'package:template/views/screens/auth/driver_document_upload.dart';

class DriverVehicleInformation extends StatelessWidget {
  const DriverVehicleInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                Text("Vehicle Information", style: AppTexts.tlgr),
                const SizedBox(height: 24),
                CustomDropDown(
                  title: "Vehicle Type",
                  options: ["Bike", "Car", "Van", "Wrecker"],
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Brand",
                  hintText: "Enter the brand of your vehicle",
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Model",
                  hintText: "Enter the Model of your vehicle",
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Lisend Plate Number",
                  hintText: "Enter your official registration number",
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Color",
                  hintText: "Enter the color of your vehicle",
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    "Vehicle Photo",
                    style: AppTexts.txsm.copyWith(
                      color: AppColors.neutral.shade600,
                    ),
                  ),
                ),
                ImagePickerWidget(),
              ],
            ),
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
                  Get.to(() => DriverDocumentUpload());
                },
                text: "Submit",
                padding: 0,
                width: 110,
                radius: 99,
                trailing: "assets/icons/arrow_forward.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
