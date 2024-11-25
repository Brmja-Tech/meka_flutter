import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/theme/app_colors.dart';

class GridWrap extends StatelessWidget {
  const GridWrap({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for grid items
    final List<Map<String, dynamic>> gridItems = [
      {"icon": Icons.car_repair, "title": "خدمة السيارات"},
      {"icon": Icons.handyman, "title": "العناية بالإطارات"},
      {"icon": Icons.construction, "title": "أعمال الدخان"},
      {"icon": Icons.water_damage, "title": "خدمة وإصلاح مكيفات"},
      {"icon": Icons.cleaning_services, "title": "تنظيف السيارات"},
      {"icon": Icons.battery_charging_full, "title": "البطاريات"},
      {"icon": Icons.shield, "title": "مطالبات التأمين"},
      {"icon": Icons.window, "title": "إصلاح الزجاج الجانبي"},
      {"icon": Icons.medical_services, "title": "صيانة طوارئ"},
      {"icon": Icons.build_circle, "title": "صيانة دورية"},
      {"icon": Icons.local_car_wash, "title": "غسيل كيميائي"},
      {"icon": Icons.tire_repair, "title": "تغيير الزيت"},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 00.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Four items per row
          crossAxisSpacing: 20.w, // Horizontal spacing
          mainAxisSpacing: 20.h, // Vertical spacing
          childAspectRatio:0.7 , // Adjust aspect ratio if needed
        ),
        itemCount: gridItems.length,
        shrinkWrap: true, // Makes GridView work with flexible parent containers
        physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
        itemBuilder: (context, index) {
          final item = gridItems[index];
          return Container(

            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26, // Shadow color with some transparency
                  blurRadius: 10, // Blur radius for softness
                  spreadRadius: 2, // How far the shadow spreads
                  offset: Offset(0, 4), // Position of the shadow (horizontal, vertical)
                ),
              ],
              // shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  item["icon"],
                  size: 80.w,
                  color:  HexColor.fromHex('#0061FF'),
                ),
                SizedBox(height: 8.h),
                Text(
                  item["title"],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
