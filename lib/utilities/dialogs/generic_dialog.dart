import 'package:flutter/material.dart';

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required Map<String, T?> Function() optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).pop(options[optionTitle]);
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
