import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 1;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> toggleTheme() async {
    final newState =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', newState.index);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
