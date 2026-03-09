import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/config/environment.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/profile_picture.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = Get.find<UserProfileController>();
  File? _image;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameCtrl.text = user.data.firstName ?? "";
    lastNameCtrl.text = user.data.lastName ?? "";
    phoneCtrl.text = user.data.phone ?? "";
    addressCtrl.text = user.data.addressText ?? "";
  }

  void onSubmit() async {
    await user.editProfile(
      firstName: firstNameCtrl.text,
      lastName: lastNameCtrl.text,
      phone: phoneCtrl.text,
      address: addressCtrl.text,
      profileImage: _image,
    );
    if (context.mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 16,
              children: [
                ProfilePicture(
                  imageFile: _image,
                  image: user.data.profileImage == null
                      ? null
                      : (EnvironmentConfig.imageUrl + user.data.profileImage!),
                  isEditable: true,
                  size: 120,
                  imagePickerCallback: (p0) {
                    setState(() {
                      _image = p0;
                    });
                  },
                ),
                const SizedBox(),
                CustomTextField(title: "First Name", controller: firstNameCtrl),
                CustomTextField(title: "Last Name", controller: lastNameCtrl),
                CustomTextField(title: "Phone Number", controller: phoneCtrl),
                CustomTextField(title: "Address", controller: addressCtrl),
                const SizedBox(),
                CustomButton(onTap: onSubmit, text: "Save Changes"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
