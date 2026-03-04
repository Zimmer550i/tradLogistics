import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/auth_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/image_picker_widget.dart';

class DriverVehicleInformation extends StatefulWidget {
  const DriverVehicleInformation({super.key});

  @override
  State<DriverVehicleInformation> createState() =>
      _DriverVehicleInformationState();
}

class _DriverVehicleInformationState extends State<DriverVehicleInformation> {
  final _authController = Get.find<AuthController>();

  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final plateCtrl = TextEditingController();
  final colorCtrl = TextEditingController();

  String? selectedVehicleType;
  File? vehicleImage;

  bool get _canSubmit =>
      selectedVehicleType != null &&
      brandCtrl.text.isNotEmpty &&
      modelCtrl.text.isNotEmpty &&
      plateCtrl.text.isNotEmpty &&
      colorCtrl.text.isNotEmpty;

  @override
  void dispose() {
    brandCtrl.dispose();
    modelCtrl.dispose();
    plateCtrl.dispose();
    colorCtrl.dispose();
    super.dispose();
  }

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
                  onChanged: (val) {
                    setState(() {
                      selectedVehicleType = val.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Brand",
                  hintText: "Enter the brand of your vehicle",
                  controller: brandCtrl,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Model",
                  hintText: "Enter the Model of your vehicle",
                  controller: modelCtrl,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Lisend Plate Number",
                  hintText: "Enter your official registration number",
                  controller: plateCtrl,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Vehicle Color",
                  hintText: "Enter the color of your vehicle",
                  controller: colorCtrl,
                  onChanged: (_) => setState(() {}),
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
                ImagePickerWidget(
                  imageFile: vehicleImage,
                  onImagePicked: (file) {
                    setState(() {
                      vehicleImage = file;
                    });
                  },
                ),
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
           SizedBox(),
              Spacer(),
              CustomButton(
                onTap: () {
                  if (!_canSubmit) return;
                  _authController.addVehicle(
                    vehicleType: selectedVehicleType!,
                    brand: brandCtrl.text,
                    model: modelCtrl.text,
                    color: colorCtrl.text,
                    registrationNumber: plateCtrl.text,
                    image: vehicleImage,
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
