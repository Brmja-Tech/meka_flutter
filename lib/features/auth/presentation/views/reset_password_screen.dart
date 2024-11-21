import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateless/custom_appbar.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/auth/presentation/views/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey _formkey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppbar(
                onTap: () {
                  context.goWithNoReturn(const LoginScreen());
                },
              ),
              Gaps.vertical(context.screenHeight * 0.1),
              CustomTextField(
                controller: _newPasswordController,
                obscureText: true,
                prefixPath: 'assets/svg/lock.svg',
                svgPath: 'assets/svg/eye.svg',
                hintText: LocaleKeys.newPassword.tr(),
              ),
              Gaps.vertical(context.screenHeight * 0.05),
              CustomElevatedButton(
                text: LocaleKeys.resetPassword.tr(),
                onPressed: () {},
                width: context.screenWidth - 80.w,
                textStyle:
                    context.textTheme.bodyLarge!.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
