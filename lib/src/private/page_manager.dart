import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

class PageManager<PageKey, Value>
    extends ValueNotifier<NotifierState<PageKey, Value>> {
  PageManager() : super(Paging.init());

  bool get isLoading => value.isLoading;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  void clear() {
    value = Paging.init();
  }

  void setLoading(LoadType type) {
    value = switch (type) {
      LoadType.refresh => const Paging(
          state: LoadState.initLoading,
          data: [],
        ),
      LoadType.prepend => Paging(
          state: LoadState.prependLoading,
          data: value.pages,
        ),
      LoadType.append => Paging(
          state: LoadState.appendLoading,
          data: value.pages,
        ),
    };
  }

  void setError(Exception e) {
    value = Warning(
      e: e,
    );
  }

  void prepend(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = Paging(
        state: LoadState.loaded,
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: LoadState.loaded,
      data: [newPage, ...value.pages],
    );
  }

  void append(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = Paging(
        state: LoadState.loaded,
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: LoadState.loaded,
      data: [...value.pages, newPage],
    );
  }
}
