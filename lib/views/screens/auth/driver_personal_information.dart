import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:template/views/screens/auth/driver_vehicle_information.dart';

class DriverPersonalInformation extends StatefulWidget {
  const DriverPersonalInformation({super.key});

  @override
  State<DriverPersonalInformation> createState() =>
      _DriverPersonalInformationState();
}

class _DriverPersonalInformationState extends State<DriverPersonalInformation> {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  File? addressProof;
  File? policeRecord;
  File? profilePicture;

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
                Text("Personal Information", style: AppTexts.tlgr),
                const SizedBox(height: 24),
                Center(
                  child: ProfilePicture(
                    imageFile: profilePicture,
                    isEditable: true,
                    imagePickerCallback: (val) {
                      setState(() {
                        profilePicture = val;
                      });
                    },
                  ),
                ),
                CustomTextField(
                  title: "First Name",
                  hintText: "Enter your first name",
                  controller: firstNameCtrl,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Last Name",
                  hintText: "Enter your last name",
                  controller: lastNameCtrl,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Email",
                  hintText: "Enter your email",
                  controller: emailCtrl,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Phone Number",
                  hintText: "Enter your mobile number",
                  controller: phoneCtrl,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: "Address",
                  hintText: "Enter your full address",
                  controller: addressCtrl,
                ),
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
                        addressProof = File(result.files.single.path!);
                      });
                    }
                  },
                  title: "Proof of Address (Optional)",
                  controller: addressProof != null
                      ? TextEditingController(
                          text: addressProof!.path.split('/').last,
                        )
                      : null,
                  hintText: "Upload document",
                  trailing: "assets/icons/attach.svg",
                ),
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
                        policeRecord = File(result.files.single.path!);
                      });
                    }
                  },
                  title: "Police Record (Optional)",
                  hintText: "Upload document",
                  controller: policeRecord != null
                      ? TextEditingController(
                          text: policeRecord!.path.split('/').last,
                        )
                      : null,
                  trailing: "assets/icons/attach.svg",
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
                  Get.to(() => DriverVehicleInformation());
                },
                text: "Next",
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
