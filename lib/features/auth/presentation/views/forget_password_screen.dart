import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateful/otp_widget.dart';
import 'package:meka/core/stateless/custom_appbar.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool isOTPWidgetShown = false;

  @override
  void dispose() {
    _controller.dispose();
    _formkey.currentState?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const CustomAppbar(),
                Gaps.vertical(context.screenHeight * 0.06),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Align(
                      alignment: context.isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(LocaleKeys.enterYourEmailPlease.tr())),
                ),
                CustomTextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    prefixPath: 'assets/svg/email.svg',
                    hintText: LocaleKeys.email.tr(),
                    obscureText: false),
                Gaps.v48(),
                CustomElevatedButton(
                    text: LocaleKeys.sendOTP.tr(),
                    width: context.screenWidth - 80.w,
                    textStyle: context.textTheme.bodyLarge!
                        .copyWith(color: Colors.white),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          isOTPWidgetShown = true;
                        });
                      }
                    }),
                if (isOTPWidgetShown) ...[
                  Gaps.vertical(context.screenHeight * 0.1),
                  Text(LocaleKeys.enterCode.tr()),
                  Gaps.vertical(context.screenHeight * 0.05),
                  const OTPWidget(),
                  Gaps.vertical(context.screenHeight * 0.05),
                  CustomElevatedButton(
                      width: context.screenWidth - 150.w,
                      textStyle: context.textTheme.bodyLarge!
                          .copyWith(color: Colors.white),
                      text: LocaleKeys.resendOTP.tr(),
                      onPressed: () {})
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
