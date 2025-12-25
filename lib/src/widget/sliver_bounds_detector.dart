import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A callback that is called when the visibility of the associated sliver
/// changes within the viewport's cache extent.
typedef SliverVisibilityCallback = void Function(bool isVisible);

/// A sliver that detects when it becomes visible or invisible within the
/// viewport, including the cache extent.
///
/// This widget is a [LeafRenderObjectWidget] that acts as a marker in the
/// sliver list. It has a zero-sized geometry and does not paint anything. Its
/// sole purpose is to monitor its position relative to the viewport and invoke
/// the [onVisibilityChanged] callback when its visibility status changes.
class SliverBoundsDetector extends LeafRenderObjectWidget {
  /// Creates a sliver that detects its visibility.
  const SliverBoundsDetector({super.key, required this.onVisibilityChanged});

  /// The callback that is invoked when the sliver enters or leaves the
  /// viewport's cache extent.
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

/// The render object for [SliverBoundsDetector].
///
/// It determines its visibility during layout based on [SliverConstraints]
/// and reports changes via the [onVisibilityChanged] callback.
class RenderSliverBoundsDetector extends RenderSliver {
  /// Creates a render object that detects its visibility.
  RenderSliverBoundsDetector({
    required SliverVisibilityCallback onVisibilityChanged,
  }) : _onVisibilityChanged = onVisibilityChanged;

  bool _isVisible = false;

  /// The callback that is called when the visibility of the sliver changes.
  SliverVisibilityCallback get onVisibilityChanged => _onVisibilityChanged;

  SliverVisibilityCallback _onVisibilityChanged;

  set onVisibilityChanged(SliverVisibilityCallback value) {
    if (_onVisibilityChanged != value) {
      _onVisibilityChanged = value;
      // The layout depends on the callback, so we need to mark for a new layout.
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // This sliver acts only as a marker and does not occupy any space.
    geometry = SliverGeometry.zero;

    // A sliver is considered "visible" if it is within the viewport's bounds
    // or the cache extent area.

    // `constraints.remainingCacheExtent` is the distance from the leading edge
    // of this sliver to the trailing edge of the cache area. If this value is
    // positive (or zero), it means this sliver's leading edge is inside or
    // touching the cache area.
    final hasReachedSliverStart = constraints.remainingCacheExtent >= 0;

    // `constraints.scrollOffset` is the distance from the leading edge of the
    // viewport to the leading edge of this sliver. Since this sliver has a
    // zero extent, a scrollOffset greater than zero means the viewport has
    // scrolled completely past it.
    final hasNotPassedSliver = constraints.scrollOffset <= 0;

    // The sliver is visible if it has entered the cache area from the bottom
    // and has not yet exited from the top.
    final isNowVisible = hasReachedSliverStart && hasNotPassedSliver;

    if (isNowVisible != _isVisible) {
      _isVisible = isNowVisible;

      // Schedule the callback for the post-frame phase to avoid modifying the
      // widget tree during a layout or paint phase.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (attached) {
          onVisibilityChanged(_isVisible);
        }
      });
    }
  }
}
