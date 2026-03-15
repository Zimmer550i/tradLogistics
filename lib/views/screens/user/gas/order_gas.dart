import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/suggestion_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/screens/user/gas/price_summary.dart';
import 'package:template/models/delivery_model.dart';

class OrderGas extends StatefulWidget {
  const OrderGas({super.key});

  @override
  State<OrderGas> createState() => _OrderGasState();
}

class _OrderGasState extends State<OrderGas> {
  final suggestions = Get.find<SuggestionController>();

  int speed = -1;
  final _focusNode = FocusNode();
  final deliveryAddressController = TextEditingController();
  String? cylinderSize;
  String? brand;
  String? transactionType;
  double? pickupLat;
  double? pickupLng;
  Map<String, dynamic> payload = {};

  void onSubmit() async {
    final address = deliveryAddressController.text.trim();
    final speedVal = speed == 0
        ? "standard"
        : speed == 1
        ? "express"
        : speed == 2
        ? "urgent"
        : null;
    final cleanedCylinderSize = cylinderSize?.split(" ").first.trim();
    final cleanedTransactionType = transactionType == null
        ? null
        : transactionType == "Refil/Exchange"
        ? "refill"
        : transactionType == "New Cylinder"
        ? "new_cylinder"
        : transactionType!.toLowerCase().replaceAll(" ", "_");

    payload = <String, dynamic>{
      "service_type": ServiceTypeHelper.toJson(ServiceType.cookingGas),
      "pickup_address": address.isEmpty ? null : address,
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "scheduled_at": null,
      "payment_method": null,
      "service_data": {
        "gas": {
          "cylinder_size": cleanedCylinderSize,
          "brand": brand == null
              ? null
              : (brand == "Any Available" ? null : brand),
          "transaction_type": cleanedTransactionType,
          "delivery_speed": speedVal,
        },
      },
    };
    debugPrint("Prepared payload: $payload");

    Get.to(() => PriceSummary(payload: payload));
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
                        onChanged: suggestions.onSearchChanged,
                        controller: deliveryAddressController,
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
              Obx(
                () => suggestions.predictions.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 11,
                              color: Colors.black.withValues(alpha: 0.19),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              suggestions.selectPrediction(
                                suggestions.predictions.elementAt(index),
                                deliveryAddressController,
                                callback: (lat, lng) {
                                  setState(() {
                                    pickupLat = lat;
                                    pickupLng = lng;
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Row(
                                spacing: 10,
                                children: [
                                  CustomSvg(asset: "assets/icons/location.svg"),
                                  Expanded(
                                    child: Text(
                                      suggestions.predictions
                                          .elementAt(index)
                                          .description,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => Divider(
                            thickness: 0.5,
                            color: AppColors.neutral.shade200,
                          ),
                          itemCount: suggestions.predictions.length,
                        ),
                      )
                    : Container(),
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
                onChanged: (value) => cylinderSize = value,
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                hintText: "Select Brand",
                options: ["LGL", "GasPro", "Any Available"],
                onChanged: (value) => brand = value,
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                hintText: "Transaction Type",
                options: ["Refil/Exchange", "New Cylinder"],
                onChanged: (value) => transactionType = value,
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
