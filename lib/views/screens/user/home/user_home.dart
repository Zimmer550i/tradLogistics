import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/controllers/maps_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/home_bar.dart';
import 'package:template/views/screens/user/gas/order_gas.dart';
import 'package:template/views/screens/user/home/user_plan_delivery.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final mapsController = Get.find<MapsController>();

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
    final fallbackPosition = LatLng(23.00, 90.000);
    return Scaffold(
      appBar: HomeBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Choose Vehicle Type", style: AppTexts.tlgr),
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 12,
              children: [
                vehicleType("bike", "Bike", 0),
                vehicleType("car", "Car", 1),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                vehicleType("van", "Van", 2),
                vehicleType("wrecker", "Wrecker", 3),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                vehicleType("truck", "Removal Truck", 4),
                vehicleType("gas", "Gas Cylinder", 5),
              ],
            ),
            const SizedBox(height: 12),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Where are we delivering today?",
            //     style: AppTexts.tlgm,
            //   ),
            // ),
            // const SizedBox(height: 12),
            // CustomTextField(
            //   onTap: () {
            //     Get.to(() => UserPlanDelivery(autoFocusField: 0));
            //   },
            //   leading: "assets/icons/from.svg",
            //   hintText: "Pick-up location",
            // ),
            // const SizedBox(height: 8),
            // CustomTextField(
            //   onTap: () {
            //     Get.to(() => UserPlanDelivery(autoFocusField: 1));
            //   },
            //   leading: "assets/icons/to.svg",
            //   hintText: "Drop-off location",
            // ),
            // const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Obx(() {
                  final currentPosition =
                      mapsController.currentPosition.value ?? fallbackPosition;
                  return GoogleMap(
                    onMapCreated: mapsController.setMapController,
                    myLocationEnabled:
                        mapsController.locationPermissionGranted.value,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: currentPosition,
                      zoom: 17,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Expanded vehicleType(String icon, String name, int pos) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (name.contains("Gas")) {
            Get.to(() => OrderGas());
          } else {
            Get.to(() => UserPlanDelivery(autoFocusField: 0));
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neutral.shade200,
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
