import 'package:template/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template/utils/app_texts.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? errorText;
  final String? leading;
  final String? trailing;
  final TextInputType? textInputType;
  final bool isDisabled;
  final double radius;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final bool isPassword;
  final int lines;
  final void Function()? onTap;
  const CustomTextField({
    super.key,
    this.title,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isDisabled = false,
    this.radius = 10,
    this.lines = 1,
    this.textInputType,
    this.controller,
    this.onTap,
    this.errorText,
    this.height = 46,
    this.width,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // === Configurable UI Constants ===
  final double horizontalPadding = 14;
  final double verticalPaddingMultiline = 14;
  final double titleSpacing = 4;
  final double iconSpacing = 8;
  final double iconSize = 24;
  final double errorTextPadding = 24;
  final double borderWidth = 1.0;

  final Color borderColorFocused = AppColors.blue;
  final Color borderColorUnfocused = AppColors.neutral.shade300;
  final Color hintTextColor = AppColors.neutral[300]!;
  final Color textColor = AppColors.neutral.shade900;
  final Color iconColorFocused = AppColors.blue;
  final Color iconColorUnfocused = AppColors.neutral.shade600;
  final Color titleTextColor = AppColors.neutral.shade600;
  final Color errorTextColor = AppColors.error;

  final Duration animationDuration = const Duration(milliseconds: 100);

  bool isObscured = false;
  bool isFocused = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isObscured = widget.isPassword;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(bottom: titleSpacing),
            child: Text(
              widget.title!,
              style: AppTexts.txsm.copyWith(color: titleTextColor),
            ),
          ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              if (!widget.isDisabled) {
                focusNode.requestFocus();
              }
            }
          },
          child: Container(
            height: widget.lines == 1 ? widget.height : null,
            width: widget.width,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: widget.lines == 1 ? 0 : verticalPaddingMultiline,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: isFocused ? borderColorFocused : borderColorUnfocused,
                width: borderWidth,
              ),
            ),
            child: Row(
              spacing: iconSpacing,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.leading != null)
                  SizedBox(
                    height: iconSize,
                    width: iconSize,
                    child: SvgPicture.asset(
                      widget.leading!,
                      colorFilter: ColorFilter.mode(
                        isFocused ? iconColorFocused : iconColorUnfocused,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: widget.controller,
                    maxLines: widget.lines,
                    cursorColor: borderColorFocused,
                    keyboardType: widget.textInputType,
                    obscureText: isObscured,
                    enabled: !widget.isDisabled && widget.onTap == null,
                    onTapOutside: (event) {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    style: AppTexts.tsmm.copyWith(color: textColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.hintText,
                      hintStyle: AppTexts.tsmr.copyWith(color: hintTextColor),
                    ),
                  ),
                ),
                if (widget.trailing != null)
                  SizedBox(
                    height: iconSize,
                    width: iconSize,
                    child: SvgPicture.asset(
                      widget.trailing!,
                      colorFilter: ColorFilter.mode(
                        isFocused ? iconColorFocused : iconColorUnfocused,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: SvgPicture.asset(
                        isObscured
                            ? "assets/icons/eye_off.svg"
                            : "assets/icons/eye.svg",
                        width: iconSize,
                        colorFilter: ColorFilter.mode(
                          isFocused ? iconColorFocused : iconColorUnfocused,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: errorTextPadding),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 12,
                color: errorTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
