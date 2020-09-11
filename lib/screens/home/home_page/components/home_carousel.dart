import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/screens/components/image_error_widget.dart';
import 'package:tethered/theme/size_config.dart';

class HomeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.easeInOutBack,
        autoPlayAnimationDuration: Duration(seconds: 3),
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            Random rnd;
            int min = 1050;
            int max = 1080;
            rnd = new Random();
            int value = min + rnd.nextInt(max - min);
            final itemBorderRadius = BorderRadius.circular(10);

            return Container(
              width: fullWidth,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: itemBorderRadius),
              child: ClipRRect(
                borderRadius: itemBorderRadius,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[500],
                      highlightColor: Colors.grey[400],
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          child: SizedBox.expand(),
                        ),
                      )),
                  errorWidget: (context, url, error) => ImageErrorWidget(),
                  imageUrl: 'https://picsum.photos/id/${value}/400/600',
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
