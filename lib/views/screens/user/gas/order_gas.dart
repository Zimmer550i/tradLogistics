import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/screens/user/gas/price_summary.dart';

class OrderGas extends StatefulWidget {
  const OrderGas({super.key});

  @override
  State<OrderGas> createState() => _OrderGasState();
}

class _OrderGasState extends State<OrderGas> {
  int speed = -1;
  final _focusNode = FocusNode();

  void onSubmit() {
    Get.to(() => PriceSummary());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Order Cooking Gas"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Delivery Address", style: AppTexts.tlgm),
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CustomSvg(asset: "assets/icons/to.svg"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: AppTexts.tsmm,
                        autofocus: true,
                        focusNode: _focusNode,
                        onTapOutside: (event) => _focusNode.unfocus(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          hintText: "Where to?",
                          hintStyle: AppTexts.tsmr.copyWith(
                            color: AppColors.neutral.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Choose Gas", style: AppTexts.tlgr),
              ),
              const SizedBox(height: 8),
              CustomDropDown(
                hintText: "Select Cylinder Size",
                options: ["25 lb", "100 lb"],
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                hintText: "Select Brand",
                options: ["LGL", "GasPro", "Any Available"],
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                hintText: "Transaction Type",
                options: ["Refil/Exchange", "New Cylinder"],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Delivery Speed", style: AppTexts.tlgr),
              ),
              const SizedBox(height: 8),

              deliverySpeed("Standard", "Affordable & reliable", 0),
              const SizedBox(height: 12),
              deliverySpeed("Express", "Faster delivery", 1),
              const SizedBox(height: 12),
              deliverySpeed("Urgent", "Highest priority dispatch", 2),
              const SizedBox(height: 50),
              CustomButton(onTap: onSubmit, text: "Continue"),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliverySpeed(String title, String subtitle, int pos) {
    return GestureDetector(
      onTap: () => setState(() {
        if (speed == pos) {
          speed = -1;
        } else {
          speed = pos;
        }
      }),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.neutral.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: speed == pos ? AppColors.blue : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0xffe4e5e7).withValues(alpha: 0.24),
            ),
          ],
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTexts.tmdm),
            Text(
              subtitle,
              style: AppTexts.txsr.copyWith(color: AppColors.neutral.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
