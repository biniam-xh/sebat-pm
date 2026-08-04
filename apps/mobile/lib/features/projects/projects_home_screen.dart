import 'package:flutter/material.dart';

/// Projects mode stub (Track P fills in projects + kanban).
///
/// Must not import `features/chat`.
class ProjectsHomeScreen extends StatelessWidget {
  const ProjectsHomeScreen({super.key});

  static const _projects = [
    ('Mobile App', 'iOS + Android client'),
    ('Website Redesign', 'Marketing site'),
    ('Q3 Launch', 'Go-to-market checklist'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Projects',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Shared-team projects (Track P). Placeholder list only.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        for (final (name, subtitle) in _projects) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(name),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
        ],
      ],
    );
  }
}
