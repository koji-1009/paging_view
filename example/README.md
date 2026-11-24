# paging_view example

A demo app for [paging_view](https://pub.dev/packages/paging_view), also available as a [live preview](https://koji-1009.github.io/paging_view/).

It shows the following screens, switched with the bottom navigation bar:

* **List**: `PagingList` with pull-to-refresh.
* **Grid**: `PagingGrid` with pull-to-refresh.
* **Grouped**: `SliverGroupedPagingList` with sticky headers, powered by a `GroupedDataSource`.
* **Manual**: `SliverPagingList` with automatic loading disabled and a "Load More" button built with `AppendLoadStateBuilder`.
* **Centered**: `CenterPagingList` loading in both directions from a center anchor, with "Load Previous" and "Load More" buttons.

The data sources are in `lib/model/` and are provided with Riverpod.

## Running

```sh
flutter pub get
flutter run
```
