import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/views/forget_password_screen.dart';
import 'package:meka/features/auth/presentation/views/register_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vertical(context.screenHeight * 0.1),
            Center(child: SvgPicture.asset('assets/svg/app_logo.svg')),
            Gaps.vertical(context.screenHeight * 0.001),
            SvgPicture.asset('assets/svg/meka.svg'),
            Gaps.vertical(context.screenHeight * 0.05),
            CustomTextField(
                controller: _emailController,
                isLogin: true,
                obscureText: false,
                hintText: LocaleKeys.email.tr(),
                svgPath: 'assets/svg/mail.svg'),
            Gaps.vertical(context.screenHeight * 0.001),
            CustomTextField(
                controller: _passwordController,
                isLogin: true,
                obscureText: true,
                hintText: LocaleKeys.password.tr(),
                svgPath: 'assets/svg/eye.svg'),
            Gaps.vertical(context.screenHeight * 0.001),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: RichText(
                  text: TextSpan(
                    text: LocaleKeys.forgot.tr(), // The main text
                    style: context.theme.textTheme.labelLarge,
                    children: [
                      TextSpan(
                        text: '\t${LocaleKeys.clickHere.tr()}',
                        // The clickable part
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go(const ForgetPasswordScreen());
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gaps.vertical(context.screenHeight * 0.04),
            CustomElevatedButton(
              text: LocaleKeys.login.tr(),
              // height: 90.h,
              width: context.screenWidth * 0.8,
              radius: 15,
              textStyle: context.theme.textTheme.bodyLarge!
                  .copyWith(color: Colors.white),
              // color: AppCol,
              // color: AppCol,
              onPressed: () {},
            ),
            Gaps.vertical(context.screenHeight * 0.02),
            Gaps.vertical(context.screenHeight * 0.03),
            Text(LocaleKeys.continueWith.tr()),
            // Gaps.vertical(context.screenHeight * 0.001),
            Gaps.vertical(context.screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Platform.isIOS) ...[
                    InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/svg/apple.svg',
                          width: 60.w,
                        )),
                    Gaps.h48()
                  ],
                  InkWell(
                      onTap: () {
                        context.read<AuthBloc>().googleSignIn(0, 'user');
                      },
                      child: SvgPicture.asset(
                        'assets/svg/google.svg',
                        width: 60.w,
                      )),
                  Gaps.h48(),
                  InkWell(
                      onTap: () {
                        ApiConsumer apiConsumer = sl<ApiConsumer>();
                        const fcmToken = 'fWq_BTniSdGs9oKpchPFkj:APA91bFIcJ3WA0x85ZPPlonu_ZlPOFU_RBIlSCtwNbJO5EY2YlXXEkSKnsZJd2M5iL3BFuGoMH9jfw-2QE7mHA3rOh5lVnpwGJMiGmDwvRB5uPKEkvFik6I';
                        const serverToken = 'ya29.c.c0ASRK0GYNNzMYrgSg6r1Pi5t9FXmkAzIu_zQky41qud191eSv5uPgKOoB8ZJovHtihi23lqH-IJEZ9I9Mcw0_5vuIWr1anrT3eAFk2rgNFpTo40SSY8W340Mf_mz-YmKYjNP6qOz_ioOoPUUeT6CB6K4FQ6Lk0qRWnjNugtdi6GQv0RRI380iOuGNxPfYCiPvnVbQa7O5U_MEPoijkwwOdE2WAgpkjqkVR2SsIoXZiLfUIw2bXgU3hlbcx91e3MSy9GN5nmPHuE8FouSteOXQH2SgRyRh2NfT6dkoq3mmRxaeQ2-TaSCn0GiYdmpygQSc2DRTOIqxp8aJW8_d-orG1CS24B77vKJRl9snq7mV7I29sl31d-qNeQqhMwG387AnZVWXlm_ibrkY9OZ7SXnQ-BFVlz6bB_UrOZeYMsckX-c7M-1oaOBxvItoIxZ5qhqglOQmBhQwOBXt1w9c07jzs5t-XiwgOkbWXrshi_y6vy0WasY1Zwxn28oqbRwiSaMxq0BzsROfWZWej9sdZgiVleQUpVojJZ_ZMp2dd49R2YeVvttjcbWt6zQt1twyaF8VsUJutkkiJQ9dZRmgtxr3fqRSmXRsitzXncbq1n7lyZaol_37zY8ypuIYd8czMQibwr2bWY7o7yOfcZRelojM07Rirk9Yf2d8Z5UbXlnjZUh0JOQfycRe2r00-0Ov_-zc8g4UFR26Rsq9FFySOQt_mbetJeFcl0gYfrMIu0x2_RBnWy_FnZO4Z1lsU52sdM2nUtYxw8najjIaRsYf-scsqb4cpOVB920_sOWnR_YZVQ2rM5rsekJ1jpYt2oB45xQquYx2bzWjYu5goeJ18zJv21ppSRF1Q39gd1x5z3Yeqti6aMYcuiUq2RoMn7dk5seIQ_OnqhFqgzYeduhUbp_s-OixoyYFpZ_Ugjyqp-2Rh3IxxRpYBSzy43mrIdeSadJ-JsMJdkYcy_xW1kkF3Vocgcchbjwie9yZ2FJkvn5zIB_fsWXs7QvX7BR';
                        final notificationPayload = {
                          "notification": {
                            "title": "Test Notification",
                            "body": "This is a test notification from Flutter.",
                          },
                          "data": {
                            "key1": "value1",
                            "key2": "value2",
                          },
                        };
                        apiConsumer.sendNotification(fcmToken: fcmToken, serverToken: serverToken, notificationPayload: notificationPayload);
                        // context.read<AuthBloc>().facebookSignIn(0, 'user');
                      },
                      child: SvgPicture.asset(
                        'assets/svg/facebook.svg',
                        width: 60.w,
                      )),
                ],
              ),
            ),
            Gaps.vertical(context.screenHeight * 0.009),
            Text(LocaleKeys.dontHaveAccount.tr()),
            Gaps.vertical(context.screenHeight * 0.01),
           GestureDetector(
                  onTap: () {
                    // context.read<AuthBloc>().login('5', '5', 2, '4');
                    context.go(BlocProvider(create: (context)=>sl<AuthBloc>(), child: const RegisterScreen()));
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 75.w, vertical: 25.h),
                    decoration: BoxDecoration(
                      // color: HexColor.fromHex('#E3E3E3'),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: HexColor.fromHex('#363636'), width: 1.5),
                    ),
                    child: Text(
                      LocaleKeys.registerNow.tr(),
                      style: context.theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.black, fontSize: 30.sp),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
