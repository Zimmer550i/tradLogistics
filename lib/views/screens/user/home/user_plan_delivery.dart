import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:template/controllers/suggestion_controller.dart';
import 'package:template/controllers/user_delivery_controller.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/screens/user/home/user_schedule_delivery.dart';
import 'package:template/views/screens/user/map/user_map.dart';

class UserPlanDelivery extends StatefulWidget {
  final int? autoFocusField;
  final ServiceType serviceType;
  const UserPlanDelivery({
    super.key,
    this.autoFocusField = 0,
    required this.serviceType,
  });

  @override
  State<UserPlanDelivery> createState() => _UserPlanDeliveryState();
}

class _UserPlanDeliveryState extends State<UserPlanDelivery> {
  final autofill = Get.find<SuggestionController>();
  final delivery = Get.find<UserDeliveryController>();

  int? vehicleTypeSelected;
  bool isFragile = false;
  int whenSend = 0;
  int payment = 0;

  bool pickingFirstLocation = true;
  final firstLocation = TextEditingController();
  final lastLocation = TextEditingController();
  final weightController = TextEditingController();
  final instructionController = TextEditingController();
  final descriptionController = TextEditingController();
  String? sensitivityLevel;
  double? pickupLat;
  double? pickupLng;
  double? dropoffLat;
  double? dropoffLng;

  Map<String, dynamic> payload = {};

  @override
  void initState() {
    super.initState();
    autofill.predictions.clear();
  }

