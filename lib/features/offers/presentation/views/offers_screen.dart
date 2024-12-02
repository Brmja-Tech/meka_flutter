import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateful/carousel_slider_widget.dart';
import 'package:meka/core/stateful/custom_text_field.dart';
import 'package:meka/core/stateful/grid_wrap.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/core/stateless/image_from_internet.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_state.dart';
import 'package:meka/features/offers/presentation/blocs/offers/offers_bloc.dart';
import 'package:meka/features/offers/presentation/blocs/offers/offers_state.dart';

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
    log('offers screen init state');
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
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return BlocBuilder<OffersBloc, OffersState>(
                  builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    _buildHeader(context, userState),
                    Gaps.v18(),
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
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserState state) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.secondaryColor,
          child: const Icon(Icons.person),
        ),
        // const Spacer(),
        Expanded(child: Container()),
        if (state.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UserBloc.to.state.user?.name ?? '',
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(UserBloc.to.state.user?.phoneNumber ?? '',
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: Colors.grey)),
                  // Gaps.h10(),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Icon(
                  //     Icons.arrow_downward_sharp,
                  //     color: Colors.blue[700],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return BlocBuilder<OffersBloc, OffersState>(
      builder: (context, state) {
        if(state.isLoading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(state.banners.isEmpty){
          return const Center(
            child: Text('لا يوجد اعلانات حاليا'),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          height: 350.h,
          width: context.screenWidth - 120.w,
          child: CarouselSliderWidget(
              height: 300.h,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              widgets: List.generate(state.banners.length, (index) {
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
                    image: state.banners[index].imageUrl,
                    isCircle: false,
                    fit: BoxFit.fill,
                  ),
                );
              })),
        );
      },
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
