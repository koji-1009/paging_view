import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/base_data_source.dart';
import 'package:paging_view/src/private/center_page_manager.dart';

/// A [DataSource] specifically designed for `CenterPagingList`.
///
/// Unlike the standard [DataSource], this manages three separate segments
/// of data: Prepend, Center, and Append. This allows for seamless bi-directional
/// scrolling using `CustomScrollView`'s `center` key feature.
///
/// The Center segment is the initial anchor point of the list, and:
/// - Prepend segment items appear above the Center (in reverse scroll direction)
/// - Append segment items appear below the Center
abstract class CenterDataSource<PageKey, Value>
    extends BaseDataSource<PageKey, Value, CenterPageManager<PageKey, Value>> {
  /// Creates a [CenterDataSource].
  /// Use `errorPolicy` to define which errors should be ignored visually.
  CenterDataSource({super.errorPolicy});

  /// The key used to anchor the `CustomScrollView` at the Center segment.
  ///
  /// This key is assigned to the Center sliver, making it the origin point
  /// of the scroll view. Slivers before the center will be laid out in
  /// reverse order (growing upward).
  final GlobalKey centerKey = GlobalKey();

  final _manager = CenterPageManager<PageKey, Value>();

  /// The underlying state manager for the data source.
  @override
  CenterPageManager<PageKey, Value> get notifier => _manager;

  /// Loads a page of data based on the specified [LoadAction].
  ///
  /// Your implementation should:
  /// 1. Determine the type of load action (`Refresh`, `Prepend`, `Append`).
  /// 2. Fetch data from your source (e.g., make an API call).
  /// 3. Return a [LoadResult] to represent the outcome.
  ///
  /// For `Refresh`, the returned data becomes the Center segment.
  /// For `Prepend`, the data is added to the Prepend segment.
  /// For `Append`, the data is added to the Append segment.
  @protected
  @override
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> action);
}
