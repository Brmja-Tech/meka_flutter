import 'dart:async';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<Widget> widgets;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const CarouselSliderWidget({
    super.key,
    required this.widgets,
    this.height = 400,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final PageController _pageController = PageController();
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      _currentPage++;
      if (_currentPage >= widget.widgets.length) {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel Image
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.widgets.length,
            itemBuilder: (context, index) {
              return widget.widgets[index];
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),

        // Dot Indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.widgets.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: _currentPage == index ? 12 : 8, // Larger dot for current page
                width: _currentPage == index ? 10 : 6, // Adjust size of active dot
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.blue // Active dot color
                      : Colors.grey.withOpacity(0.2), // Inactive dot color
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
