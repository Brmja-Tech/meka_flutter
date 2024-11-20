import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
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
      body: BlocProvider(
        create: (ctx) => sl<AuthCubit>(),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vertical(context.screenHeight*0.1),
            Center(child: SvgPicture.asset('assets/svg/app_logo.svg')),
            Gaps.vertical(context.screenHeight*0.001),
            SvgPicture.asset('assets/svg/meka.svg'),
            Gaps.vertical(context.screenHeight*0.1),
            _buildLoginInputField(controller: _emailController,hintText: LocaleKeys.email.tr(),svgPath: 'assets/svg/mail.svg'),
            Gaps.vertical(context.screenHeight*0.001),
            _buildLoginInputField(controller: _passwordController,hintText: LocaleKeys.password.tr(),svgPath: 'assets/svg/eye.svg'),
            Gaps.vertical(context.screenHeight*0.001),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: RichText(
                  text: TextSpan(
                    text: LocaleKeys.forgot.tr(), // The main text
                    style:context.theme.textTheme.labelLarge,
                    children: [
                      TextSpan(
                        text: " Click here", // The clickable part
                        style: const TextStyle(
                          color: Colors.blue, // Blue color for the clickable text
                          decoration: TextDecoration.underline, // Underline style
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle click action here
                            print("Forgot Password clicked!");
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
  Widget _buildLoginInputField({required TextEditingController controller,required String hintText,required String svgPath,}) {
    return Padding(
      padding: const EdgeInsets.all(8.0).add(EdgeInsets.symmetric(horizontal: 13.w)),
      child: TextFormField(
        controller: controller,
        decoration:  InputDecoration(
          fillColor: HexColor.fromHex('#FAFAFA'),
          filled: true,
          contentPadding: EdgeInsets.all(30.w).add(EdgeInsets.symmetric(vertical: 5.h)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          suffix: SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 5.w,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  color: Colors.grey,
                ),
                Gaps.h10(),
                SvgPicture.asset(svgPath),
              ],
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}
