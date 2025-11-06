import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/screens/auth/get_started.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        Duration(seconds: 1),
        () => Get.to(() => GetStarted()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center, // equivalent to 50% 50%
                radius: 0.8, // you can adjust this to match the look
                colors: [
                  Color(0xFF51C7E1), // #51C7E1 at 0%
                  Color(0xFF2496CB), // #2496CB at 57%
                  Color(0xFF0776BD), // #0776BD at 100%
                ],
                stops: [0.0, 0.57, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: CustomSvg(
              asset: "assets/icons/logo_white.svg",
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ),
      ],
    );
  }
}
