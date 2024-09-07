import 'package:flutter/material.dart';


class RefreshNotifier {
  static final RefreshNotifier _instance = RefreshNotifier._internal();

  factory RefreshNotifier() {
    return _instance;
  }

  RefreshNotifier._internal();

  ValueNotifier<bool> notifier = ValueNotifier(false);
}