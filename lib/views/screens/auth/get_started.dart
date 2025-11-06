import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/auth/login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => _requestLocationPermission(context),
    // );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                "assets/images/delivery.png",
                width: MediaQuery.of(context).size.width / 1.8,
              ),
              const SizedBox(height: 40),
              Text(
                "Delivering trust, every mile",
                textAlign: TextAlign.center,
                style: AppTexts.dxsm,
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  Get.to(() => Login());
                },
                text: "Get Started",
                trailing: "assets/icons/arrow_forward.svg",
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _requestLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission granted")),
      );
    } else if (status.isDenied) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    } else if (status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enable location permission in settings"),
        ),
      );
      await openAppSettings();
    }
  }
}
