import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesStorage {
  SharedPreferencesStorage._();

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<void> setTheme(ThemeMode status) async {
    final prefs = await _instance;
    await prefs.setInt(AppKey.themeStatusKey, status.index);
  }

  static Future<ThemeMode> getTheme() async {
    final prefs = await _instance;
    final int? statusIndex = prefs.getInt(AppKey.themeStatusKey);
    return ThemeMode.values[statusIndex ?? ThemeMode.system.index];
  }
}
