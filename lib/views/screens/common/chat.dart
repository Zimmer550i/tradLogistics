import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/profile_picture.dart';

class Chat extends StatefulWidget {
  final bool isSupport;
  const Chat({super.key, this.isSupport = false});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Widget> messages = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    getMessages();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Color.fromRGBO(52, 101, 179, 0.15),
        title: Row(
          children: [
            if (!widget.isSupport)
              ProfilePicture(
                image: "https://thispersondoesnotexist.com",
                size: 40,
              ),
            const SizedBox(width: 12),
            Text(
              widget.isSupport ? "Support" : "Jimenez Motorsports",
              style: AppTexts.tlgb,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 20),
              bottom: false,
              child: Column(
                children: [
                  ...messages,
                  SafeArea(child: const SizedBox(height: 56)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 16,
            right: 16,
            child: SafeArea(child: inputField()),
          ),
        ],
      ),
    );
  }

  Widget inputField() {
    return Container(
      height: 56,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              cursorColor: AppColors.neutral.shade900,
              onTapOutside: (event) {
                setState(() {
                  focusNode.unfocus();
                });
              },
              style: AppTexts.tsmm,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                isCollapsed: true,
                // contentPadding: EdgeInsets.zero,
                hintText: "Write your message",
                hintStyle: AppTexts.tsmr.copyWith(
                  color: AppColors.neutral.shade400,
                ),
              ),
            ),
          ),
          CustomSvg(asset: "assets/icons/send.svg"),
        ],
      ),
    );
  }

  void getMessages() {
    messages.clear();
    messages.addAll([
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
    ]);
  }

  Widget recieveMessage(
    String? messgae, {
    bool hasPrev = false,
    bool hasNext = false,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: hasPrev ? 4 : 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neutral.shade200,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(hasPrev ? 10 : 0),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (!hasPrev)
                Positioned(
                  left: -15.73,
                  top: -4,
                  child: Transform.flip(
                    flipX: true,
                    child: CustomSvg(
                      asset: "assets/icons/chat_pointer.svg",
                      color: AppColors.neutral.shade200,
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      messgae ?? "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.neutral.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "3:33 PM",
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.neutral.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendMessage(
    String? messgae, {
    bool hasPrev = false,
    bool hasNext = false,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: hasPrev ? 4 : 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(hasPrev ? 10 : 0),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (!hasPrev)
                Positioned(
                  right: -15.73,
                  top: -4,
                  child: CustomSvg(
                    asset: "assets/icons/chat_pointer.svg",
                    color: AppColors.blue,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      messgae ?? "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.neutral[50],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "3:33 PM",
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.neutral.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CustomSvg(
                      asset: "assets/icons/sent.svg",
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
