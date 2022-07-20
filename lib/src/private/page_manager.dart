import 'package:flutter_paging/src/entity.dart';
import 'package:flutter_paging/src/private/entity.dart';
import 'package:state_notifier/state_notifier.dart';

class PageManager<Value, PageKey>
    extends StateNotifier<NotifierState<Value, PageKey>> {
  PageManager() : super(NotifierState.init());

  bool get isLoading => state.isLoading;

  PageKey? get prependPageKey => state.prependPageKey;

  PageKey? get appendPageKey => state.appendPageKey;

  void clear() {
    state = NotifierState.init();
  }

  void setLoading(LoadType type) {
    switch (type) {
      case LoadType.refresh:
        state = const NotifierState(
          state: NotifierLoadingState.initLoading,
          data: [],
        );
        break;
      case LoadType.prepend:
        state = NotifierState(
          state: NotifierLoadingState.prependLoading,
          data: state.pages,
        );
        break;
      case LoadType.append:
        state = NotifierState(
          state: NotifierLoadingState.appendLoading,
          data: state.pages,
        );
        break;
    }
  }

  void setError(Exception? e) {
    state = NotifierState.error(
      e: e,
    );
  }

  void prepend(PageData<Value, PageKey>? newPage) {
    if (newPage == null) {
      state = NotifierState(
        state: NotifierLoadingState.loaded,
        data: state.pages,
      );
      return;
    }

    state = NotifierState(
      state: NotifierLoadingState.loaded,
      data: [newPage, ...state.pages],
    );
  }

  void append(PageData<Value, PageKey>? newPage) {
    if (newPage == null) {
      state = NotifierState(
        state: NotifierLoadingState.loaded,
        data: state.pages,
      );
      return;
    }

    state = NotifierState(
      state: NotifierLoadingState.loaded,
      data: [...state.pages, newPage],
    );
  }
}
