import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/core/theme/app_colors.dart';

class CustomAppbar extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomAppbar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap ?? () {
                    context.pop();
                  },
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    spreadRadius: 0,
                    blurRadius: 25,
                    offset:
                        const Offset(6.25, 12.5), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          SvgPicture.asset(
            'assets/svg/app_logo.svg',
            width: 150.w,
          ),
          Gaps.h28(),
          SvgPicture.asset(
            'assets/svg/meka.svg',
            width: 200.w,
          ),
        ],
      ),
    );
  }
}
