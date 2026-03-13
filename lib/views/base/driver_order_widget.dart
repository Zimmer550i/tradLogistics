import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:template/config/environment.dart';
import 'package:template/controllers/driver_delivery_controller.dart';
import 'package:template/error/error_handler.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverOrderWidget extends StatefulWidget {
  final DeliveryModel delivery;
  final bool isExpandable;
  final bool showAdditionalInfo;
  final bool isUser;
  const DriverOrderWidget({
    super.key,
    required this.delivery,
    this.isUser = false,
    this.showAdditionalInfo = false,
    this.isExpandable = false,
  });

  @override
  State<DriverOrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<DriverOrderWidget> {
  final controller = Get.find<DriverDeliveryController>();

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
          children: [
            if (Get.find<DriverDeliveryController>().isOngoing) profileInfo(),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: !widget.isExpandable || (widget.isExpandable && isExpanded)
                  ? Column(
                      spacing: 16,
                      children: [
                        if (Get.find<DriverDeliveryController>().isOngoing)
                          const SizedBox(),

                        Row(
                          children: [
                            CustomSvg(
                              asset:
                                  widget.delivery.serviceType !=
                                      ServiceType.cookingGas
                                  ? "assets/icons/from_to.svg"
                                  : "assets/icons/to.svg",
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.delivery.pickupAddress,
                                    style: AppTexts.tsmr,
                                  ),
                                  if (widget.delivery.serviceType !=
                                      ServiceType.cookingGas)
                                    Text(
                                      widget.delivery.dropoffAddress,
                                      style: AppTexts.tsmr,
                                    ),
                                ],
                              ),
                            ),
                            if (widget.delivery.status == Status.searching)
                              Text(
                                "\$${widget.delivery.price}",
                                style: AppTexts.dxsm,
                              ),
                          ],
                        ),
                        if (widget.delivery.serviceType ==
                            ServiceType.cookingGas)
                          if (widget.delivery.serviceType !=
                              ServiceType.cookingGas)
                            Row(
                              children: [
                                CustomSvg(asset: "assets/icons/clock.svg"),
                                const SizedBox(width: 16),
                                Text(
                                  DateTime.now().difference(
                                            widget.delivery.scheduledAt ??
                                                DateTime.now(),
                                          ) <
                                          Duration(hours: 1)
                                      ? "Now"
                                      : DateFormat().format(
                                          widget.delivery.scheduledAt ??
                                              DateTime.now(),
                                        ),
                                  style: AppTexts.tsmr,
                                ),
                              ],
                            ),
                        // if (widget.showPriceBelow)
                        //   Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text("\$120", style: AppTexts.dxsm),
                        //   ),
                        // TODO: Calculate these
                        if (widget.delivery.status == Status.searching)
                          Column(
                            spacing: 12,
                            children: [
                              Row(
                                spacing: 8,
                                children: [
                                  Text(
                                    "Distance to pickup:",
                                    style: AppTexts.tmdm,
                                  ),
                                  Text("2.3 km away", style: AppTexts.tmdr),
                                ],
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Text("Est. distance:", style: AppTexts.tmdm),
                                  Text("8.5 km total", style: AppTexts.tmdr),
                                ],
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Text("Est. Time:", style: AppTexts.tmdm),
                                  Text("~18 mins total", style: AppTexts.tmdr),
                                ],
                              ),
                            ],
                          ),
                        getActionButtons(),
                      ],
                    )
                  : SizedBox(height: 0, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Row vehicleInfo() {
    return Row(
      children: [
        CustomSvg(asset: "assets/icons/vehicle.svg"),
        const SizedBox(width: 4),
        Text(
          "Blue-Toyota Hiace • DHK-1243",
          style: AppTexts.tmdm.copyWith(color: AppColors.neutral.shade700),
        ),
      ],
    );
  }

  Widget profileInfo() {
    return Row(
      children: [
        ProfilePicture(
          image:
              EnvironmentConfig.imageUrl +
              widget.delivery.customer.profileImage,
          size: 52,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(widget.delivery.customer.name, style: AppTexts.txls),
        ),
        GestureDetector(
          onTap: () async {
            final Uri phoneUri = Uri(
              scheme: 'tel',
              path: widget.delivery.customer.phone,
            );

            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            } else {
              ErrorHandler.showSnackbar("Could not launch $phoneUri");
            }
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neutral.shade100,
            ),
            child: Center(
              child: CustomSvg(
                asset: "assets/icons/phone.svg",
                color: AppColors.neutral.shade900,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // TODO: Connect inbox
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.neutral.shade100,
          ),
          child: Center(
            child: CustomSvg(
              asset: "assets/icons/mail.svg",
              color: AppColors.neutral.shade900,
              size: 20,
            ),
          ),
        ),

        if (widget.isExpandable)
          GestureDetector(
            onTap: () {
              if (widget.isExpandable) {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }
            },
            child: AnimatedRotation(
              duration: Duration(milliseconds: 200),
              turns: isExpanded ? 0.5 : 1,
              child: CustomSvg(
                asset: "assets/icons/drop_down.svg",
                color: AppColors.blue,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget getActionButtons() {
    switch (widget.delivery.status) {
      case Status.driverAssigned:
        return Row(
          spacing: 12,
          children: [
            Expanded(
              child: CustomButton(
                padding: 0,
                leading: "assets/icons/close.svg",
                // onTap: () => controller.declineDelivery(),
                text: "Cancel",
                isSecondary: true,
              ),
            ),
            Expanded(
              child: CustomButton(
                padding: 0,
                leading: "assets/icons/navigate.svg",
                onTap: () {
                  // TODO: set
                  // final map = Get.find<MapsController>();
                },
                text: "Navigate",
              ),
            ),
          ],
        );
      case Status.searching:
        return Row(
          spacing: 12,
          children: [
            Expanded(
              child: CustomButton(
                onTap: () => controller.declineDelivery(),
                text: "Decline",
                isSecondary: true,
              ),
            ),
            Expanded(
              child: CustomButton(
                onTap: () => controller.acceptDelivery(),
                text: "Accept",
              ),
            ),
          ],
        );
      default:
        return Text(widget.delivery.status.toString());
    }
  }
}
