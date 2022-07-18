import 'package:flutter/widgets.dart';

typedef TypedWidgetBuilder<Value> = Widget Function(
  BuildContext context,
  Value element,
  int index,
);

typedef ExceptionWidgetBuilder = Widget Function(
  BuildContext context,
  Exception? e,
);
