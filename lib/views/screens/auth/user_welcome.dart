import 'package:flutter/material.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';

class UserWelcome extends StatelessWidget {
  const UserWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width / 5,
              ),
              const SizedBox(height: 20, width: double.infinity),
              Text(
                "Welcome to\nTradLogistics",
                style: AppTexts.dmdr,
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 2),
              CustomButton(onTap: () {}, text: "Continue"),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
