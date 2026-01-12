import 'package:flutter/widgets.dart';

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    return ModalRoute.of(this)?.settings.arguments as T?;
  }
}
