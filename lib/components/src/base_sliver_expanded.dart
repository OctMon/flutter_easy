import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BaseSliverExpanded extends SingleChildRenderObjectWidget {
  BaseSliverExpanded() : super(child: Container());

  @override
  RenderSliver createRenderObject(BuildContext context) {
    return _BaseRenderExpanded();
  }
}

class _BaseRenderExpanded extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    geometry = SliverGeometry.zero;
  }
}

class BaseExpandedViewport extends Viewport {
  BaseExpandedViewport({
    super.key,
    super.axisDirection,
    super.crossAxisDirection,
    super.anchor,
    required super.offset,
    super.center,
    super.cacheExtent,
    super.slivers,
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return _BaseRenderExpandedViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
    );
  }
}

class _BaseRenderExpandedViewport extends RenderViewport {
  _BaseRenderExpandedViewport({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.anchor,
    super.cacheExtent,
  });

  @override
  void performLayout() {
    super.performLayout();
    RenderSliver? expand;
    RenderSliver? p = firstChild;
    double totalLayoutExtent = 0;
    double frontExtent = 0.0;
    while (p != null) {
      totalLayoutExtent += (p.geometry?.scrollExtent ?? 0);
      if (p is _BaseRenderExpanded) {
        expand = p;
        frontExtent = totalLayoutExtent;
      }

      p = childAfter(p);
    }

    if (expand != null && size.height > totalLayoutExtent) {
      _attemptLayout(expand, size.height, size.width,
          offset.pixels - frontExtent - (size.height - totalLayoutExtent));
    }
  }

  // _minScrollExtent private in super,no setter method
  double _attemptLayout(RenderSliver expandPosition, double mainAxisExtent,
      double crossAxisExtent, double correctedOffset) {
    assert(!mainAxisExtent.isNaN);
    assert(mainAxisExtent >= 0.0);
    assert(crossAxisExtent.isFinite);
    assert(crossAxisExtent >= 0.0);
    assert(correctedOffset.isFinite);

    // centerOffset is the offset from the leading edge of the RenderViewport
    // to the zero scroll offset (the line between the forward slivers and the
    // reverse slivers).
    final double centerOffset = mainAxisExtent * anchor - correctedOffset;
    final double reverseDirectionRemainingPaintExtent =
        centerOffset.clamp(0.0, mainAxisExtent);

    final double forwardDirectionRemainingPaintExtent =
        (mainAxisExtent - centerOffset).clamp(0.0, mainAxisExtent);
    final double fullCacheExtent = mainAxisExtent + 2 * (cacheExtent ?? 0);
    final double centerCacheOffset = centerOffset + (cacheExtent ?? 0);
    final double forwardDirectionRemainingCacheExtent =
        (fullCacheExtent - centerCacheOffset).clamp(0.0, fullCacheExtent);

    final RenderSliver? leadingNegativeChild = childBefore(center!);
    // positive scroll offsets
    return layoutChildSequence(
      child: expandPosition,
      scrollOffset: math.max(0.0, -centerOffset),
      overlap:
          leadingNegativeChild == null ? math.min(0.0, -centerOffset) : 0.0,
      layoutOffset: centerOffset >= mainAxisExtent
          ? centerOffset
          : reverseDirectionRemainingPaintExtent,
      remainingPaintExtent: forwardDirectionRemainingPaintExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      growthDirection: GrowthDirection.forward,
      advance: childAfter,
      remainingCacheExtent: forwardDirectionRemainingCacheExtent,
      cacheOrigin: centerOffset.clamp(-(cacheExtent ?? 0), 0.0),
    );
  }
}
