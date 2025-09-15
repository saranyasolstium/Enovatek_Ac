import 'package:flutter/material.dart';

class AppState {
  // Singleton instance
  static final AppState _instance = AppState._internal();

  factory AppState() => _instance;

  AppState._internal();

  final ValueNotifier<String> selectedCountryNotifier =
      ValueNotifier<String>('sg');

  final ValueNotifier<int> selectedCountryIdNotifier = ValueNotifier<int>(6);
}
