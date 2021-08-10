import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/book_cover.dart';

import 'image_error_widget.dart';

class BookCard extends StatelessWidget {
  final itemBorderRadius = BorderRadius.circular(10);
  final BookCover bookCover;

  BookCard({Key key, this.bookCover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: itemBorderRadius,
      ),
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
          imageUrl: bookCover.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
