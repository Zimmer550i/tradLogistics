import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/home_bar.dart';

class DriverEarnings extends StatelessWidget {
  const DriverEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.neutral.shade200,
              ),
              child: Column(
                children: [
                  Text(
                    "\$4,850",
                    style: AppTexts.txls.copyWith(color: AppColors.blue),
                  ),
                  Text(
                    "Total Earnings",
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neutral.shade200,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "18",
                          style: AppTexts.txls.copyWith(color: AppColors.blue),
                        ),
                        Text(
                          "Trips Completed",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.neutral.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neutral.shade200,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "12",
                          style: AppTexts.txls.copyWith(color: AppColors.blue),
                        ),
                        Text(
                          "Online Hours",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.neutral.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("History", style: AppTexts.txlm),
            ),

            const SizedBox(height: 12),
            for (int i = 0; i < 10; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: AppColors.black.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 12,
                    children: [
                      Row(
                        children: [
                          CustomSvg(asset: "assets/icons/from_to.svg"),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              Text("Mirpur, Dhaka", style: AppTexts.tsmr),
                              const SizedBox(height: 13),
                              Text("Banani, Dhaka", style: AppTexts.tsmr),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomSvg(asset: "assets/icons/clock.svg"),
                          const SizedBox(width: 16),
                          Text("Now", style: AppTexts.tsmr),
                        ],
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("\$120", style: AppTexts.dxsm),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
