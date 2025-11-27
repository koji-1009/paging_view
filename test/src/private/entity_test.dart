import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/private/entity.dart';

void main() {
  group('LoadState properties', () {
    test('LoadStateInit returns correct flags', () {
      const state = LoadStateInit();
      expect(state.isInit, isTrue);
      expect(state.isLoaded, isFalse);
      expect(state.isInitLoading, isFalse);
      expect(state.isRefreshLoading, isFalse);
      expect(state.isPrependLoading, isFalse);
      expect(state.isAppendLoading, isFalse);
    });

    test('LoadStateLoaded returns correct flags', () {
      const state = LoadStateLoaded();
      expect(state.isInit, isFalse);
      expect(state.isLoaded, isTrue);
      expect(state.isInitLoading, isFalse);
      expect(state.isRefreshLoading, isFalse);
      expect(state.isPrependLoading, isFalse);
      expect(state.isAppendLoading, isFalse);
    });

    test('LoadStateLoading (init) returns correct flags', () {
      const state = LoadStateLoading(state: LoadType.init);
      expect(state.isInit, isFalse);
      expect(state.isLoaded, isFalse);
      expect(state.isInitLoading, isTrue);
      expect(state.isRefreshLoading, isFalse);
      expect(state.isPrependLoading, isFalse);
      expect(state.isAppendLoading, isFalse);
    });

    test('LoadStateLoading (refresh) returns correct flags', () {
      const state = LoadStateLoading(state: LoadType.refresh);
      expect(state.isInit, isFalse);
      expect(state.isLoaded, isFalse);
      expect(state.isInitLoading, isFalse);
      expect(state.isRefreshLoading, isTrue);
      expect(state.isPrependLoading, isFalse);
      expect(state.isAppendLoading, isFalse);
    });

    test('LoadStateLoading (prepend) returns correct flags', () {
      const state = LoadStateLoading(state: LoadType.prepend);
      expect(state.isInit, isFalse);
      expect(state.isLoaded, isFalse);
      expect(state.isInitLoading, isFalse);
      expect(state.isRefreshLoading, isFalse);
      expect(state.isPrependLoading, isTrue);
      expect(state.isAppendLoading, isFalse);
    });

    test('LoadStateLoading (append) returns correct flags', () {
      const state = LoadStateLoading(state: LoadType.append);
      expect(state.isInit, isFalse);
      expect(state.isLoaded, isFalse);
      expect(state.isInitLoading, isFalse);
      expect(state.isRefreshLoading, isFalse);
      expect(state.isPrependLoading, isFalse);
      expect(state.isAppendLoading, isTrue);
    });
  });
}
