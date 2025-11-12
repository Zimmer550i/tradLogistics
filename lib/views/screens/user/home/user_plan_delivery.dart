import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';
import 'package:template/views/screens/user/home/user_schedule_delivery.dart';

class UserPlanDelivery extends StatefulWidget {
  final int? autoFocusField;
  const UserPlanDelivery({super.key, this.autoFocusField});

  @override
  State<UserPlanDelivery> createState() => _UserPlanDeliveryState();
}

class _UserPlanDeliveryState extends State<UserPlanDelivery> {
  int? vehicleTypeSelected;
  bool isFragile = false;
  int whenSend = 0;
  int payment = 0;

  // final _layerLink = LayerLink();

  // OverlayEntry? _overlayEntry;
  // List<String> suggestions = [
  //   'Dhaka',
  //   'Chittagong',
  //   'Sylhet',
  //   'Khulna',
  //   'Barishal',
  // ];

  // void _showSuggestions() {
  //   final overlay = Overlay.of(context);
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       width: MediaQuery.of(context).size.width - 32,
  //       child: CompositedTransformFollower(
  //         link: _layerLink,
  //         showWhenUnlinked: false,
  //         offset: const Offset(0, 60),
  //         child: Material(
  //           elevation: 4,
  //           color: Colors.white,
  //           shadowColor: Colors.black.withValues(alpha: 0.2),
  //           borderRadius: BorderRadius.circular(10),
  //           child: ListView(
  //             padding: EdgeInsets.zero,
  //             shrinkWrap: true,
  //             children: suggestions
  //                 .map(
  //                   (s) => GestureDetector(
  //                     onTap: () {},
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: 12,
  //                         horizontal: 12,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         border: suggestions.last == s
  //                             ? null
  //                             : Border(
  //                                 bottom: BorderSide(
  //                                   width: 0.5,
  //                                   color: AppColors.neutral.shade200,
  //                                 ),
  //                               ),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Container(
  //                             height: 32,
  //                             width: 32,
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: AppColors.neutral.shade200,
  //                             ),
  //                             child: CustomSvg(
  //                               asset: "assets/icons/pin.svg",
  //                               size: 16,
  //                             ),
  //                           ),
  //                           const SizedBox(width: 10),
  //                           Text(
  //                             "Suite 18 39 Lady Musgrave",
  //                             style: AppTexts.tsmr,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   overlay.insert(_overlayEntry!);
  // }

  // void _removeOverlay() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Plan Your Delivery"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CustomSvg(asset: "assets/icons/from_to.svg"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            style: AppTexts.tsmm,
                            autofocus: widget.autoFocusField == 0,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              isDense: true,
                              hintText: "From where?",
                              hintStyle: AppTexts.tsmr.copyWith(
                                color: AppColors.neutral.shade400,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.neutral.shade200,
                          ),
                          TextField(
                            style: AppTexts.tsmm,
                            autofocus: widget.autoFocusField == 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              isDense: true,
                              hintText: "Where to?",
                              hintStyle: AppTexts.tsmr.copyWith(
                                color: AppColors.neutral.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                  vehicleType("van", "Van", 2),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 12,
                children: [
                  vehicleType("wrecker", "Wrecker", 3),
                  vehicleType("truck", "Removal Truck", 4),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(hintText: "Weight (Optional)"),
              const SizedBox(height: 16),
              CustomTextField(hintText: "Special Instructions"),
              const SizedBox(height: 16),
              CustomTextField(hintText: "Package Description"),
              const SizedBox(height: 16),
              CustomDropDown(
                options: ["Low", "Medium", "High"],
                hintText: "Select sensitivity level",
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: isFragile,
                      activeColor: AppColors.blue,
                      side: BorderSide(color: AppColors.neutral.shade400),
                      onChanged: (val) {
                        setState(() {
                          isFragile = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("Fragile item", style: AppTexts.tmdr),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                onTap: () {
                  whenToSend(context);
                },
                text: "Confirm & Book Delivery",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> whenToSend(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, modalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "When do you want to send it?",
                      style: AppTexts.txlm,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.neutral.shade200),
                    const SizedBox(height: 16),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modalState(() {
                          whenSend = 0;
                        });
                      },
                      child: Row(
                        children: [
                          CustomSvg(asset: "assets/icons/clock.svg"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Send Now", style: AppTexts.tlgr),
                                Text(
                                  "We’ll find the nearest driver right away",
                                  style: AppTexts.txsr.copyWith(
                                    color: AppColors.neutral.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSvg(
                            asset:
                                "assets/icons/radio${whenSend == 0 ? "_selected" : ""}.svg",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Divider(color: AppColors.neutral.shade200),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modalState(() {
                          whenSend = 1;
                        });
                      },
                      child: Row(
                        children: [
                          CustomSvg(asset: "assets/icons/calendar.svg"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Schedule for Later",
                                  style: AppTexts.tlgr,
                                ),
                                Text(
                                  "Pick a date and time that works for you",
                                  style: AppTexts.txsr.copyWith(
                                    color: AppColors.neutral.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSvg(
                            asset:
                                "assets/icons/radio${whenSend == 1 ? "_selected" : ""}.svg",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        if (whenSend == 0) {
                          Get.back();
                          paymentMethod(context);
                        } else if (whenSend == 1) {
                          Get.back();
                          Get.to(() => UserScheduleDelivery());
                        }
                      },
                      text: "Next",
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> paymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, modalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Payment methode",
                      style: AppTexts.txlm,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.neutral.shade200),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        modalState(() {
                          payment = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: payment == 0
                              ? Border.all(width: 2, color: AppColors.blue)
                              : null,
                        ),
                        child: Row(
                          children: [
                            CustomSvg(asset: "assets/icons/cash.svg"),
                            const SizedBox(width: 8),
                            Text("Cash", style: AppTexts.tsmr),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        modalState(() {
                          payment = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: payment == 1
                              ? Border.all(width: 2, color: AppColors.blue)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/stripe.png",
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            Text("Stripe", style: AppTexts.tsmr),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    CustomButton(onTap: () {}, text: "Continue"),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Expanded vehicleType(String icon, String name, int pos) {
    bool isSelected = vehicleTypeSelected == pos;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (vehicleTypeSelected == pos) {
            setState(() {
              vehicleTypeSelected = null;
            });
          } else {
            setState(() {
              vehicleTypeSelected = pos;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neutral.shade200,
            border: Border.all(
              width: 2,
              color: isSelected ? AppColors.blue : Colors.transparent,
            ),
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
