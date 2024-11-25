import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateful/carousel_slider_widget.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateful/grid_wrap.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/core/stateless/image_from_internet.dart';
import 'package:meka/core/theme/app_colors.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int newIndex = _pageController.page?.toInt() ?? 0;
      if (_currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              CustomTextField(
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                textInputType: TextInputType.multiline,
                controller: _searchController,
                hintText: "ابحث عن",
                obscureText: false,
                svgPath: 'assets/svg/search.svg',
              ),
              Gaps.vertical(context.screenHeight * 0.02),
              _buildBanner(context),
              Gaps.vertical(context.screenHeight * 0.01),
              _buildInfo(context),
              Gaps.vertical(context.screenHeight * 0.01),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'اختر الخدمه',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp,
                    color: Colors.black54,
                  ),
                ),
              ),
              const GridWrap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.secondaryColor,
          child: const Icon(Icons.person),
        ),
        // const Spacer(),
        Expanded(child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "محمد السباعي",
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("المهندسين الجيزه",
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: Colors.grey)),
                Gaps.h10(),
                Icon(
                  Icons.arrow_downward_sharp,
                  color: Colors.blue[700],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      height: 350.h,
      width: context.screenWidth - 120.w,
      child: CarouselSliderWidget(
          height: 300.h,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          widgets: List.generate(5, (index) {
            return Container(
              // height: 150.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              // padding: EdgeInsets.symmetric(horizontal: 80.w),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ImageFromInternet(
                height: 350.h,
                width: context.screenWidth - 120.w,
                borderRadius: BorderRadius.circular(20),
                image:
                    'https://www.hoistcrane.com/wp-content/uploads/2017/05/Header-stock-photo-portrait-of-construction-worker-on-building-site-303643508-e1495218037891.jpg',
                isCircle: false,
                fit: BoxFit.fill,
              ),
            );
          })),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        color: HexColor.fromHex('#0061FF'),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'خدمه الونش',
                  style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp),
                ),
                Text('اذا كنت عطلان علي الطريق,اطلبنا الان',
                    style: context.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 25.sp)),
              ]),
          const Spacer(),
          const Icon(
            Icons.car_crash_rounded,
            color: Colors.white,
            size: 50,
          )
        ]),
      ),
    );
  }
}
