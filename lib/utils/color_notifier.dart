import 'package:flutter/material.dart';


class AccentNotifier {
  static final AccentNotifier _instance = AccentNotifier._internal();

  factory AccentNotifier() {
    return _instance;
  }

  AccentNotifier._internal();

  ValueNotifier<bool> notifier = ValueNotifier(false);
}