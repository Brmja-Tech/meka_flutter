import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/gaps.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final String hintText;
  final String? svgPath;
  final TextAlign? textAlign;
  final String? prefixPath;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final IconData? suffix;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final TextInputType textInputType;
  final bool isLogin;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.svgPath,
    this.maxLength,
    this.isLogin = false,
    this.textInputAction = TextInputAction.next,
    required this.obscureText,
    this.textInputType = TextInputType.text,
    this.textAlign,
    this.prefixPath,
    this.suffix,
    this.focusNode,
    this.maxLines = 1,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(8.0).add(EdgeInsets.symmetric(horizontal: 13.w)),
      child: Container(
        constraints: !isLogin
            ? BoxConstraints(minHeight: 50.h, maxHeight: 120.h)
            : const BoxConstraints(),
        child: TextFormField(
          maxLength: maxLength,
          textAlign: textAlign ?? TextAlign.start,
          obscureText: obscureText,
          keyboardType: textInputType,
          minLines: minLines,
          textDirection:
              context.isArabic ? TextDirection.rtl : TextDirection.ltr,
          maxLines: maxLines,
          textInputAction: textInputAction,
          inputFormatters: [
            if (textInputType == TextInputType.number)
              FilteringTextInputFormatter.digitsOnly
          ],
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            fillColor: HexColor.fromHex('#FAFAFA'),
            filled: true,
            counterText: "",
            contentPadding:
                EdgeInsets.all(30.w).add(EdgeInsets.symmetric(vertical: 5.h)),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: hintText,
            hintStyle: context.theme.textTheme.bodyLarge!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            prefix: prefixPath == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: (20.0.w),
                    ),
                    child: SvgPicture.asset(prefixPath!),
                  ),
            suffix: svgPath == null
                ? null
                : SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isLogin) ...[
                          Container(
                            width: 5.w,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            color: Colors.grey,
                          )
                        ],
                        Gaps.h10(),
                        SvgPicture.asset(svgPath!),
                      ],
                    ),
                  ),
          ),
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return errorText ?? 'This field is required';
            }
            return null;
          },
        ),
      ),
    );
  }
}
