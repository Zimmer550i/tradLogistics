import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/driver/profile/driver_withdraw.dart';

class DriverWallet extends StatelessWidget {
  const DriverWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Wallet"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 5.4,
                    color: AppColors.black.withValues(alpha: 0.08),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "\$250.80",
                    style: AppTexts.dmdr.copyWith(color: AppColors.blue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Available Balance",
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onTap: () {
                Get.to(() => DriverWithdraw());
              },
              text: "Withdraw",
              trailing: "assets/icons/arrow_forward.svg",
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Withdrawal History", style: AppTexts.txlm),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4),
                child: SafeArea(
                  child: Column(
                    spacing: 12,
                    children: [
                      for (int i = 0; i < 10; i++)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 4.5,
                                color: AppColors.black.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text("10.09.2025", style: AppTexts.tmdr),
                              Spacer(),
                              Text("\$120", style: AppTexts.dxsm),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
