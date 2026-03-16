import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/driver_delivery_controller.dart';
import 'package:template/controllers/user_delivery_controller.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/custom_loading.dart';
import 'package:template/views/base/driver_order_widget.dart';
import 'package:template/views/base/home_bar.dart';

class Orders extends StatefulWidget {
  final bool isUser;
  const Orders({super.key, this.isUser = true});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final userController = Get.find<UserDeliveryController>();
  final driverController = Get.find<DriverDeliveryController>();

  int index = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    if (index == 0) {
      if (widget.isUser) {
        userController.fetchOngoingDeliveries();
      } else {
        driverController.fetchOngoingDeliveries();
      }
    } else {
      userController.fetchPastDeliveries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (widget.isUser)
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
                      fetchData();
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
                      fetchData();
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
              child: Obx(
                () => Column(
                  spacing: 16,
                  children: [
                    const SizedBox(),
                    if (userController.isLoading.value ||
                        driverController.isLoading.value)
                      CustomLoading(),
                    // Using Driver Widget
                    // Because it matches best with the Design
                    // Dumb designer
                    for (var i in getList())
                      DriverOrderWidget(delivery: i, isHistory: true),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getList() {
    if (index == 0) {
      if (widget.isUser) {
        return userController.ongoingDeliveries;
      } else {
        return driverController.ongoingDeliveries;
      }
    } else {
      return userController.pastDeliveries;
    }
  }
}
