import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/config/environment.dart';
import 'package:template/controllers/auth_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/error_widget.dart';
import 'package:template/views/base/home_bar.dart';
import 'package:template/views/base/loading_widget.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:template/views/screens/common/chat.dart';
import 'package:template/views/screens/common/edit_profile.dart';
import 'package:template/views/screens/common/info.dart';
import 'package:template/views/screens/driver/profile/driver_wallet.dart';

class Account extends StatefulWidget {
  final bool isUser;
  const Account({super.key, this.isUser = true});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late final UserProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Obx(
        () => _controller.isLoading.value
            ? LoadingWidget()
            : _controller.hasError.value
            ? AppErrorWidget(
                onRetry: _controller.getUserProfile,
                message: _controller.errorMessage.value,
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SafeArea(
                  child: Obx(() {
                    final profile = _controller.userProfile.value;
                    final name = profile != null
                        ? '${profile.firstName ?? ''} ${profile.lastName ?? ''}'
                              .trim()
                        : '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfilePicture(
                          image: profile?.profileImage != null
                              ? EnvironmentConfig.imageUrl +
                                    profile!.profileImage!
                              : null,
                          size: 120,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name.isNotEmpty ? name : '—',
                              style: AppTexts.dsmm,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomButton(
                          onTap: () {
                            Get.to(() => EditProfile());
                          },
                          text: "Edit Profile",
                          leading: "assets/icons/pen.svg",
                          iconColor: AppColors.white,
                          padding: 16,
                          width: null,
                        ),
                        const SizedBox(height: 24),
                        if (widget.isUser)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Row(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => Chat(isSupport: true));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5.4,
                                            color: AppColors.black.withValues(
                                              alpha: 0.08,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        spacing: 4,
                                        children: [
                                          CustomSvg(
                                            asset: "assets/icons/support.svg",
                                          ),
                                          Text(
                                            "Support",
                                            style: AppTexts.tsmr.copyWith(
                                              color: AppColors.neutral.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => DriverWallet());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5.4,
                                            color: AppColors.black.withValues(
                                              alpha: 0.08,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        spacing: 4,
                                        children: [
                                          CustomSvg(
                                            asset: "assets/icons/wallet.svg",
                                          ),
                                          Text(
                                            "Wallet",
                                            style: AppTexts.tsmr.copyWith(
                                              color: AppColors.neutral.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        wideButtons("Terms & Conditions", "terms", () {
                          Get.to(
                            () => Info(
                              title: "Terms & Conditions",
                              endpoint: ApiEndpoints.termsAndConditions,
                            ),
                          );
                        }),
                        wideButtons("Privacy Policy", "privacy", () {
                          Get.to(
                            () => Info(
                              title: "Privacy Policy",
                              endpoint: ApiEndpoints.privacyPolicy,
                            ),
                          );
                        }),
                        wideButtons("About us", "about", () {
                          Get.to(
                            () => Info(
                              title: "About us",
                              endpoint: ApiEndpoints.aboutUs,
                            ),
                          );
                        }),
                        wideButtons("Logout", "logout", () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.neutral[50],
                            builder: (context) {
                              return SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 6.5),
                                      Container(
                                        height: 3,
                                        width: 38,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
                                          color: Color.fromRGBO(
                                            209,
                                            213,
                                            219,
                                            1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        "Are you sure you want to log out?",
                                        style: AppTexts.tlgs,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      Divider(),
                                      const SizedBox(height: 24),
                                      CustomButton(
                                        onTap: () {
                                          Get.find<AuthController>().logout();
                                        },
                                        text: "Yes, Logout",
                                      ),
                                      const SizedBox(height: 12),
                                      CustomButton(
                                        text: "Cancel",
                                        isSecondary: true,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
      ),
    );
  }

  Widget wideButtons(String name, String icon, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5.4,
                color: AppColors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Row(
            spacing: 8,
            children: [
              CustomSvg(asset: "assets/icons/$icon.svg"),
              Text(
                name,
                style: AppTexts.tlgm.copyWith(
                  color: AppColors.neutral.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
