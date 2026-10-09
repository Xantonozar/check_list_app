import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/constants/app_strings.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/notification_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(notificationSettingsNotifierProvider);
    final notifNotifier = ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassmorphicCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  title: const Text('থিম'),
                  subtitle: Text(
                    theme.brightness == Brightness.dark ? 'ডার্ক মোড' : 'লাইট মোড',
                  ),
                  trailing: Switch(
                    value: theme.brightness == Brightness.dark,
                    onChanged: (_) =>
                        ref.read(themeProvider.notifier).toggleTheme(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    AppStrings.notifications,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.wb_twilight,
                  title: AppStrings.fajrNotification,
                  value: settings.fajr,
                  onChanged: (_) => notifNotifier.toggle('fajr'),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.wb_sunny,
                  title: AppStrings.dhuhrNotification,
                  value: settings.dhuhr,
                  onChanged: (_) => notifNotifier.toggle('dhuhr'),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.cloud,
                  title: AppStrings.asrNotification,
                  value: settings.asr,
                  onChanged: (_) => notifNotifier.toggle('asr'),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.wb_twilight,
                  title: AppStrings.maghribNotification,
                  value: settings.maghrib,
                  onChanged: (_) => notifNotifier.toggle('maghrib'),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.nightlight,
                  title: AppStrings.ishaNotification,
                  value: settings.isha,
                  onChanged: (_) => notifNotifier.toggle('isha'),
                ),
                _buildNotificationTile(
                  context,
                  icon: Icons.book,
                  title: AppStrings.nightDhikrNotification,
                  value: settings.nightDhikr,
                  onChanged: (_) => notifNotifier.toggle('nightDhikr'),
                ),
                if (settings.nightDhikr)
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text(AppStrings.nightDhikrTime),
                    trailing: Text(
                      settings.nightDhikrTime,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _parseTime(settings.nightDhikrTime),
                      );
                      if (time != null) {
                        final formatted =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        await notifNotifier.setNightDhikrTime(formatted);
                      }
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassmorphicCard(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                AppStrings.signOut,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) context.go('/sign-in');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.reports,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'সেটিংস',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/reports');
        },
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
