import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/features/chat/presentation/views/chat_screen.dart';
import 'package:meka/features/loader/presentation/views/maps_screen.dart';
import 'package:meka/features/offers/presentation/views/offers_screen.dart';
import 'package:meka/features/profile/presentation/views/profile_screen.dart';
import 'package:meka/meka/home_screen.dart';

class MekaScreen extends StatefulWidget {
  const MekaScreen({super.key});

  @override
  _MekaScreenState createState() => _MekaScreenState();
}

class _MekaScreenState extends State<MekaScreen> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OfferScreen(),
    const MapsScreen(),
    const HomeScreen(),
    const ChatScreen(),
    const ProfilePage(),
  ];

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
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: _onPageChanged,
            children: _pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: 'assets/svg/lock.svg',
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: 'assets/svg/search.svg',
                        ),
                        _buildNavItem(
                          index: 2,
                          icon: 'assets/svg/app_logo.svg',
                        ),
                        _buildNavItem(
                          index: 3,
                          icon: 'assets/svg/mail.svg',
                        ),
                        _buildNavItem(
                          index: 4,
                          icon: 'assets/svg/user.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required int index, required String icon}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: SvgPicture.asset(
        icon,
        width: 24.w,
        height: 24.h,
        color: _selectedIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
