import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/profile_picture.dart';

class OrderWidget extends StatefulWidget {
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final String? primaryButtonIcon;
  final String? secondaryButtonIcon;
  final Function()? primaryAction;
  final Function()? secondaryAction;

  final bool showPersonalInfo;
  final bool showVehicleInfo;
  final bool isExpandable;
  final bool showTime;
  final bool showTripDetails;
  final bool showPriceAbove;
  final bool showPriceBelow;
  const OrderWidget({
    super.key,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.primaryAction,
    this.secondaryAction,
    this.primaryButtonIcon,
    this.secondaryButtonIcon,

    this.showPersonalInfo = true,
    this.showVehicleInfo = true,
    this.showTime = true,
    this.showTripDetails = false,
    this.showPriceAbove = false,
    this.showPriceBelow = true,
    this.isExpandable = false,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool isExpanded = false;
  bool primaryLoading = false;
  bool secondaryLoading = false;

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
          if (widget.showPersonalInfo) profileInfo(),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child:
                // If Personal Info not showing
                !widget.showPersonalInfo ||
                    // If tile is not exandable
                    !widget.isExpandable ||
                    // If tile is expandable and is expanded
                    (widget.isExpandable && isExpanded)
                ? Column(
                    spacing: 16,
                    children: [
                      if (widget.showPersonalInfo) const SizedBox(),
                      if (widget.showVehicleInfo) vehicleInfo(),

                      Row(
                        children: [
                          CustomSvg(asset: "assets/icons/from_to.svg"),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mirpur, Dhaka", style: AppTexts.tsmr),
                                const SizedBox(height: 13),
                                Text("Banani, Dhaka", style: AppTexts.tsmr),
                              ],
                            ),
                          ),
                          if (widget.showPriceAbove)
                            Text("\$120", style: AppTexts.dxsm),
                        ],
                      ),
                      if (widget.showTime)
                        Row(
                          children: [
                            CustomSvg(asset: "assets/icons/clock.svg"),
                            const SizedBox(width: 16),
                            Text("Now", style: AppTexts.tsmr),
                          ],
                        ),

                      if (widget.showPriceBelow)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("\$120", style: AppTexts.dxsm),
                        ),

                      if (widget.showTripDetails)
                        Row(
                          spacing: 8,
                          children: [
                            Text("Distance to pickup:", style: AppTexts.tmdm),
                            Text("2.3 km away", style: AppTexts.tmdr),
                          ],
                        ),
                      if (widget.showTripDetails)
                        Row(
                          spacing: 8,
                          children: [
                            Text("Est. distance:", style: AppTexts.tmdm),
                            Text("8.5 km total", style: AppTexts.tmdr),
                          ],
                        ),
                      if (widget.showTripDetails)
                        Row(
                          spacing: 8,
                          children: [
                            Text("Est. Time:", style: AppTexts.tmdm),
                            Text("~18 mins total", style: AppTexts.tmdr),
                          ],
                        ),

                      Row(
                        spacing: 16,
                        children: [
                          if (widget.secondaryButtonText != null)
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  if (widget.secondaryAction == null) return;

                                  setState(() {
                                    secondaryLoading = true;
                                  });

                                  widget.secondaryAction!();

                                  setState(() {
                                    secondaryLoading = false;
                                  });
                                },
                                text: widget.secondaryButtonText!,
                                leading: widget.secondaryButtonIcon == null
                                    ? null
                                    : "assets/icons/${widget.secondaryButtonIcon!}.svg",
                                isSecondary: true,
                                padding: 0,
                              ),
                            ),
                          if (widget.primaryButtonText != null)
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  if (widget.primaryAction == null) return;

                                  setState(() {
                                    primaryLoading = true;
                                  });

                                  widget.primaryAction!();

                                  setState(() {
                                    primaryLoading = false;
                                  });
                                },
                                text: widget.primaryButtonText!,
                                leading: widget.primaryButtonIcon == null
                                    ? null
                                    : "assets/icons/${widget.primaryButtonIcon!}.svg",
                                padding: 0,
                              ),
                            ),
                        ],
                      ),
                      // getActionButtons(),
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
          "Blue-Toyota Hiace • DHK-1243",
          style: AppTexts.tmdm.copyWith(color: AppColors.neutral.shade700),
        ),
      ],
    );
  }

  Widget profileInfo() {
    return Row(
      children: [
        ProfilePicture(image: "https://thispersondoesnotexist.com", size: 52),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rahim Uddin", style: AppTexts.txls),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvg(asset: "assets/icons/star.svg", size: 16),
                const SizedBox(width: 4),
                Text(
                  "4.9",
                  style: AppTexts.tsmr.copyWith(
                    color: AppColors.neutral,
                    // height: 1
                  ),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        Container(
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
        const SizedBox(width: 12),
        Container(
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
}
