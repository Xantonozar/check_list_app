import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/notification_settings.dart';

class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings.fromMap({
      'fajr': prefs.getBool('notif_fajr'),
      'dhuhr': prefs.getBool('notif_dhuhr'),
      'asr': prefs.getBool('notif_asr'),
      'maghrib': prefs.getBool('notif_maghrib'),
      'isha': prefs.getBool('notif_isha'),
      'nightDhikr': prefs.getBool('notif_nightDhikr'),
      'nightDhikrTime': prefs.getString('notif_nightDhikrTime'),
    });
  }

  Future<void> toggle(String key) async {
    final updated = switch (key) {
      'fajr' => state.copyWith(fajr: !state.fajr),
      'dhuhr' => state.copyWith(dhuhr: !state.dhuhr),
      'asr' => state.copyWith(asr: !state.asr),
      'maghrib' => state.copyWith(maghrib: !state.maghrib),
      'isha' => state.copyWith(isha: !state.isha),
      'nightDhikr' => state.copyWith(nightDhikr: !state.nightDhikr),
      _ => state,
    };
    state = updated;
    await _save(updated);
  }

  Future<void> setNightDhikrTime(String time) async {
    final updated = state.copyWith(nightDhikrTime: time);
    state = updated;
    await _save(updated);
  }

  Future<void> _save(NotificationSettings s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_fajr', s.fajr);
    await prefs.setBool('notif_dhuhr', s.dhuhr);
    await prefs.setBool('notif_asr', s.asr);
    await prefs.setBool('notif_maghrib', s.maghrib);
    await prefs.setBool('notif_isha', s.isha);
    await prefs.setBool('notif_nightDhikr', s.nightDhikr);
    await prefs.setString('notif_nightDhikrTime', s.nightDhikrTime);
  }
}

final notificationSettingsNotifierProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);
