import 'dart:developer';
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
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:meka/features/auth/presentation/views/otp_screen.dart';
import 'package:meka/meka/meka_screen.dart';
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
  final ValueNotifier<bool> _isTermsAccepted = ValueNotifier(false);
  List<int> isSelected = [0, 2]; // 0 for User, 1 for Driver
  bool isDriver = true;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _isTermsAccepted.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                      ),
                    ),
                  ),
                  CustomTextField(
                    hintText: LocaleKeys.name.tr(),
                    obscureText: false,
                    controller: _nameController,
                    prefixPath: 'assets/svg/user.svg',
                  ),
                  Gaps.vertical(context.screenHeight * 0.001),
                  CustomTextField(
                    hintText: LocaleKeys.phone.tr(),
                    maxLength: 11,
                    obscureText: false,
                    controller: _phoneController,
                    prefixPath: 'assets/svg/phone.svg',
                    textInputType: TextInputType.number,
                  ),
                  Gaps.vertical(context.screenHeight * 0.001),
                  CustomTextField(
                    hintText: LocaleKeys.email.tr(),
                    obscureText: false,
                    controller: _emailController,
                    prefixPath: 'assets/svg/email.svg',
                  ),
                  Gaps.vertical(context.screenHeight * 0.001),
                  CustomTextField(
                    hintText: LocaleKeys.password.tr(),
                    svgPath: 'assets/svg/eye.svg',
                    obscureText: true,
                    prefixPath: 'assets/svg/lock.svg',
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  Gaps.vertical(context.screenHeight * 0.001),
                  CustomTextField(
                    hintText: LocaleKeys.confirmPassword.tr(),
                    svgPath: 'assets/svg/eye.svg',
                    prefixPath: 'assets/svg/lock.svg',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm password is required';
                      }
                      if (value != _passwordController.text.trim()) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                  ),
                  Gaps.v28(),
                  ToggleButtons(
                    borderColor: Colors.grey,
                    fillColor: AppColors.primaryColor,
                    borderWidth: 2,
                    selectedBorderColor: AppColors.primaryColor,
                    selectedColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    isSelected: isSelected.map((e) => e != 0).toList(),  // Convert 0 to false, 2 to true
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index ? (index == 0 ? 0 : 2) : 0; // 0 for Rider, 2 for Driver
                        }
                        isDriver = index == 1; // Set isDriver based on selection
                        log(isDriver ? 'Driver selected' : 'Rider selected');
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          LocaleKeys.driver.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected[0] == 2 ? FontWeight.bold : FontWeight.normal, // 2 for Driver
                            color: isSelected[0] == 2 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          LocaleKeys.rider.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected[1] == 0 ? FontWeight.bold : FontWeight.normal, // 0 for Rider
                            color: isSelected[1] == 0 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v28(),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isTermsAccepted,
                    builder: (context, isAccepted, _) {
                      return CheckboxListTile(
                        value: isAccepted,
                        onChanged: (value) {
                          _isTermsAccepted.value = value!;
                        },
                        title: Text(
                          'الموافقة على الشروط والاحكام',
                          style: context.textTheme.bodyLarge,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.isSocialAuthSuccess) {
                        context.goWithNoReturn(const MekaScreen());
                      }
                      if (state.isOTPSent) {
                        context.go(BlocProvider.value(
                          value: sl<AuthBloc>(),
                          child: OTPScreen(
                            otp: state.registerResponseEntity!.otp,
                            email: _emailController.text.trim(),
                          ),
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomElevatedButton(
                        text: LocaleKeys.register.tr(),
                        height: 90.h,
                        width: context.screenWidth - 80.w,
                        radius: 15,
                        textStyle: context.theme.textTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _isTermsAccepted.value) {
                            context.read<AuthBloc>().register(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _nameController.text.trim(),
                                  _phoneController.text.trim(),
                                  !isDriver ? 0 : 2,
                                );
                          } else if (!_isTermsAccepted.value) {
                            context.showErrorMessage('please accept terms');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
