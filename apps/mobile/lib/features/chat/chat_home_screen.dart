import 'package:flutter/material.dart';

/// Chat mode stub (Track C fills in realtime channels).
///
/// Must not import `features/projects`.
class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  static const _channels = ['#general', '#standup', '#design', '#eng'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Material(
            color: theme.colorScheme.surfaceContainerLowest,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'Channels',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                for (final name in _channels)
                  ListTile(
                    dense: true,
                    selected: name == '#general',
                    title: Text(name),
                    onTap: () {},
                  ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '#general',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Welcome to SebatPM Chat.\n'
                      '#general is the default channel; #standup is reserved '
                      'for the standup bot (seeded with team bootstrap).',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'Message #general (coming soon)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: null,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
