import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template/config/environment.dart';
import 'package:template/controllers/chat_controller.dart';
import 'package:template/controllers/driver_delivery_controller.dart';
import 'package:template/controllers/maps_controller.dart';
import 'package:template/error/error_handler.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/app.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:template/views/screens/common/chat.dart';
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
  final mapController = Get.find<MapsController>();

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (widget.delivery.status != Status.searching) profileInfo(),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: !widget.isExpandable || (widget.isExpandable && isExpanded)
                ? Column(
                    spacing: 16,
                    children: [
                      if (widget.delivery.status != Status.searching)
                        const SizedBox(),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (widget.delivery.serviceType == ServiceType.cookingGas)
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
                                Text(
                                  "${mapController.getDistance(LatLng(widget.delivery.pickupLat!, widget.delivery.pickupLng!), LatLng(widget.delivery.dropoffLat!, widget.delivery.dropoffLng!)) / 1000} km away",
                                  style: AppTexts.tmdr,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                Text("Est. distance:", style: AppTexts.tmdm),
                                Text(
                                  "${mapController.getPickupDropoffDistance()} km total",
                                  style: AppTexts.tmdr,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                Text("Est. Time:", style: AppTexts.tmdm),
                                Text(
                                  "~${mapController.getPickupDropoffDistance() ~/ 100} mins total",
                                  style: AppTexts.tmdr,
                                ),
                              ],
                            ),
                          ],
                        ),
                      Text(widget.delivery.status.toString()),
                      getActionButtons(),
                    ],
                  )
                : SizedBox(height: 0, width: double.infinity),
          ),
        ],
      ),
    );
  }

  Row vehicleInfo() {
    return Row(
      children: [
        CustomSvg(asset: "assets/icons/vehicle.svg"),
        const SizedBox(width: 4),
        Text(
          widget.delivery.vehicleType.toString(),
          style: AppTexts.tmdm.copyWith(color: AppColors.neutral.shade700),
        ),
      ],
    );
  }

  Widget profileInfo() {
    final otherParticipant = widget.isUser
        ? widget.delivery.driver
        : widget.delivery.customer;

    return Row(
      children: [
        ProfilePicture(
          image: EnvironmentConfig.imageUrl + otherParticipant!.profileImage,
          size: 52,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(otherParticipant.name, style: AppTexts.txls)),
        GestureDetector(
          onTap: () async {
            final Uri phoneUri = Uri(
              scheme: 'tel',
              path: otherParticipant.phone,
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
        GestureDetector(
          onTap: () async {
            final roomId = await Get.find<ChatController>().createConversation(
              userId: otherParticipant.userId,
              deliveryId: widget.delivery.id,
            );
            Get.find<ChatController>().roomId.value = roomId;
            Get.to(() => Chat());
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
                asset: "assets/icons/mail.svg",
                color: AppColors.neutral.shade900,
                size: 20,
              ),
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
                onTap: () async {
                  setAppTab(0);
                  final map = Get.find<MapsController>();
                  final driverController = Get.find<DriverDeliveryController>();
                  driverController.currentDelivery.value = widget.delivery;

                  await driverController.updateDelivery();
                  final delivery = driverController.data;

                  final pickupLat = delivery.pickupLat;
                  final pickupLng = delivery.pickupLng;

                  if (pickupLat == null || pickupLng == null) {
                    ErrorHandler.showSnackbar("Pickup location is unavailable");
                    return;
                  }

                  final pickup = LatLng(pickupLat, pickupLng);
                  map.setPickupLocation(pickup);

                  map.startNavigation();
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
                onTap: () =>
                    controller.acceptDelivery(widget.delivery.id.toString()),
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
