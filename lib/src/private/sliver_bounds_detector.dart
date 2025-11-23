import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A callback that is called when the visibility of the sliver changes.
typedef SliverVisibilityCallback = void Function(bool isVisible);

/// A sliver that detects when it is visible in the viewport, including the
/// cache extent. This widget does not have a child and acts as a marker.
class SliverBoundsDetector extends LeafRenderObjectWidget {
  /// Creates a sliver that detects its visibility.
  const SliverBoundsDetector({super.key, required this.onVisibilityChanged});

  /// The callback that is called when the visibility of the sliver changes.
  final SliverVisibilityCallback onVisibilityChanged;

  @override
  RenderSliverBoundsDetector createRenderObject(BuildContext context) {
    return RenderSliverBoundsDetector(onVisibilityChanged: onVisibilityChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverBoundsDetector renderObject,
  ) {
    renderObject.onVisibilityChanged = onVisibilityChanged;
  }
}

/// A render object that detects when it is visible in the viewport.
class RenderSliverBoundsDetector extends RenderSliver {
  /// Creates a render object that detects its visibility.
  RenderSliverBoundsDetector({
    required SliverVisibilityCallback onVisibilityChanged,
  }) : _onVisibilityChanged = onVisibilityChanged;

  SliverVisibilityCallback _onVisibilityChanged;

  /// The callback that is called when the visibility of the sliver changes.
  SliverVisibilityCallback get onVisibilityChanged => _onVisibilityChanged;

  set onVisibilityChanged(SliverVisibilityCallback value) {
    if (_onVisibilityChanged != value) {
      _onVisibilityChanged = value;
      markNeedsLayout();
    }
  }

  bool _isVisible = false;

  @override
  void performLayout() {
    // This sliver does not produce any visible content.
    geometry = SliverGeometry.zero;

    // The sliver's scroll extent range in scroll coordinates.
    final sliverStart = constraints.precedingScrollExtent;
    final sliverEnd = sliverStart;

    // The cache area's range in scroll coordinates.
    final cacheAreaStart = constraints.scrollOffset + constraints.cacheOrigin;
    final cacheAreaEnd =
        constraints.precedingScrollExtent + constraints.remainingCacheExtent;

    // Check if the sliver's extent overlaps with the cache area's extent.
    final isNowVisible =
        (sliverStart < cacheAreaEnd) && (sliverEnd > cacheAreaStart);

    if (isNowVisible != _isVisible) {
      _isVisible = isNowVisible;
      // To avoid calling the callback during layout.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (attached) {
          onVisibilityChanged(_isVisible);
        }
      });
    }
  }
}
