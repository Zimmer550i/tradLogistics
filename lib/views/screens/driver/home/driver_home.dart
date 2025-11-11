import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
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
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  int state = 0;
  bool isReady = false;
  bool showingBottomCard = false;
  bool runningTrip = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Geolocator.getPositionStream().listen((Position position) {
      debugPrint('${position.latitude}, ${position.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (val) => _mapController = val,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(23.00, 90.000),
              zoom: 10,
            ),
          ),
          if (isReady && showingBottomCard)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.22)),
            ),
          if (!runningTrip)
            Positioned(
              top: 24,
              right: 16,
              child: CustomButton(
                onTap: () {
                  setState(() {
                    isReady = !isReady;
                    showingBottomCard = false;
                    state = 0;
                  });
                },
                text: "Ready to Ride",
                padding: 20,
                isSecondary: !isReady,
                width: null,
                leading: "assets/icons/switch_${isReady ? "on" : "off"}.svg",
              ),
            ),
          if (!isReady)
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
          if (isReady && !showingBottomCard && !runningTrip)
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    showingBottomCard = true;
                  });
                },
                child: Lottie.asset("assets/lottie/hourglass.json"),
              ),
            ),

          if (isReady && (showingBottomCard || runningTrip))
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
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the location
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition!),
        duration: Duration(seconds: 5),
      );
    });
  }
}
