import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/ongoing_order_widget.dart';
import 'package:template/views/screens/user/modals/cancel_delivery.dart';

class UserMap extends StatefulWidget {
  const UserMap({super.key});

  @override
  State<UserMap> createState() => _UserMapState();
}

class _UserMapState extends State<UserMap> {
  Widget? deliveryInformation;

  @override
  void initState() {
    super.initState();
    deliveryInformation = findingDriver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Delivery Tracking"),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(25, 90),
              zoom: 15,
            ),
          ),
          if (deliveryInformation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(child: deliveryInformation!),
              ),
            ),
        ],
      ),
    );
  }

  Widget findingDriver() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            "Finding the best driver nearby…",
            textAlign: TextAlign.center,
            style: AppTexts.txlm,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "we’re connecting you with the nearest available driver",
              textAlign: TextAlign.center,
              style: AppTexts.tsmr.copyWith(color: AppColors.neutral),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              spacing: 8,
              children: [
                for (int i = 0; i < 5; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      color: AppColors.neutral.shade200,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                deliveryInformation = onRide();
              });
            },
            child: Lottie.asset(
              "assets/lottie/ripple.json",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.neutral.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  "Cancel this Delivery?",
                  style: AppTexts.tsmr.copyWith(
                    color: AppColors.neutral.shade600,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    cancelDelivery(context);
                  },
                  child: Text(
                    "Cancel Now",
                    style: AppTexts.txsr.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onRide() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text("Pickup in 3 min", style: AppTexts.txlm),
          const SizedBox(height: 16),
          OngoingOrderWidget(),
        ],
      ),
    );
  }
}
