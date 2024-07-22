import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// Manager class that manages [PageManagerState].
class PageManager<PageKey, Value>
    extends ValueNotifier<PageManagerState<PageKey, Value>> {
  /// Creates a [PageManager].
  PageManager({
    this.delay = const Duration(
      milliseconds: 100,
    ),
  }) : super(Paging.init());

  /// The delay time for reflecting the request result in the UI.
  final Duration delay;

  bool get isLoading => value.isLoading;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  List<Value> get values => value.items;

  void changeState({
    required LoadType type,
  }) {
    value = Paging(
      state: LoadStateLoading(
        state: type,
      ),
      data: value.pages,
    );
  }

  void setError({
    required Exception exception,
  }) {
    value = Warning(
      exception: exception,
    );
  }

  void refresh({
    required PageData<PageKey, Value>? newPage,
  }) {
    if (newPage == null) {
      value = const Paging(
        state: LoadStateLoaded(),
        data: [],
      );
      return;
    }

    value = Paging(
      state: const LoadStateLoaded(),
      data: [newPage],
    );
  }

  Future<void> prepend({
    required PageData<PageKey, Value>? newPage,
  }) async {
    if (newPage == null) {
      value = Paging(
        state: const LoadStateLoaded(),
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: const LoadStateLoading(
        state: LoadType.prepend,
      ),
      data: [newPage, ...value.pages],
    );

    // Reflect the request result in the UI
    await Future.delayed(delay);

    value = Paging(
      state: const LoadStateLoaded(),
      data: value.pages,
    );
  }

  Future<void> append({
    required PageData<PageKey, Value>? newPage,
  }) async {
    if (newPage == null) {
      value = Paging(
        state: const LoadStateLoaded(),
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: const LoadStateLoading(
        state: LoadType.append,
      ),
      data: [...value.pages, newPage],
    );

    // Reflect the request result in the UI
    await Future.delayed(delay);

    value = Paging(
      state: const LoadStateLoaded(),
      data: value.pages,
    );
  }
}
