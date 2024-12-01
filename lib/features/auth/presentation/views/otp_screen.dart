import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateful/otp_widget.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter OTP',
                    style: context.textTheme.headlineSmall,
                  ),
                  Gaps.v28(),
                  const OTPWidget(),
                ],
              ),
            ),
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: CustomElevatedButton(
                    text: LocaleKeys.resendOTP.tr(), onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
