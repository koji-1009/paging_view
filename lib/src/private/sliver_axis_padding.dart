import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The part of an [EdgeInsets] that a [SliverAxisPadding] applies.
enum SliverAxisPaddingPart {
  /// The padding on the side nearest the 0.0 scroll offset.
  leading,

  /// The padding on the side furthest from the 0.0 scroll offset.
  trailing,

  /// The padding in the cross axis.
  crossAxis,
}

/// A sliver that applies one part of [padding], resolved against the axis
/// direction the sliver is laid out in.
///
/// [SliverPadding] passes `cacheOrigin + beforePadding` to its child, which
/// shrinks the leading cache area of the child by the leading padding. Applying
/// the main axis padding with [SliverAxisPaddingPart.leading] and
/// [SliverAxisPaddingPart.trailing] slivers next to the content, and only the
/// cross axis padding around it, keeps the leading cache area intact.
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
  @override
  EdgeInsets get resolvedPadding {
    final axisDirection = applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    );
    return switch ((part, axisDirection)) {
      (SliverAxisPaddingPart.leading, AxisDirection.down) => EdgeInsets.only(
        top: padding.top,
      ),
      (SliverAxisPaddingPart.leading, AxisDirection.up) => EdgeInsets.only(
        bottom: padding.bottom,
      ),
      (SliverAxisPaddingPart.leading, AxisDirection.right) => EdgeInsets.only(
        left: padding.left,
      ),
      (SliverAxisPaddingPart.leading, AxisDirection.left) => EdgeInsets.only(
        right: padding.right,
      ),
      (SliverAxisPaddingPart.trailing, AxisDirection.down) => EdgeInsets.only(
        bottom: padding.bottom,
      ),
      (SliverAxisPaddingPart.trailing, AxisDirection.up) => EdgeInsets.only(
        top: padding.top,
      ),
      (SliverAxisPaddingPart.trailing, AxisDirection.right) => EdgeInsets.only(
        right: padding.right,
      ),
      (SliverAxisPaddingPart.trailing, AxisDirection.left) => EdgeInsets.only(
        left: padding.left,
      ),
      (
        SliverAxisPaddingPart.crossAxis,
        AxisDirection.down || AxisDirection.up,
      ) =>
        EdgeInsets.only(left: padding.left, right: padding.right),
      (
        SliverAxisPaddingPart.crossAxis,
        AxisDirection.right || AxisDirection.left,
      ) =>
        EdgeInsets.only(top: padding.top, bottom: padding.bottom),
    };
  }
}
