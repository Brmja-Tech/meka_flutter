import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meka/core/theme/app_colors.dart';

class ImageFromInternet extends StatelessWidget {
  const ImageFromInternet({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.borderRadius,
    this.fromFile = false,
    this.isCircle = false,
    this.defaultLogo = false,
    this.fit,
  });

  final String image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool? fromFile;
  final bool? isCircle;
  final bool? defaultLogo;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.fill,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          color: AppColors.primaryColor,
        ),
        child: fromFile == true
            ? Image.file(
                File(image),
                fit: BoxFit.fill,
              )
            : defaultLogo == true
                ? SvgPicture.asset('assets/svg/app_logo.svg')
                : CachedNetworkImage(
                    imageUrl:
                        'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg'),
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.primaryColor,
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: SvgPicture.asset('assets/svg/app_logo.svg'),
      ),
    );
  }
}
