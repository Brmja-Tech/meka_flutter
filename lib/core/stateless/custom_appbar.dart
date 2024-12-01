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
              // width: 70.w,
              // height: 70.w,
              padding: EdgeInsets.all(5.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                padding:  EdgeInsets.all(15.0.w),
                child: Transform.translate(
                  offset: Offset(-5.w, 0.0.w),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
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
