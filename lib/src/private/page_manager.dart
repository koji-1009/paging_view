import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

class PageManager<PageKey, Value>
    extends ValueNotifier<NotifierState<PageKey, Value>> {
  PageManager() : super(NotifierState.init());

  bool get isLoading => value.isLoading;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  void clear() {
    value = NotifierState.init();
  }

  void setLoading(LoadType type) {
    value = switch (type) {
      LoadType.refresh => const NotifierState(
          state: NotifierLoadingState.initLoading,
          data: [],
        ),
      LoadType.prepend => NotifierState(
          state: NotifierLoadingState.prependLoading,
          data: value.pages,
        ),
      LoadType.append => NotifierState(
          state: NotifierLoadingState.appendLoading,
          data: value.pages,
        ),
    };
  }

  void setError(Exception e) {
    value = NotifierState.error(
      e: e,
    );
  }

  void prepend(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = NotifierState(
        state: NotifierLoadingState.loaded,
        data: value.pages,
      );
      return;
    }

    value = NotifierState(
      state: NotifierLoadingState.loaded,
      data: [newPage, ...value.pages],
    );
  }

  void append(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = NotifierState(
        state: NotifierLoadingState.loaded,
        data: value.pages,
      );
      return;
    }

    value = NotifierState(
      state: NotifierLoadingState.loaded,
      data: [...value.pages, newPage],
    );
  }
}
