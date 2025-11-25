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
    // This sliver acts only as a marker and does not occupy any space in the viewport.
    geometry = SliverGeometry.zero;

    // Check if the viewport (including the cache area) has reached the start of this sliver.
    // `remainingCacheExtent` > 0 means the sliver is within the visible area or cache.
    // If it is 0, the sliver is effectively positioned below the viewport (off-screen).
    final hasReachedSliverStart = constraints.remainingCacheExtent > 0;

    // Check if the viewport has scrolled past this sliver.
    // `scrollOffset` is the scroll position relative to the start of *this* sliver.
    // Since this sliver has zero extent, any positive offset means the viewport
    // has already passed it.
    final hasNotPassedSliver = constraints.scrollOffset <= 0;

    final isNowVisible = hasReachedSliverStart && hasNotPassedSliver;

    if (isNowVisible != _isVisible) {
      _isVisible = isNowVisible;

      // Schedule the callback for the end of the frame.
      // This prevents triggering state changes or new layout passes while the
      // current layout pass is still active.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (attached) {
          onVisibilityChanged(_isVisible);
        }
      });
    }
  }
}
