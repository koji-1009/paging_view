import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

class PageManager<PageKey, Value>
    extends ValueNotifier<PageManagerState<PageKey, Value>> {
  PageManager() : super(Paging.init());

  bool get isLoading => value.isLoading;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  List<Value> get values => value.items;

  void changeState(LoadType type) {
    value = Paging(
      state: LoadStateLoading(
        state: type,
      ),
      data: value.pages,
    );
  }

  void setError(Exception exception) {
    value = Warning(
      exception: exception,
    );
  }

  void refresh(PageData<PageKey, Value>? newPage) {
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

  void prepend(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = Paging(
        state: const LoadStateLoaded(),
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: const LoadStateLoaded(),
      data: [newPage, ...value.pages],
    );
  }

  void append(PageData<PageKey, Value>? newPage) {
    if (newPage == null) {
      value = Paging(
        state: const LoadStateLoaded(),
        data: value.pages,
      );
      return;
    }

    value = Paging(
      state: const LoadStateLoaded(),
      data: [...value.pages, newPage],
    );
  }
}
