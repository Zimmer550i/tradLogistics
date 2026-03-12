import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/user_delivery_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/screens/user/home/user_finding_driver.dart';
import 'package:template/models/delivery_model.dart';

class PriceSummary extends StatefulWidget {
  final Map<String, dynamic> payload;
  const PriceSummary({super.key, required this.payload});

  @override
  State<PriceSummary> createState() => _PriceSummaryState();
}

class _PriceSummaryState extends State<PriceSummary> {
  int paymentType = -1;

  void onSubmit() async {
    widget.payload["payment_method"] = paymentType == 0
        ? PaymentMethodHelper.toJson(PaymentMethod.cash)
        : paymentType == 1
        ? PaymentMethodHelper.toJson(PaymentMethod.stripe)
        // : paymentType == 2
        // ? PaymentMethodHelper.toJson(PaymentMethod.lynk)
        // : paymentType == 3
        // ? PaymentMethodHelper.toJson(PaymentMethod.jnMoney)
        : null;

    debugPrint("Updated payload: ${widget.payload}");
    final controller = Get.find<UserDeliveryController>();
    controller.createDelivery(widget.payload);

    late StreamSubscription pageChangeListener;
    pageChangeListener = controller.currentDelivery.listen((val) {
      Get.to(() => UserFindingDriver());
      pageChangeListener.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Price Summary"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Cylinder Cost",
                      style: AppTexts.tmdr.copyWith(
                        color: AppColors.neutral.shade700,
                      ),
                    ),
                  ),
                  Text(
                    "XX",
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Delivery Fee",
                      style: AppTexts.tmdr.copyWith(
                        color: AppColors.neutral.shade700,
                      ),
                    ),
                  ),
                  Text(
                    "XX",
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Speed Fee",
                      style: AppTexts.tmdr.copyWith(
                        color: AppColors.neutral.shade700,
                      ),
                    ),
                  ),
                  Text(
                    "XX",
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
              Divider(color: AppColors.neutral.shade200),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total Amount",
                      style: AppTexts.tmdr.copyWith(
                        color: AppColors.neutral.shade700,
                      ),
                    ),
                  ),
                  Text(
                    "XXX",
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.neutral.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Payment Method", style: AppTexts.tlgr),
              ),
              const SizedBox(height: 8),
              paymentMethod("Cash", "cash", 0),
              const SizedBox(height: 8),
              paymentMethod("Stripe", "stripe", 1, isPng: true),

              // const SizedBox(height: 8),
              // paymentMethod("Lynk", "lynk", 2, isPng: true),
              // const SizedBox(height: 8),
              // paymentMethod("Cash", "google", 3),
              const SizedBox(height: 100),
              CustomButton(onTap: onSubmit, text: "Confirm Order"),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentMethod(
    String title,
    String asset,
    int pos, {
    bool isPng = false,
  }) {
    return GestureDetector(
      onTap: () => setState(() {
        if (paymentType == pos) {
          paymentType = -1;
        } else {
          paymentType = pos;
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
            color: paymentType == pos ? AppColors.blue : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0xffe4e5e7).withValues(alpha: 0.24),
            ),
          ],
        ),
        child: Row(
          spacing: 8,
          children: [
            ClipOval(
              child: CustomSvg(
                asset: isPng
                    ? "assets/images/$asset.png"
                    : "assets/icons/$asset.svg",
                size: 24,
              ),
            ),
            Text(title, style: AppTexts.tsmr),
          ],
        ),
      ),
    );
  }
}
