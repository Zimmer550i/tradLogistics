import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/views/base/home_bar.dart';
import 'package:template/views/base/profile_picture.dart';
import 'package:template/views/screens/common/chat.dart';

class Inbox extends StatelessWidget {
  const Inbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              spacing: 8,
              children: [
                const SizedBox(height: 16),
                for (int i = 0; i < 10; i++)
                  InkWell(
                    onTap: () {
                      Get.to(() => Chat());
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ProfilePicture(
                            image: "https://thispersondoesnotexist.com",
                            size: 48,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("User Name", style: AppTexts.tlgs),
                                const SizedBox(height: 4,),
                                Text(
                                  "Hi, how are you doing? Is everything going alright?",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTexts.tmdr.copyWith(
                                    color: AppColors.neutral.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "8:09 PM",
                                style: AppTexts.txsm.copyWith(
                                  color: AppColors.neutral.shade300,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "3",
                                    style: AppTexts.txsr.copyWith(
                                      color: AppColors.neutral[50],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
