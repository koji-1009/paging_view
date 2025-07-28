import 'package:flutter/widgets.dart';

/// Create widget with [Value] type and index.
typedef TypedWidgetBuilder<Value> =
    Widget Function(BuildContext context, Value element, int index);

/// Create widget with error [Object].
typedef ExceptionWidgetBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);
