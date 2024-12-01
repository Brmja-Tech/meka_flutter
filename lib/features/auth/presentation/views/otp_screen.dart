import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/stateful/otp_widget.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:meka/meka/meka_screen.dart';

class OTPScreen extends StatelessWidget {
  final int otp;

  const OTPScreen({super.key, required this.otp});

  @override
  Widget build(BuildContext context) {
    log('otp is $otp');
    // log('email is ${context.read<AuthBloc>().state.user!.email}');
    // log('phone is ${context.read<AuthBloc>().state.user!.phoneNumber}');
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
                    LocaleKeys.enterCode.tr(),
                    style: context.textTheme.headlineSmall,
                  ),
                  Gaps.v28(),
                  OTPWidget(
                    onDone: (otp) async {
                      context.read<AuthBloc>().verifyOTP(otp);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if(state.isVerified){
                      context.go(const MekaScreen());
                    }
                  },
                  builder: (context, state) {
                    if(state.isLoading){
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomElevatedButton(
                        height: 90.h,
                        width: context.screenWidth - 80.w,
                        radius: 15,
                        text: LocaleKeys.resendOTP.tr(),
                        onPressed: () {

                          final email =
                              context.read<AuthBloc>().state.user!.email;
                          context.read<AuthBloc>().reSendOTP(email);
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
