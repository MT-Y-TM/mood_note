import 'package:flutter/material.dart';

class SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final double topPadding;

  SliverSearchBarDelegate({
    required this.child,
    required this.backgroundColor,
    this.topPadding = 30.0,
  });

  @override
  double get minExtent => 60.0 + topPadding;
  @override
  double get maxExtent => 60.0 + topPadding;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Center(child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverSearchBarDelegate oldDelegate) => false;
}