import 'package:flutter/material.dart';

class FavNotifier {
  static final FavNotifier _instance = FavNotifier._internal();

  factory FavNotifier() {
    return _instance;
  }

  FavNotifier._internal();

  ValueNotifier<bool> notifier = ValueNotifier(false);
}
