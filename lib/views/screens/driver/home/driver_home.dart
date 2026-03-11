import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:template/controllers/driver_delivery_controller.dart';
import 'package:template/controllers/maps_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/order_widget.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}
class _DriverHomeState extends State<DriverHome> {
  final controller = Get.find<DriverDeliveryController>();
  final mapsController = Get.find<MapsController>();
  int state = 0;
  bool showingBottomCard = false;
  bool runningTrip = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapsController.initLocation();
    });
  }

  @override
  void dispose() {
    mapsController.stopLocationUpdates();
    mapsController.clearMapController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPosition = mapsController.currentPosition.value;
      if (currentPosition == null) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator(color: AppColors.blue)),
        );
      }

      return SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: mapsController.setMapController,
              myLocationEnabled: mapsController.locationPermissionGranted.value,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 17,
              ),
            ),
            if (controller.isOnline.value && showingBottomCard)
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.22)),
              ),
            if (!runningTrip)
              Positioned(
                top: 24,
                right: 16,
                child: CustomButton(
                  onTap: () {
                    controller.toggleAvailability();
                  },
                  text: "Ready to Ride",
                  padding: 20,
                  isSecondary: !controller.isOnline.value,
                  width: null,
                  leading:
                      "assets/icons/switch_${controller.isOnline.value ? "on" : "off"}.svg",
                ),
              ),
            if (!controller.isOnline.value)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.white),
                  child: Row(
                    spacing: 8,
                    children: [
                      CustomSvg(asset: "assets/icons/offline.svg"),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You’re currently offline",
                              style: AppTexts.txlm,
                            ),
                            Text(
                              "Tap to start receiving nearby delivery requests",
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.neutral.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.isOnline.value && !showingBottomCard && !runningTrip)
              IgnorePointer(
                ignoring: true,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        showingBottomCard = true;
                      });
                    },
                    child: Lottie.asset("assets/lottie/ripple.json"),
                  ),
                ),
              ),
            if (controller.isOnline.value && (showingBottomCard || runningTrip))
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: runningTrip ? null : 30,
                top: runningTrip ? 24 : null,
                left: 16,
                right: 16,
                child: [
                  OrderWidget(
                    showPersonalInfo: false,
                    showVehicleInfo: false,
                    showPriceAbove: true,
                    showPriceBelow: false,
                    showTripDetails: true,

                    primaryButtonText: "Accept",
                    primaryAction: () {
                      setState(() {
                        state++;
                      });
                    },
                    secondaryButtonText: "Decline",
                    secondaryAction: () {},
                  ),
                  OrderWidget(
                    showPersonalInfo: true,
                    showVehicleInfo: false,
                    showTripDetails: false,
                    showTime: false,
                    showPriceBelow: false,

                    primaryButtonText: "Navigate",
                    primaryButtonIcon: "tracking",
                    primaryAction: () {
                      setState(() {
                        showingBottomCard = false;
                        runningTrip = true;
                        state++;
                      });
                    },
                    secondaryButtonText: "Cancel Delivery",
                    secondaryButtonIcon: "close",
                    secondaryAction: () {
                      setState(() {
                        state--;
                      });
                    },
                  ),
                  OrderWidget(
                    showPersonalInfo: true,
                    showVehicleInfo: false,
                    showTripDetails: false,
                    showTime: false,
                    showPriceBelow: false,
                    isExpandable: true,

                    primaryButtonText: "Arive at Pickup",
                    primaryAction: () {},
                    secondaryButtonText: "Cancel Delivery",
                    secondaryButtonIcon: "close",
                    secondaryAction: () {
                      setState(() {
                        showingBottomCard = true;
                        runningTrip = false;
                        state--;
                      });
                    },
                  ),
                ][state],
              ),
          ],
        ),
      );
    });
  }
}
