import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_state.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/views/chat_screen.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';
import 'package:meka/features/loader/presentation/views/maps_screen.dart';
import 'package:meka/features/offers/presentation/blocs/offers/offers_bloc.dart';
import 'package:meka/features/offers/presentation/views/offers_screen.dart';
import 'package:meka/features/profile/presentation/views/profile_screen.dart';
import 'package:meka/meka/home_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

import '../features/auth/presentation/blocs/auth/auth_cubit.dart';

class MekaScreen extends StatefulWidget {
  const MekaScreen({super.key});

  @override
  _MekaScreenState createState() => _MekaScreenState();
}

class _MekaScreenState extends State<MekaScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool _isUser = false; // Default value; updated based on the role

  final List<Widget> _userPages = [
    BlocProvider(
        create: (context) => sl<OffersBloc>(), child: const OfferScreen()),
    const MapsScreen(),
    const HomeScreen(),
    BlocProvider(
        create: (context) => sl<ChatBloc>(),
        child: const ChatScreen()),
    BlocProvider(create: (_) => sl<AuthBloc>(), child: const ProfilePage()),
  ];

  final List<Widget> _driverPages = [
    const MapsScreen(),
    BlocProvider(
        create: (context) => sl<ChatBloc>(),
        child: const ChatScreen()),
    BlocProvider(create: (_) => sl<AuthBloc>(), child: const ProfilePage()),
  ];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final role = await CacheManager.getRole() ?? false; // Default to user
    setState(() {
      _isUser = role;
    });
    sl<ApiConsumer>().updateHeader(
        {"Authorization": ' Bearer ${await CacheManager.getAccessToken()}'});
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pages = _isUser ? _userPages : _driverPages;
    final navItems = _isUser
        ? [
      _buildNavItem(index: 0, icon: 'assets/svg/lock.svg'),
      _buildNavItem(index: 1, icon: 'assets/svg/search.svg'),
      Gaps.horizontal(context.screenWidth * 0.06),
      _buildNavItem(index: 3, icon: 'assets/svg/mail.svg'),
      _buildNavItem(index: 4, icon: 'assets/svg/user.svg'),
    ]
        : [
      _buildNavItem(index: 0, icon: 'assets/svg/search.svg'),
      _buildNavItem(index: 1, icon: 'assets/svg/mail.svg'),
      _buildNavItem(index: 2, icon: 'assets/svg/user.svg'),
    ];
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: pages,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Bottom navigation bar
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: navItems,
                          ),
                        ),
                      ),
                    ),
                    // App logo in the center
                    if (_isUser)
                      Positioned(
                        bottom: 25,
                        // Adjust to slightly overlap the navigation bar
                        child: GestureDetector(
                          onTap: () => _onItemTapped(2),
                          // Navigate to HomeScreen
                          child: SvgPicture.asset(
                            'assets/svg/app_logo.svg',
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    bool isHome = false,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<LoaderBloc>().resetState();
        _onItemTapped(index);
      },
      child: SvgPicture.asset(
        icon,
        width: isHome ? 80.w : 30.w,
        height: isHome ? 80.w : 30.h,
        color: isHome
            ? null
            : _selectedIndex == index
            ? Colors.blue
            : Colors.black,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
