import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateless/custom_appbar.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/service_locator/service_locator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Column(
              children: [
                // Gaps.vertical(context.screenHeight * 0.08),
                const CustomAppbar(),
                Gaps.vertical(context.screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Align(
                      alignment: context.isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        LocaleKeys.createYourAccount.tr(),
                        style: context.textTheme.headlineLarge,
                      )),
                ),
                //username
                CustomTextField(
                  hintText: LocaleKeys.name.tr(),
                  // svgPath: 'assets/svg/mail.svg',
                  obscureText: false,
                  controller: _nameController,
                  prefixPath: 'assets/svg/user.svg',
                ),
                Gaps.vertical(context.screenHeight * 0.001),
                //phone
                CustomTextField(
                  hintText: LocaleKeys.password.tr(),
                  // svgPath: 'assets/svg/lock.svg',
                  obscureText: false,
                  controller: _phoneController,
                  prefixPath: 'assets/svg/phone.svg',
                  textInputType: TextInputType.number,
                ),
                Gaps.vertical(context.screenHeight * 0.001),
                //email
                CustomTextField(
                  hintText: LocaleKeys.email.tr(),
                  // svgPath: 'assets/svg/mail.svg',
                  obscureText: false,
                  controller: _emailController,
                  prefixPath: 'assets/svg/email.svg',
                ),
                Gaps.vertical(context.screenHeight * 0.001),
                //password
                CustomTextField(
                  hintText: LocaleKeys.password.tr(),
                  svgPath: 'assets/svg/eye.svg',
                  obscureText: true,
                  prefixPath: 'assets/svg/lock.svg',
                  controller: _passwordController,
                  textAlign: _confirmPasswordController.text.isEmpty
                      ? TextAlign.start
                      : TextAlign.center,
                  textInputType: TextInputType.visiblePassword,
                ),
                Gaps.vertical(context.screenHeight * 0.001),
                //confirm password
                CustomTextField(
                  hintText: LocaleKeys.confirmPassword.tr(),
                  svgPath: 'assets/svg/eye.svg',
                  prefixPath: 'assets/svg/lock.svg',
                  obscureText: true,
                  controller: _confirmPasswordController,
                  textAlign: _confirmPasswordController.text.isEmpty
                      ? TextAlign.start
                      : TextAlign.center,
                  textInputType: TextInputType.visiblePassword,
                ),

                Gaps.vertical(context.screenHeight * 0.009),
                CustomElevatedButton(
                  text: LocaleKeys.register.tr(),
                  height: 90.h,
                  width: context.screenWidth - 80.w,
                  radius: 15,
                  textStyle: context.theme.textTheme.bodyLarge!
                      .copyWith(color: Colors.white),
                  // color: AppCol,
                  onPressed: () {},
                ),
                Gaps.vertical(context.screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    text: LocaleKeys.alreadyHaveAccount.tr(), // The main text
                    style: context.theme.textTheme.labelLarge!.copyWith(
                        color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '\t${LocaleKeys.signInNow.tr()}',
                        // The clickable part
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.normal,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pop();
                          },
                      ),
                    ],
                  ),
                ),
                Gaps.vertical(context.screenHeight * 0.02),
                Text(LocaleKeys.continueWith.tr()),

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
                            context.read<AuthBloc>().googleSignIn(0, 'admin');
                          },
                          child: SvgPicture.asset(
                            'assets/svg/google.svg',
                            width: 60.w,
                          )),
                      Gaps.h48(),
                      InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'assets/svg/facebook.svg',
                            width: 60.w,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
