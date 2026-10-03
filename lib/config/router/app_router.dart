import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/reports/presentation/pages/report_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/tasks/presentation/pages/add_task_page.dart';
import '../../features/tasks/presentation/pages/all_tasks_page.dart';
import '../../features/tasks/presentation/pages/task_detail_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/sign-in',
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const AllTasksPage(),
          ),
          GoRoute(
            path: '/task/:id',
            builder: (context, state) {
              final taskId = state.pathParameters['id']!;
              return TaskDetailPage(taskId: taskId);
            },
          ),
          GoRoute(
            path: '/add-task',
            builder: (context, state) => const AddTaskPage(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      if (!isAuthenticated && !isAuthRoute) return '/sign-in';
      if (isAuthenticated && isAuthRoute) return '/';
      return null;
    },
  );
}
