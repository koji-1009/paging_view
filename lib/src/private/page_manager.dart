import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// Manager class that manages [PageManagerState].
class PageManager<PageKey, Value>
    extends ValueNotifier<PageManagerState<PageKey, Value>> {
  /// Creates a [PageManager].
  PageManager({this.delay = const Duration(milliseconds: 100)})
    : super(Paging.init());

  /// The delay time for reflecting the request result in the UI.
  final Duration delay;

  bool get isLoading => value.isLoading;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  List<Value> get values => value.items;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void changeState({required LoadType type}) {
    if (_disposed) {
      return;
    }

    value = Paging(
      state: LoadStateLoading(state: type),
      data: value.pages,
    );
  }

  void setError({required Object error, required StackTrace? stackTrace}) {
    if (_disposed) {
      return;
    }

    value = Warning(error: error, stackTrace: stackTrace);
  }

  void refresh({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = const Paging(state: LoadStateLoaded(), data: []);
      return;
    }

    value = Paging(state: const LoadStateLoaded(), data: [newPage]);
  }

  Future<void> prepend({required PageData<PageKey, Value>? newPage}) async {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = Paging(state: const LoadStateLoaded(), data: value.pages);
      return;
    }

    value = Paging(
      state: const LoadStateLoading(state: LoadType.prepend),
      data: [newPage, ...value.pages],
    );

    // Reflect the request result in the UI
    await Future.delayed(delay);

    value = Paging(state: const LoadStateLoaded(), data: value.pages);
  }

  Future<void> append({required PageData<PageKey, Value>? newPage}) async {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = Paging(state: const LoadStateLoaded(), data: value.pages);
      return;
    }

    value = Paging(
      state: const LoadStateLoading(state: LoadType.append),
      data: [...value.pages, newPage],
    );

    // Reflect the request result in the UI
    await Future.delayed(delay);

    value = Paging(state: const LoadStateLoaded(), data: value.pages);
  }

  void updateItem(int index, Value Function(Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final items = currentValue.items;
      if (index < 0 || index >= items.length) {
        throw RangeError.index(index, items, 'index', null, items.length);
      }

      final itemToUpdate = items[index];
      final updatedItem = update(itemToUpdate);

      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final pageSize = page.data.length;
        final isTargetInThisPage =
            index >= itemIndexAcrossPages &&
            index < itemIndexAcrossPages + pageSize;

        if (isTargetInThisPage) {
          final indexInPage = index - itemIndexAcrossPages;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData[indexInPage] = updatedItem;

          updatedPages.add(
            PageData(
              data: updatedPageData,
              prependKey: page.prependKey,
              appendKey: page.appendKey,
            ),
          );
        } else {
          updatedPages.add(page);
        }

        itemIndexAcrossPages += pageSize;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  void updateItems(Value Function(int index, Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final updatedPageData = <Value>[];

        for (var i = 0; i < page.data.length; i++) {
          final globalIndex = itemIndexAcrossPages + i;
          final item = page.data[i];
          final updatedItem = update(globalIndex, item);
          updatedPageData.add(updatedItem);
        }

        updatedPages.add(
          PageData(
            data: updatedPageData,
            prependKey: page.prependKey,
            appendKey: page.appendKey,
          ),
        );

        itemIndexAcrossPages += page.data.length;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }
}
