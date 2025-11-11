import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/home_bar.dart';
import 'package:template/views/base/order_widget.dart';

class Orders extends StatefulWidget {
  final bool canSeePast;
  const Orders({super.key, this.canSeePast = true});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (widget.canSeePast)
            Row(
              spacing: 16,
              children: [
                const SizedBox(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: 48,
                      decoration: BoxDecoration(
                        border: index == 0
                            ? Border(bottom: BorderSide(color: AppColors.blue))
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Ongoing",
                          style: AppTexts.tmdm.copyWith(
                            fontWeight: index == 0 ? FontWeight.bold : null,
                            color: index == 0
                                ? AppColors.blue
                                : AppColors.neutral.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: 48,
                      decoration: BoxDecoration(
                        border: index == 1
                            ? Border(bottom: BorderSide(color: AppColors.blue))
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Past",
                          style: AppTexts.tmdm.copyWith(
                            fontWeight: index == 1 ? FontWeight.bold : null,
                            color: index == 1
                                ? AppColors.blue
                                : AppColors.neutral.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                children: [
                  const SizedBox(),
                  for (int i = 0; i < 10; i++)
                    OrderWidget(
                      primaryButtonText: "Start Tracking",
                      primaryButtonIcon: "tracking",
                      secondaryButtonText: "Cancel Delivery",
                      secondaryButtonIcon: "close",
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
