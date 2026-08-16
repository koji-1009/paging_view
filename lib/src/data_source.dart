import 'package:paging_view/src/private/base_data_source.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// The core of the paging_view library, acting as the bridge between a data
/// source (like a network API or local database) and the UI.
///
/// [DataSource] is an abstract class responsible for fetching paginated data,
/// managing pagination state (keys, loading status), and notifying UI widgets
/// of changes.
///
/// To use it, you must extend this class and implement the `load` method,
/// which contains your specific data-fetching logic. The [DataSource] then
/// handles the state of your data (loading, success, error) and provides it
/// to `paging_view` widgets like `PagingList` or `PagingGrid`.
abstract class DataSource<PageKey, Value>
    extends BaseDataSource<PageKey, Value, PageManager<PageKey, Value>> {
  /// Creates a [DataSource].
  /// Use `errorPolicy` to define which errors should be ignored visually.
  DataSource({super.errorPolicy});

  final _manager = PageManager<PageKey, Value>();

  /// The underlying state manager for the data source.
  ///
  /// This `ChangeNotifier` holds the current list of items, pagination state,
  /// and loading status. It is primarily used internally by `paging_view`
  /// widgets to listen for updates and rebuild the UI.
  @override
  PageManager<PageKey, Value> get notifier => _manager;
}
