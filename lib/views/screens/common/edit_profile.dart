import 'package:flutter/material.dart';
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
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

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
                  image: "https://thispersondoesnotexist.com",
                  isEditable: true,
                  size: 120,
                ),
                const SizedBox(),
                CustomTextField(title: "First Name", controller: firstNameCtrl),
                CustomTextField(title: "Last Name", controller: lastNameCtrl),
                CustomTextField(title: "Phone Number", controller: phoneCtrl),
                CustomTextField(title: "Address", controller: addressCtrl),
                const SizedBox(),
                CustomButton(
                  onTap: () {
                    setState(() {});
                  },
                  text: "Save Changes",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
