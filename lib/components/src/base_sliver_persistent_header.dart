import 'package:flutter/material.dart';

/// e.g.
///
/// SliverPersistentHeader(
///   pinned: true,
///   delegate: BaseSliverPersistentHeaderDelegate(
///     extent: 44,
///     child: Container(
///       alignment: Alignment.center,
///       color: Colors.redAccent,
///       child: const Text("BaseSliverPersistentHeaderDelegate"),
///     ),
///   ),
/// ),
class BaseSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double extent;

  BaseSliverPersistentHeaderDelegate(
      {required this.child, required this.extent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