  void generatePayload() async {
    final vehicleType = vehicleTypeSelected == null
        ? null
        : [
            VehicleType.car,
            VehicleType.bike,
            VehicleType.van,
          ][vehicleTypeSelected!];

    final weightText = weightController.text.trim();
    payload = <String, dynamic>{
      "service_type": ServiceTypeHelper.toJson(widget.serviceType),
      "vehicle_type": vehicleType == null
          ? null
          : VehicleTypeHelper.toJson(vehicleType),
      "pickup_address": firstLocation.text.trim().isEmpty
          ? null
          : firstLocation.text.trim(),
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "dropoff_address": lastLocation.text.trim().isEmpty
          ? null
          : lastLocation.text.trim(),
      "dropoff_lat": dropoffLat,
      "dropoff_lng": dropoffLng,
      "weight": weightText.isEmpty ? null : double.tryParse(weightText),
      "description": descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      "special_instruction": instructionController.text.trim().isEmpty
          ? null
          : instructionController.text.trim(),
      "sensitivity_level": sensitivityLevel?.toLowerCase(),
      "fragile": isFragile,
      "scheduled_at": null,
      "payment_method": payment == 0
          ? PaymentMethodHelper.toJson(PaymentMethod.cash)
          : payment == 1
          ? PaymentMethodHelper.toJson(PaymentMethod.stripe)
          : null,
    };

    debugPrint("Prepared payload: $payload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Plan Your Delivery"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CustomSvg(asset: "assets/icons/from_to.svg"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            style: AppTexts.tsmm,
                            controller: firstLocation,
                            onChanged: (value) {
                              autofill.onSearchChanged(value);
                              pickingFirstLocation = true;
                            },
                            autofocus: widget.autoFocusField == 0,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              isDense: true,
                              hintText: "From where?",
                              hintStyle: AppTexts.tsmr.copyWith(
                                color: AppColors.neutral.shade400,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.neutral.shade200,
                          ),
                          TextField(
                            style: AppTexts.tsmm,
                            controller: lastLocation,
                            onChanged: (value) {
                              autofill.onSearchChanged(value);
                              pickingFirstLocation = false;
                            },
                            autofocus: widget.autoFocusField == 1,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => autofill.predictions.isNotEmpty
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
                              autofill.selectPrediction(
                                autofill.predictions.elementAt(index),
                                pickingFirstLocation
                                    ? firstLocation
                                    : lastLocation,
                                callback: (lat, lng) {
                                  setState(() {
                                    if (pickingFirstLocation) {
                                      pickupLat = lat;
                                      pickupLng = lng;
                                    } else {
                                      dropoffLat = lat;
                                      dropoffLng = lng;
                                    }
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
                                      autofill.predictions
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
                          itemCount: autofill.predictions.length,
                        ),
                      )
                    : Container(),
              ),
              if (widget.serviceType == ServiceType.pickupDelivery)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Choose Vehicle Type", style: AppTexts.tlgr),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 12,
                      children: [
                        vehicleType("car", "Car", 0),
                        vehicleType("bike", "Bike", 1),
                        vehicleType("van", "Van", 2),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: "Weight (Optional)",
                      controller: weightController,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: "Special Instructions",
                      controller: instructionController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: "Package Description",
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 16),
                    CustomDropDown(
                      options: ["Low", "Medium", "High"],
                      hintText: "Select sensitivity level",
                      onChanged: (value) {
                        sensitivityLevel = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: isFragile,
                            activeColor: AppColors.blue,
                            side: BorderSide(color: AppColors.neutral.shade400),
                            onChanged: (val) {
                              setState(() {
                                isFragile = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("Fragile item", style: AppTexts.tmdr),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        whenToSend(context);
                      },
                      text: "Confirm & Book Delivery",
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> whenToSend(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, modalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "When do you want to send it?",
                      style: AppTexts.txlm,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.neutral.shade200),
                    const SizedBox(height: 16),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modalState(() {
                          whenSend = 0;
                        });
                      },
                      child: Row(
                        children: [
                          CustomSvg(asset: "assets/icons/clock.svg"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Send Now", style: AppTexts.tlgr),
                                Text(
                                  "We’ll find the nearest driver right away",
                                  style: AppTexts.txsr.copyWith(
                                    color: AppColors.neutral.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSvg(
                            asset:
                                "assets/icons/radio${whenSend == 0 ? "_selected" : ""}.svg",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Divider(color: AppColors.neutral.shade200),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modalState(() {
                          whenSend = 1;
                        });
                      },
                      child: Row(
                        children: [
                          CustomSvg(asset: "assets/icons/calendar.svg"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Schedule for Later",
                                  style: AppTexts.tlgr,
                                ),
                                Text(
                                  "Pick a date and time that works for you",
                                  style: AppTexts.txsr.copyWith(
                                    color: AppColors.neutral.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSvg(
                            asset:
                                "assets/icons/radio${whenSend == 1 ? "_selected" : ""}.svg",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        if (whenSend == 0) {
                          Get.back();
                          paymentMethod(context);
                        } else if (whenSend == 1) {
                          Get.back();
                          generatePayload();
                          Get.to(() => UserScheduleDelivery(payload: payload));
                        }
                      },
                      text: "Next",
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> paymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, modalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Payment methode",
                      style: AppTexts.txlm,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.neutral.shade200),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        modalState(() {
                          payment = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: payment == 0
                              ? Border.all(width: 2, color: AppColors.blue)
                              : null,
                        ),
                        child: Row(
                          children: [
                            CustomSvg(asset: "assets/icons/cash.svg"),
                            const SizedBox(width: 8),
                            Text("Cash", style: AppTexts.tsmr),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        modalState(() {
                          payment = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: payment == 1
                              ? Border.all(width: 2, color: AppColors.blue)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/stripe.png",
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            Text("Stripe", style: AppTexts.tsmr),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    Obx(
                      () => CustomButton(
                        onTap: () {
                          generatePayload();
                          delivery.createDelivery(payload);
                          delivery.currentDelivery.value = null;
                          late final StreamSubscription pageChangeListener;
                          pageChangeListener = delivery.currentDelivery.listen((
                            val,
                          ) {
                            Get.to(() => UserMap());
                            pageChangeListener.cancel();
                          });
                        },
                        isLoading: delivery.isLoading.value,
                        text: "Find Driver",
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Expanded vehicleType(String icon, String name, int pos) {
    bool isSelected = vehicleTypeSelected == pos;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (vehicleTypeSelected == pos) {
            setState(() {
              vehicleTypeSelected = null;
            });
          } else {
            setState(() {
              vehicleTypeSelected = pos;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neutral.shade200,
            border: Border.all(
              width: 2,
              color: isSelected ? AppColors.blue : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvg(asset: "assets/icons/$icon.svg", size: 40),
              Text(
                name,
                style: AppTexts.tsmr.copyWith(
                  color: AppColors.neutral.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
