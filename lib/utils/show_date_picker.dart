import 'package:flutter/material.dart';

Future<DateTime?> showCustomDatePicker(
    {required BuildContext context,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate}) async {
  DateTime? date = await showDatePicker(
    context: context,
    barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    locale: const Locale('en', 'GB'),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Theme.of(context).colorScheme.primary,
            surface: Theme.of(context).colorScheme.surfaceContainer,
            onSurface: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      );
    },
  );

  return date;
}
