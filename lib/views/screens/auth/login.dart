import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/auth_controller.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_text_field.dart';

class Login extends StatelessWidget {
    Login({super.key,required this.isUser});
   final bool isUser; 

   final AuthController _authController = Get.find<AuthController>();
    final TextEditingController _phoneController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                Text("Enter your mobile number", style: AppTexts.tlgr),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _phoneController,
                  hintText: "Enter mobile number",textInputType: TextInputType.phone,
                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter your mobile number";
                    }
                    if(value.length<10){
                      return "Please enter a valid mobile number";
                    }
                    return null;
                  },
                  ),
                const SizedBox(height: 24),
                CustomButton(
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      _authController.login(_phoneController.text,isUser);
                    }
                  },
                  text: "Continue",
                ),
                const SizedBox(height: 32),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(color: Color.fromRGBO(156, 163, 175, 1)),
                    ),
                    Text(
                      "or",
                      style: AppTexts.tsmm.copyWith(
                        color: Color.fromRGBO(156, 163, 175, 1),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Color.fromRGBO(156, 163, 175, 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Continue with Facebook",
                  isSecondary: true,
                  leading: "assets/icons/facebook.svg",
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Continue with Google",
                  isSecondary: true,
                  leading: "assets/icons/google.svg",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
