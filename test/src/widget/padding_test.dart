import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_center_data_source.dart';
import '../../helper/test_data_source.dart';

const _padding = EdgeInsets.fromLTRB(16, 8, 24, 32);
const _extent = 300.0;

Widget _box(String label) =>
    SizedBox.square(key: ValueKey(label), dimension: _extent);

typedef _Layout = ({
  double minScrollExtent,
  double maxScrollExtent,
  Map<String, Rect> atMin,
  Map<String, Rect> atMax,
});

void main() {
  const configs = [
    (axis: Axis.vertical, reverse: false, textDirection: TextDirection.ltr),
    (axis: Axis.vertical, reverse: true, textDirection: TextDirection.ltr),
    (axis: Axis.horizontal, reverse: false, textDirection: TextDirection.ltr),
    (axis: Axis.horizontal, reverse: true, textDirection: TextDirection.ltr),
    (axis: Axis.horizontal, reverse: false, textDirection: TextDirection.rtl),
  ];

  Future<_Layout> measure(
    WidgetTester tester, {
    required List<String> labels,
    required TextDirection textDirection,
    required Widget Function(ScrollController controller) build,
  }) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(body: build(controller)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Map<String, Rect> rects() => {
      for (final label in labels)
        if (find.byKey(ValueKey(label)).evaluate().isNotEmpty)
          label: tester.getRect(find.byKey(ValueKey(label))),
    };

    final position = controller.position;
    controller.jumpTo(position.minScrollExtent);
    await tester.pumpAndSettle();
    final atMin = rects();
    controller.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();
    final atMax = rects();

    return (
      minScrollExtent: position.minScrollExtent,
      maxScrollExtent: position.maxScrollExtent,
      atMin: atMin,
      atMax: atMax,
    );
  }

  Future<void> expectSameLayoutAsListView(
    WidgetTester tester, {
    required List<String> labels,
    required ({Axis axis, bool reverse, TextDirection textDirection}) config,
    required Widget Function(ScrollController controller) build,
  }) async {
    final expected = await measure(
      tester,
      labels: labels,
      textDirection: config.textDirection,
      build: (controller) => ListView(
        controller: controller,
        scrollDirection: config.axis,
        reverse: config.reverse,
        padding: _padding,
        children: [for (final label in labels) _box(label)],
      ),
    );
    final actual = await measure(
      tester,
      labels: labels,
      textDirection: config.textDirection,
      build: build,
    );

    expect(
      actual.maxScrollExtent - actual.minScrollExtent,
      expected.maxScrollExtent - expected.minScrollExtent,
    );
    expect(actual.atMin, expected.atMin);
    expect(actual.atMax, expected.atMax);
  }

  group('padding is resolved like ListView', () {
    const items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

    for (final config in configs) {
      final description =
          '${config.axis.name}, reverse: ${config.reverse}, '
          '${config.textDirection.name}';

      testWidgets('PagingList ($description)', (tester) async {
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameLayoutAsListView(
          tester,
          labels: items,
          config: config,
          build: (controller) => PagingList<int, String>(
            dataSource: dataSource,
            controller: controller,
            scrollDirection: config.axis,
            reverse: config.reverse,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            builder: (context, item, index) => _box(item),
          ),
        );
      });

      testWidgets('PagingGrid ($description)', (tester) async {
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameLayoutAsListView(
          tester,
          labels: items,
          config: config,
          build: (controller) => PagingGrid<int, String>(
            dataSource: dataSource,
            controller: controller,
            scrollDirection: config.axis,
            reverse: config.reverse,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: _extent,
            ),
            builder: (context, item, index) => _box(item),
          ),
        );
      });

      const groupedItems = ['A1', 'A2', 'B1', 'B2'];
      const groupedLabels = ['Group A', 'A1', 'A2', 'Group B', 'B1', 'B2'];

      testWidgets('GroupedPagingList ($description)', (tester) async {
        final dataSource = TestGroupedDataSource(
          initialItems: groupedItems,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameLayoutAsListView(
          tester,
          labels: groupedLabels,
          config: config,
          build: (controller) => GroupedPagingList<int, String, String>(
            dataSource: dataSource,
            controller: controller,
            scrollDirection: config.axis,
            reverse: config.reverse,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            headerBuilder: (context, group, index) => _box(group),
            itemBuilder: (context, item, itemIndex, groupIndex) => _box(item),
          ),
        );
      });

      testWidgets('GroupedPagingGrid ($description)', (tester) async {
        final dataSource = TestGroupedDataSource(
          initialItems: groupedItems,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameLayoutAsListView(
          tester,
          labels: groupedLabels,
          config: config,
          build: (controller) => GroupedPagingGrid<int, String, String>(
            dataSource: dataSource,
            controller: controller,
            scrollDirection: config.axis,
            reverse: config.reverse,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: _extent,
            ),
            headerBuilder: (context, group, index) => _box(group),
            itemBuilder: (context, item, itemIndex, groupIndex) => _box(item),
          ),
        );
      });

      testWidgets('CenterPagingList ($description)', (tester) async {
        final dataSource = TestCenterDataSource(
          initialItems: items,
          maxPrependPages: 0,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameLayoutAsListView(
          tester,
          labels: items,
          config: config,
          build: (controller) => CenterPagingList<int, String>(
            dataSource: dataSource,
            controller: controller,
            scrollDirection: config.axis,
            reverse: config.reverse,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            prependLoadStateBuilder: (context, hasMore, isLoading) =>
                const SizedBox.shrink(),
            appendLoadStateBuilder: (context, hasMore, isLoading) =>
                const SizedBox.shrink(),
            builder: (context, item, index) => _box(item),
          ),
        );
      });
    }
  });

  group('padding does not shrink the leading cache area', () {
    const itemExtent = 50.0;
    const scrollCacheExtent = ScrollCacheExtent.pixels(250);
    final items = [for (var i = 0; i < 200; i++) 'A$i'];

    Widget smallBox(String label) =>
        SizedBox.square(key: ValueKey(label), dimension: itemExtent);

    // Returns the labels built at 2000px past the start of the content.
    Future<Set<String>> builtLabels(
      WidgetTester tester, {
      required double top,
      required List<String> labels,
      required Widget Function(ScrollController controller, EdgeInsets padding)
      build,
    }) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: build(controller, EdgeInsets.only(top: top))),
        ),
      );
      await tester.pumpAndSettle();
      controller.jumpTo(top + 2000);
      await tester.pumpAndSettle();

      return {
        for (final label in labels)
          if (find
              .byKey(ValueKey(label), skipOffstage: false)
              .evaluate()
              .isNotEmpty)
            label,
      };
    }

    Future<void> expectSameCacheAsWithoutPadding(
      WidgetTester tester, {
      required List<String> labels,
      required Widget Function(ScrollController controller, EdgeInsets padding)
      build,
    }) async {
      final expected = await builtLabels(
        tester,
        top: 0,
        labels: labels,
        build: build,
      );
      final actual = await builtLabels(
        tester,
        top: 100,
        labels: labels,
        build: build,
      );
      expect(actual, expected);
    }

    testWidgets('PagingList', (tester) async {
      final dataSource = TestDataSource(initialItems: items, maxAppendPages: 0);
      addTearDown(dataSource.dispose);

      await expectSameCacheAsWithoutPadding(
        tester,
        labels: items,
        build: (controller, padding) => PagingList<int, String>(
          dataSource: dataSource,
          controller: controller,
          padding: padding,
          scrollCacheExtent: scrollCacheExtent,
          autoLoadPrepend: false,
          autoLoadAppend: false,
          builder: (context, item, index) => smallBox(item),
        ),
      );
    });

    testWidgets('PagingGrid', (tester) async {
      final dataSource = TestDataSource(initialItems: items, maxAppendPages: 0);
      addTearDown(dataSource.dispose);

      await expectSameCacheAsWithoutPadding(
        tester,
        labels: items,
        build: (controller, padding) => PagingGrid<int, String>(
          dataSource: dataSource,
          controller: controller,
          padding: padding,
          scrollCacheExtent: scrollCacheExtent,
          autoLoadPrepend: false,
          autoLoadAppend: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: itemExtent,
          ),
          builder: (context, item, index) => smallBox(item),
        ),
      );
    });

    testWidgets('GroupedPagingList', (tester) async {
      final dataSource = TestGroupedDataSource(
        initialItems: items,
        maxAppendPages: 0,
      );
      addTearDown(dataSource.dispose);

      await expectSameCacheAsWithoutPadding(
        tester,
        labels: items,
        build: (controller, padding) => GroupedPagingList<int, String, String>(
          dataSource: dataSource,
          controller: controller,
          padding: padding,
          scrollCacheExtent: scrollCacheExtent,
          autoLoadPrepend: false,
          autoLoadAppend: false,
          headerBuilder: (context, group, index) => smallBox(group),
          itemBuilder: (context, item, itemIndex, groupIndex) => smallBox(item),
        ),
      );
    });

    testWidgets('GroupedPagingGrid', (tester) async {
      final dataSource = TestGroupedDataSource(
        initialItems: items,
        maxAppendPages: 0,
      );
      addTearDown(dataSource.dispose);

      await expectSameCacheAsWithoutPadding(
        tester,
        labels: items,
        build: (controller, padding) => GroupedPagingGrid<int, String, String>(
          dataSource: dataSource,
          controller: controller,
          padding: padding,
          scrollCacheExtent: scrollCacheExtent,
          autoLoadPrepend: false,
          autoLoadAppend: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: itemExtent,
          ),
          headerBuilder: (context, group, index) => smallBox(group),
          itemBuilder: (context, item, itemIndex, groupIndex) => smallBox(item),
        ),
      );
    });
  });
}
