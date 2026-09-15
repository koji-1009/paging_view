import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent, ViewportOffset;
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

  group('padding before the center sliver is resolved like SliverPadding', () {
    const centerKey = ValueKey('center');
    const itemExtent = 100.0;

    Widget itemBox(String label) =>
        SizedBox(key: ValueKey(label), height: itemExtent);

    // Returns the area covered by the labels. Slivers growing in the reverse
    // direction order the children of a SliverMainAxisGroup differently from
    // the items of a single SliverList, so compare the covered area rather
    // than each item.
    Future<Rect> rectBeforeCenter(
      WidgetTester tester, {
      required bool reverse,
      required List<String> labels,
      required Widget sliver,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              key: UniqueKey(),
              reverse: reverse,
              center: centerKey,
              anchor: 0.5,
              slivers: [
                sliver,
                const SliverToBoxAdapter(
                  key: centerKey,
                  child: SizedBox(height: 50),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return labels
          .map((label) => tester.getRect(find.byKey(ValueKey(label))))
          .reduce((a, b) => a.expandToInclude(b));
    }

    Future<void> expectSameAsSliverPadding(
      WidgetTester tester, {
      required bool reverse,
      required List<String> labels,
      required Widget sliver,
    }) async {
      final expected = await rectBeforeCenter(
        tester,
        reverse: reverse,
        labels: labels,
        sliver: SliverPadding(
          padding: _padding,
          sliver: SliverList.list(
            children: [for (final label in labels) itemBox(label)],
          ),
        ),
      );
      final actual = await rectBeforeCenter(
        tester,
        reverse: reverse,
        labels: labels,
        sliver: sliver,
      );
      expect(actual, expected);
    }

    for (final reverse in [false, true]) {
      testWidgets('SliverPagingList (reverse: $reverse)', (tester) async {
        const items = ['Item 1', 'Item 2'];
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          reverse: reverse,
          labels: items,
          sliver: SliverPagingList<int, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            builder: (context, item, index) => itemBox(item),
          ),
        );
      });

      testWidgets('SliverPagingGrid (reverse: $reverse)', (tester) async {
        const items = ['Item 1', 'Item 2'];
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          reverse: reverse,
          labels: items,
          sliver: SliverPagingGrid<int, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: itemExtent,
            ),
            builder: (context, item, index) => itemBox(item),
          ),
        );
      });

      testWidgets('SliverGroupedPagingList (reverse: $reverse)', (
        tester,
      ) async {
        final dataSource = TestGroupedDataSource(
          initialItems: const ['A1', 'A2'],
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          reverse: reverse,
          labels: const ['Group A', 'A1', 'A2'],
          sliver: SliverGroupedPagingList<int, String, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            headerBuilder: (context, group, index) => itemBox(group),
            itemBuilder: (context, item, itemIndex, groupIndex) =>
                itemBox(item),
          ),
        );
      });

      testWidgets('SliverGroupedPagingGrid (reverse: $reverse)', (
        tester,
      ) async {
        final dataSource = TestGroupedDataSource(
          initialItems: const ['A1', 'A2'],
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          reverse: reverse,
          labels: const ['Group A', 'A1', 'A2'],
          sliver: SliverGroupedPagingGrid<int, String, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: itemExtent,
            ),
            headerBuilder: (context, group, index) => itemBox(group),
            itemBuilder: (context, item, itemIndex, groupIndex) =>
                itemBox(item),
          ),
        );
      });
    }
  });

  group('padding is resolved against the enclosing viewport', () {
    const itemExtent = 100.0;

    Widget itemBox(String label) =>
        SizedBox.square(key: ValueKey(label), dimension: itemExtent);

    Widget viewport(AxisDirection axisDirection, Widget sliver) => Viewport(
      axisDirection: axisDirection,
      offset: ViewportOffset.zero(),
      slivers: [sliver],
    );

    // Hosts without a Scrollable, and a horizontal viewport inside a vertical
    // Scrollable.
    final hosts = <String, Widget Function(Widget sliver)>{
      'Viewport down without a Scrollable': (sliver) => Directionality(
        textDirection: TextDirection.ltr,
        child: viewport(AxisDirection.down, sliver),
      ),
      'Viewport right without a Scrollable': (sliver) => Directionality(
        textDirection: TextDirection.ltr,
        child: viewport(AxisDirection.right, sliver),
      ),
      'Viewport right inside a vertical ListView': (sliver) => MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              SizedBox(
                height: 300,
                child: viewport(AxisDirection.right, sliver),
              ),
            ],
          ),
        ),
      ),
    };

    Future<Map<String, Rect>> rectsIn(
      WidgetTester tester, {
      required Widget Function(Widget sliver) host,
      required List<String> labels,
      required Widget sliver,
    }) async {
      await tester.pumpWidget(
        KeyedSubtree(key: UniqueKey(), child: host(sliver)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      return {
        for (final label in labels)
          label: tester.getRect(find.byKey(ValueKey(label))),
      };
    }

    Future<void> expectSameAsSliverPadding(
      WidgetTester tester, {
      required Widget Function(Widget sliver) host,
      required List<String> labels,
      required Widget sliver,
    }) async {
      final expected = await rectsIn(
        tester,
        host: host,
        labels: labels,
        sliver: SliverPadding(
          padding: _padding,
          sliver: SliverList.list(
            children: [for (final label in labels) itemBox(label)],
          ),
        ),
      );
      final actual = await rectsIn(
        tester,
        host: host,
        labels: labels,
        sliver: sliver,
      );
      expect(actual, expected);
    }

    for (final MapEntry(key: name, value: host) in hosts.entries) {
      testWidgets('SliverPagingList ($name)', (tester) async {
        const items = ['Item 1', 'Item 2'];
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          host: host,
          labels: items,
          sliver: SliverPagingList<int, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            builder: (context, item, index) => itemBox(item),
          ),
        );
      });

      testWidgets('SliverPagingGrid ($name)', (tester) async {
        const items = ['Item 1', 'Item 2'];
        final dataSource = TestDataSource(
          initialItems: items,
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          host: host,
          labels: items,
          sliver: SliverPagingGrid<int, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: itemExtent,
            ),
            builder: (context, item, index) => itemBox(item),
          ),
        );
      });

      testWidgets('SliverGroupedPagingList ($name)', (tester) async {
        final dataSource = TestGroupedDataSource(
          initialItems: const ['A1', 'A2'],
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          host: host,
          labels: const ['Group A', 'A1', 'A2'],
          sliver: SliverGroupedPagingList<int, String, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            headerBuilder: (context, group, index) => itemBox(group),
            itemBuilder: (context, item, itemIndex, groupIndex) =>
                itemBox(item),
          ),
        );
      });

      testWidgets('SliverGroupedPagingGrid ($name)', (tester) async {
        final dataSource = TestGroupedDataSource(
          initialItems: const ['A1', 'A2'],
          maxAppendPages: 0,
        );
        addTearDown(dataSource.dispose);

        await expectSameAsSliverPadding(
          tester,
          host: host,
          labels: const ['Group A', 'A1', 'A2'],
          sliver: SliverGroupedPagingGrid<int, String, String>(
            dataSource: dataSource,
            padding: _padding,
            autoLoadPrepend: false,
            autoLoadAppend: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: itemExtent,
            ),
            headerBuilder: (context, group, index) => itemBox(group),
            itemBuilder: (context, item, itemIndex, groupIndex) =>
                itemBox(item),
          ),
        );
      });
    }
  });
}
