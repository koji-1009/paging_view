import 'package:flutter/widgets.dart';

/// Create widget with [Value] type and index.
typedef TypedWidgetBuilder<Value> = Widget Function(
  BuildContext context,
  Value element,
  int index,
);

/// Create widget with [Exception].
typedef ExceptionWidgetBuilder = Widget Function(
  BuildContext context,
  Exception e,
);
