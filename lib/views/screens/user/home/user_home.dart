import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/base/home_bar.dart';
import 'package:template/views/screens/user/home/user_plan_delivery.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // ignore: unused_field
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Where are we delivering today?",
                style: AppTexts.tlgm,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              onTap: () {
                Get.to(() => UserPlanDelivery(autoFocusField: 0));
              },
              leading: "assets/icons/from.svg",
              hintText: "Pick-up location",
            ),
            const SizedBox(height: 8),
            CustomTextField(
              onTap: () {
                Get.to(() => UserPlanDelivery(autoFocusField: 1));
              },
              leading: "assets/icons/to.svg",
              hintText: "Drop-off location",
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  onMapCreated: (val) => _mapController = val,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(23.00, 90.000),
                    zoom: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
