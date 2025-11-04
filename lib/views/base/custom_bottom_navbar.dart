import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int index;
  final Function(int) onChanged;
  final bool isUser;
  const CustomBottomNavbar({
    super.key,
    this.isUser = true,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: AppColors.white),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onChanged,
        selectedItemColor: AppColors.blue,
        unselectedLabelStyle: AppTexts.txsm,
        selectedLabelStyle: AppTexts.txsm,
        items: [
          BottomNavigationBarItem(
            icon: CustomSvg(asset: "assets/icons/home.svg"),
            activeIcon: CustomSvg(asset: "assets/icons/home_active.svg"),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: CustomSvg(asset: "assets/icons/orders.svg"),
            activeIcon: CustomSvg(asset: "assets/icons/orders_active.svg"),
            label: "Orders",
          ),
          if(!isUser)
          BottomNavigationBarItem(
            icon: CustomSvg(asset: "assets/icons/earnings.svg"),
            activeIcon: CustomSvg(asset: "assets/icons/earnings_active.svg"),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: CustomSvg(asset: "assets/icons/mail.svg"),
            activeIcon: CustomSvg(asset: "assets/icons/mail_active.svg"),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: CustomSvg(asset: "assets/icons/user.svg"),
            activeIcon: CustomSvg(asset: "assets/icons/user_active.svg"),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
