import 'package:flutter/material.dart';

import 'package:sebatpm/app/app_shell.dart';
import 'package:sebatpm/features/projects/task_detail_stub_screen.dart';

/// Named routes for the shell and deep-link stubs.
abstract final class AppRoutes {
  static const home = '/';
  static const chatChannel = '/chat';
  static const pmTask = '/pm/tasks';

  static String chatChannelPath(String channelId) => '$chatChannel/$channelId';
  static String pmTaskPath(String taskId) => '$pmTask/$taskId';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? AppRoutes.home;

    if (name == AppRoutes.home) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AppShell(),
      );
    }

    if (name.startsWith('${AppRoutes.chatChannel}/')) {
      final channelId = name.substring(AppRoutes.chatChannel.length + 1);
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => AppShell(key: ValueKey('chat-$channelId')),
      );
    }

    if (name.startsWith('${AppRoutes.pmTask}/')) {
      final taskId = name.substring(AppRoutes.pmTask.length + 1);
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => TaskDetailStubScreen(taskId: taskId),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Unknown route: ${settings.name}'),
        ),
      ),
    );
  }
}
