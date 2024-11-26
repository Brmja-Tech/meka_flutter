import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/loader/presentation/views/maps_screen.dart';
import 'package:meka/features/maintenance/presentation/views/maintenace_screen.dart';
import 'package:meka/features/offers/presentation/views/offers_screen.dart';
import 'package:meka/features/profile/presentation/views/profile_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class MekaScreen extends StatefulWidget {
  const MekaScreen({super.key});

  @override
  _MekaScreenState createState() => _MekaScreenState();
}

class _MekaScreenState extends State<MekaScreen> {



  int _selectedIndex = 0;

  // Pages for IndexedStack
  final List<Widget> _pages = [
    const OfferScreen(),
    const MapsScreen(),
    const MaintenanceScreen(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),

            // Horizontal padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26, // Shadow color
                  blurRadius: 10, // Shadow blur
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              // Ensure the shadow matches border radius
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  // highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  // Remove elevation
                  backgroundColor: Colors.white,
                  // Background color of the bar
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,

                  showSelectedLabels: false,
                  // Hide labels for selected items
                  showUnselectedLabels: false,
                  // Hide labels for unselected items
                  type: BottomNavigationBarType.fixed,
                  // Keep shifting type
                  selectedItemColor: AppColors.primaryColor,
                  // Icon color for selected item
                  unselectedItemColor: Colors.grey,
                  // Icon color for unselected items
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svg/lock.svg',
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding:  EdgeInsetsDirectional.only(end: 60.w),
                        child: SvgPicture.asset('assets/svg/search.svg'),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding:  EdgeInsetsDirectional.only(start: 60.w),

                        child: SvgPicture.asset('assets/svg/mail.svg'),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/svg/user.svg'),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, // Adjust the vertical position of the logo
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(0, -20.h),
              child: Container(
                width: 205.w, // Adjust logo size
                height: 150.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Make it circular
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/svg/app_logo.svg',
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    sl<PusherConsumer>().initialize();
    super.didChangeDependencies();
  }
}




