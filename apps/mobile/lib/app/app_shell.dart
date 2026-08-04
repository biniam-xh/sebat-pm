import 'package:flutter/material.dart';

import 'package:sebatpm/app/app_mode.dart';
import 'package:sebatpm/features/chat/chat_home_screen.dart';
import 'package:sebatpm/features/projects/projects_home_screen.dart';

/// Dual-mode shell: Chat (default) | Projects.
///
/// Chat and Projects screens must not import each other — only this shell
/// composes them.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialMode = AppMode.chat});

  final AppMode initialMode;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late AppMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SebatPM'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SegmentedButton<AppMode>(
              segments: const [
                ButtonSegment<AppMode>(
                  value: AppMode.chat,
                  label: Text('Chat'),
                  icon: Icon(Icons.chat_bubble_outline, size: 18),
                ),
                ButtonSegment<AppMode>(
                  value: AppMode.projects,
                  label: Text('Projects'),
                  icon: Icon(Icons.view_kanban_outlined, size: 18),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (next) {
                setState(() => _mode = next.single);
              },
            ),
          ),
        ),
      ),
      body: switch (_mode) {
        AppMode.chat => const ChatHomeScreen(),
        AppMode.projects => const ProjectsHomeScreen(),
      },
    );
  }
}
