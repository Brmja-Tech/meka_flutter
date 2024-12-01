import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/views/reset_password_screen.dart';

class OTPWidget extends StatefulWidget {
  final bool forgetPassword;
  final Future<void> Function(String otp) onDone;

  const OTPWidget(
      {super.key, this.forgetPassword = true, required this.onDone});

  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final int otpLength = 4;
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }


  void handleInput(String value, int index) async {
    if (value.isNotEmpty && index < otpLength - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    // Check if OTP is complete
    final otp = controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      try {
        await widget.onDone(otp); // Trigger API request
      } catch (error) {
        loggerError(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(otpLength, (index) {
          return Container(
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              maxLength: 1,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the font bold
                fontSize: 40.sp, // Optional: Increase font size
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15, // Vertical padding
                  horizontal: 10, // Horizontal padding
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor, // Default border color
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor, // Border color when focused
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => handleInput(value, index),
            ),
          );
        }),
      ),
    );
  }
}
