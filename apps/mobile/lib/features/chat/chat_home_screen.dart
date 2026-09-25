import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:sebatpm/data/team/team_bootstrap.dart';

/// Chat mode stub (Track C fills in realtime channels).
///
/// Must not import `features/projects`.
class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late Future<List<String>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _channelsFuture = _loadChannels();
  }

  Future<List<String>> _loadChannels() async {
    try {
      if (Firebase.apps.isEmpty) {
        return const ['#general'];
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('channels')
          .where('workspaceId', isEqualTo: TeamBootstrap.defaultTeamId)
          .get();

      final channels = snapshot.docs
          .map((doc) => '#${doc.data()['name'] ?? TeamBootstrap.generalChannelName}')
          .toList();

      if (channels.isEmpty) {
        return const ['#general'];
      }

      return channels;
    } catch (_) {
      return const ['#general'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<String>>(
      future: _channelsFuture,
      builder: (context, snapshot) {
        final channels = snapshot.data ?? const ['#general'];

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
                    for (final name in channels)
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
      },
    );
  }
}
