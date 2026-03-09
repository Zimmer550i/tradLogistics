import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/controllers/wallet_controller.dart';
import 'package:template/storage/storage_service.dart';
import 'package:template/utils/app_colors.dart';
import 'package:template/utils/app_texts.dart';
import 'package:template/utils/custom_svg.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:template/views/base/custom_drop_down.dart';
import 'package:template/views/base/custom_text_field.dart';

class DriverWithdraw extends StatefulWidget {
  const DriverWithdraw({super.key});

  @override
  State<DriverWithdraw> createState() => _DriverWithdrawState();
}

class _DriverWithdrawState extends State<DriverWithdraw> {
  final wallet = Get.find<WalletController>();
  final storage = StorageService();
  final amountController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchController = TextEditingController();
  final swiftCodeController = TextEditingController();
  final accountNumberController = TextEditingController();

  bool saveBankInfo = true;
  int paymentInterval = -1;
  String accountType = "Savings";

  @override
  void initState() {
    super.initState();
    _fillSavedBankInfo();
  }

  void _fillSavedBankInfo() {
    final bankName = storage.getWithdrawBankName() ?? '';
    final branch = storage.getWithdrawBranch() ?? '';
    final swiftCode = storage.getWithdrawSwiftCode() ?? '';
    final accountNumber = storage.getWithdrawAccountNumber() ?? '';
    final savedAccountType = storage.getWithdrawAccountType();

    bankNameController.text = bankName;
    branchController.text = branch;
    swiftCodeController.text = swiftCode;
    accountNumberController.text = accountNumber;
    if (savedAccountType == "Savings" || savedAccountType == "Checking") {
      accountType = savedAccountType!;
    }
    saveBankInfo =
        bankName.isNotEmpty ||
        branch.isNotEmpty ||
        swiftCode.isNotEmpty ||
        accountNumber.isNotEmpty;
  }

  @override
  void dispose() {
    amountController.dispose();
    bankNameController.dispose();
    branchController.dispose();
    swiftCodeController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Withdraw"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            spacing: 12,
            children: [
              const SizedBox(),
              CustomTextField(
                title: "Amount",
                controller: amountController,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                title: "Bank Name",
                controller: bankNameController,
              ),
              CustomTextField(title: "Branch", controller: branchController),
              CustomTextField(
                title: "Swift/BIC Code",
                controller: swiftCodeController,
              ),
              CustomTextField(
                title: "Account Number",
                controller: accountNumberController,
              ),
              CustomDropDown(
                key: ValueKey(accountType),
                options: ["Savings", "Checking"],
                title: "Account Type",
                initialPick: accountType == "Checking" ? 1 : 0,
                onChanged: (value) {
                  accountType = value;
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    saveBankInfo = !saveBankInfo;
                  });
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IgnorePointer(
                        child: Checkbox(
                          value: saveBankInfo,
                          activeColor: AppColors.blue,
                          side: BorderSide(color: AppColors.neutral.shade400),
                          onChanged: (val) {
                            setState(() {
                              saveBankInfo = val ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("Save bank info", style: AppTexts.tmdr),
                  ],
                ),
              ),
              const SizedBox(),

              // paymentFrequency(),
              const SizedBox(height: 5),
              CustomButton(
                onTap: () async {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  final bankName = bankNameController.text.trim();
                  final branch = branchController.text.trim();
                  final swiftCode = swiftCodeController.text.trim();
                  final accountNumber = accountNumberController.text.trim();
                  // if (amount <= 0 ||
                  //     bankName.isEmpty ||
                  //     branch.isEmpty ||
                  //     swiftCode.isEmpty ||
                  //     accountNumber.isEmpty) {
                  //   return;
                  // }

                  final profile = Get.isRegistered<UserProfileController>()
                      ? Get.find<UserProfileController>().userProfile.value
                      : null;
                  final accountName =
                      "${profile?.firstName ?? ""} ${profile?.lastName ?? ""}"
                          .trim();

                  await wallet.requestWithdraw(
                    amount: amount,
                    accountName: accountName.isEmpty ? "Driver" : accountName,
                    accountNumber: accountNumber,
                    bankName: bankName,
                    branch: branch,
                    accountType: accountType,
                    swiftCode: swiftCode,
                  );
                  if (!mounted || wallet.hasError.value) return;
                  if (saveBankInfo) {
                    await Future.wait([
                      storage.saveWithdrawBankName(bankName),
                      storage.saveWithdrawBranch(branch),
                      storage.saveWithdrawSwiftCode(swiftCode),
                      storage.saveWithdrawAccountNumber(accountNumber),
                      storage.saveWithdrawAccountType(accountType),
                    ]);
                  }
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 1), () {
                        if (context.mounted) {
                          Get.back();
                          Get.back();
                        }
                      });
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomSvg(asset: "assets/icons/tick.svg"),
                              const SizedBox(height: 8),
                              Text(
                                "Withdraw request sent!",
                                style: AppTexts.tlgs,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                text: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column paymentFrequency() {
    return Column(
      spacing: 12,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("Preferred Payment Frequency", style: AppTexts.txlm),
        ),
        Text(
          "Choose how often you’d like your earnings to be transferred automatically",
          style: AppTexts.txsr.copyWith(color: AppColors.neutral.shade600),
        ),
        InkWell(
          onTap: () {
            setState(() {
              paymentInterval = 0;
            });
          },
          child: Row(
            spacing: 12,
            children: [
              CustomSvg(
                asset:
                    "assets/icons/radio${paymentInterval == 0 ? "_selected" : ""}.svg",
              ),
              Text("Weekly", style: AppTexts.tmdr),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              paymentInterval = 1;
            });
          },
          child: Row(
            spacing: 12,
            children: [
              CustomSvg(
                asset:
                    "assets/icons/radio${paymentInterval == 1 ? "_selected" : ""}.svg",
              ),
              Text("Fortnightly", style: AppTexts.tmdr),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              paymentInterval = 2;
            });
          },
          child: Row(
            spacing: 12,
            children: [
              CustomSvg(
                asset:
                    "assets/icons/radio${paymentInterval == 2 ? "_selected" : ""}.svg",
              ),
              Text("Monthly", style: AppTexts.tmdr),
            ],
          ),
        ),
      ],
    );
  }
}
