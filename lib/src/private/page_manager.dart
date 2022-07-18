import 'package:flutter_paging/src/entity.dart';
import 'package:flutter_paging/src/private/entity.dart';
import 'package:state_notifier/state_notifier.dart';

class PageManager<Value, Key> extends StateNotifier<NotifierState<Value, Key>> {
  PageManager() : super(NotifierState.init());

  bool get isLoading => state.isLoading;

  Key? get prependKey => state.prependKey;

  Key? get appendKey => state.appendKey;

  void clear() {
    state = NotifierState.init();
  }

  void setLoading(LoadType type) {
    switch (type) {
      case LoadType.refresh:
        state = NotifierState.init();
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

  void prepend(PageData<Value, Key>? newPage) {
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

  void append(PageData<Value, Key>? newPage) {
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
