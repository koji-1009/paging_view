import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/private/axis_direction_padding.dart';

/// The part of an [EdgeInsets] that a [SliverAxisPadding] applies.
enum SliverAxisPaddingPart {
  /// The padding on the side nearest the 0.0 scroll offset.
  leading,

  /// The padding on the side furthest from the 0.0 scroll offset.
  trailing,

  /// The padding in the cross axis.
  crossAxis,
}

/// A sliver that applies one part of [padding], resolved at layout time
/// against the axis direction of the enclosing viewport.
///
/// [SliverPadding] passes `cacheOrigin + beforePadding` to its child, which
/// shrinks the leading cache area of the child by the leading padding. Placing
/// [SliverAxisPaddingPart.leading] and [SliverAxisPaddingPart.trailing] slivers
/// next to the content in a [SliverMainAxisGroup], and wrapping the content in
/// a [SliverAxisPaddingPart.crossAxis] sliver, keeps the leading cache area
/// intact.
///
/// Resolving at layout time does not depend on a [Scrollable] ancestor, which
/// may be missing or belong to another viewport.
class SliverAxisPadding extends SingleChildRenderObjectWidget {
  /// Creates a sliver that applies [part] of [padding].
  const SliverAxisPadding({
    super.key,
    required this.padding,
    required this.part,
    Widget? sliver,
  }) : super(child: sliver);

  /// The padding to apply a part of.
  final EdgeInsets padding;

  /// The part of [padding] to apply.
  final SliverAxisPaddingPart part;

  @override
  RenderSliverAxisPadding createRenderObject(BuildContext context) {
    return RenderSliverAxisPadding(padding: padding, part: part);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverAxisPadding renderObject,
  ) {
    renderObject
      ..padding = padding
      ..part = part;
  }
}

/// The render object for [SliverAxisPadding].
class RenderSliverAxisPadding extends RenderSliverEdgeInsetsPadding {
  /// Creates a render object that applies [part] of [padding].
  RenderSliverAxisPadding({required this._padding, required this._part})
    : assert(_padding.isNonNegative);

  /// The padding to apply a part of.
  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    assert(value.isNonNegative);
    if (_padding == value) {
      return;
    }
    _padding = value;
    markNeedsLayout();
  }

  /// The part of [padding] to apply.
  SliverAxisPaddingPart get part => _part;
  SliverAxisPaddingPart _part;
  set part(SliverAxisPaddingPart value) {
    if (_part == value) {
      return;
    }
    _part = value;
    markNeedsLayout();
  }

  /// Only valid after layout has started, since the part depends on the axis
  /// direction of [constraints].
  ///
  /// This resolves against [SliverConstraints.axisDirection] without applying
  /// [SliverConstraints.growthDirection]: a [SliverMainAxisGroup] growing in
  /// the reverse direction lays out its children from the last one, so the
  /// leading part stays on the same side as it does in the forward direction.
  @override
  EdgeInsets get resolvedPadding {
    final axisDirection = constraints.axisDirection;
    return switch (part) {
      SliverAxisPaddingPart.leading => _mainAxis(
        padding.leadingAlong(axisDirection),
      ),
      SliverAxisPaddingPart.trailing => _mainAxis(
        padding.trailingAlong(axisDirection),
      ),
      SliverAxisPaddingPart.crossAxis => padding.crossAxisOf(axisDirection),
    };
  }

  EdgeInsets _mainAxis(double extent) => switch (constraints.axis) {
    Axis.vertical => EdgeInsets.only(top: extent),
    Axis.horizontal => EdgeInsets.only(left: extent),
  };
}
