class NotificationSettings {
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final bool nightDhikr;
  final String nightDhikrTime;

  const NotificationSettings({
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.nightDhikr = true,
    this.nightDhikrTime = "22:30",
  });

  Map<String, dynamic> toMap() => {
    'fajr': fajr,
    'dhuhr': dhuhr,
    'asr': asr,
    'maghrib': maghrib,
    'isha': isha,
    'nightDhikr': nightDhikr,
    'nightDhikrTime': nightDhikrTime,
  };

  factory NotificationSettings.fromMap(Map<String, dynamic> map) =>
    NotificationSettings(
      fajr: map['fajr'] ?? true,
      dhuhr: map['dhuhr'] ?? true,
      asr: map['asr'] ?? true,
      maghrib: map['maghrib'] ?? true,
      isha: map['isha'] ?? true,
      nightDhikr: map['nightDhikr'] ?? true,
      nightDhikrTime: map['nightDhikrTime'] ?? "22:30",
    );

  NotificationSettings copyWith({
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    bool? nightDhikr,
    String? nightDhikrTime,
  }) => NotificationSettings(
    fajr: fajr ?? this.fajr,
    dhuhr: dhuhr ?? this.dhuhr,
    asr: asr ?? this.asr,
    maghrib: maghrib ?? this.maghrib,
    isha: isha ?? this.isha,
    nightDhikr: nightDhikr ?? this.nightDhikr,
    nightDhikrTime: nightDhikrTime ?? this.nightDhikrTime,
  );
}
