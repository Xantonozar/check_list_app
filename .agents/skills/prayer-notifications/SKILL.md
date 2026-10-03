---
name: prayer-notifications
description: >-
  Use this skill when implementing, configuring, or debugging the prayer time calculation engine 
  using the adhan package, geolocator location fetching, flutter_local_notifications scheduling, 
  and user-toggleable notification settings in the Muhasabat app.
---

# Prayer Times & Notifications Skill

This skill explains how to calculate daily Salat times offline and schedule 6 toggleable notifications.

## The 6 Daily Notifications

| Index | Notification Title (Bangla) | Calculation / Time | Default State |
|---|---|---|---|
| 1 | ফজরের সালাত | `adhan.PrayerTimes.fajr` | ON |
| 2 | যোহরের সালাত | `adhan.PrayerTimes.dhuhr` | ON |
| 3 | আসরের সালাত | `adhan.PrayerTimes.asr` | ON |
| 4 | মাগরিবের সালাত | `adhan.PrayerTimes.maghrib` | ON |
| 5 | ইশার সালাত | `adhan.PrayerTimes.isha` | ON |
| 6 | ঘুমের আগে যিকির | Configurable (Default: 22:30 / 10:30 PM) | ON |

## Calculation Flow with `adhan`

```dart
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerTimeHelper {
  static PrayerTimes calculateTimes(Position position, DateTime date) {
    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    return PrayerTimes(coordinates, DateComponents.from(date), params);
  }
}
```

## Scheduling Rules & Toggles

1. **User Toggles**: Store a Map `<String, bool>` of enabled notification keys in `SharedPreferences` / Firebase.
2. **Permission Handling**: Always request location (`geolocator.requestPermission()`) and notification permissions before scheduling.
3. **Daily Midnight Re-scheduling**:
   - Cancel existing daily notification IDs `[1..6]`.
   - Recalculate today's prayer times for current GPS coordinates.
   - For each prayer:
     - Check if `notificationEnabled == true`.
     - Check if target time is in the future.
     - Schedule using `flutter_local_notifications` with `tz.TZDateTime`.
