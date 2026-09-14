import 'package:flutter/widgets.dart';

/// Resolves the sides of [EdgeInsets] against the axis direction of a scroll
/// view, as [SliverPadding] does.
extension AxisDirectionPadding on EdgeInsets {
  /// The padding on the side nearest the 0.0 scroll offset.
  double leadingAlong(AxisDirection axisDirection) => switch (axisDirection) {
    AxisDirection.down => top,
    AxisDirection.up => bottom,
    AxisDirection.right => left,
    AxisDirection.left => right,
  };

  /// The padding on the side furthest from the 0.0 scroll offset.
  double trailingAlong(AxisDirection axisDirection) => switch (axisDirection) {
    AxisDirection.down => bottom,
    AxisDirection.up => top,
    AxisDirection.right => right,
    AxisDirection.left => left,
  };

  /// The padding in the cross axis of [axisDirection].
  EdgeInsets crossAxisOf(AxisDirection axisDirection) =>
      switch (axisDirectionToAxis(axisDirection)) {
        Axis.vertical => EdgeInsets.only(left: left, right: right),
        Axis.horizontal => EdgeInsets.only(top: top, bottom: bottom),
      };
}
