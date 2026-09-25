import 'package:cloud_firestore/cloud_firestore.dart';

/// Default workspace bootstrap for Track S / T-005.
///
/// The product supports multiple workspaces in the model, but the MVP bootstrap
/// path always creates one default workspace named "Sebat" and ensures the
/// default channel `#general` exists for it.
class TeamBootstrap {
  const TeamBootstrap({
    this.teamId = defaultTeamId,
    this.firestore,
  });

  static const defaultTeamId = 'default';
  static const defaultWorkspaceName = 'Sebat';
  static const generalChannelName = 'general';
  static const standupChannelName = 'standup';

  final String teamId;
  final FirebaseFirestore? firestore;

  Future<TeamBootstrapResult> ensureReady() async {
    final activeFirestore = firestore ?? FirebaseFirestore.instance;
    final workspaceRef = activeFirestore.collection('workspaces').doc(teamId);
    final workspaceSnapshot = await workspaceRef.get();

    var seeded = false;

    if (!workspaceSnapshot.exists) {
      await workspaceRef.set({
        'name': defaultWorkspaceName,
        'timezone': 'UTC',
        'createdAt': FieldValue.serverTimestamp(),
      });
      seeded = true;
    }

    final channelsRef = activeFirestore.collection('channels');
    final generalQuery = await channelsRef
        .where('workspaceId', isEqualTo: teamId)
        .where('name', isEqualTo: generalChannelName)
        .limit(1)
        .get();

    if (generalQuery.docs.isEmpty) {
      await channelsRef.doc(generalChannelName).set({
        'workspaceId': teamId,
        'name': generalChannelName,
        'type': 'general',
        'createdBy': 'system',
        'createdAt': FieldValue.serverTimestamp(),
      });
      seeded = true;
    }

    final workspaceData = (await workspaceRef.get()).data() ?? const <String, dynamic>{};
    final generalDocRef = channelsRef.doc(generalChannelName);
    final generalChannelSnapshot = await generalDocRef.get();

    return TeamBootstrapResult(
      teamId: teamId,
      workspaceName: (workspaceData['name'] as String?) ?? defaultWorkspaceName,
      generalChannelId: generalChannelSnapshot.exists
          ? generalChannelSnapshot.id
          : generalChannelName,
      standupChannelId: standupChannelName,
      seeded: seeded,
    );
  }
}

class TeamBootstrapResult {
  const TeamBootstrapResult({
    required this.teamId,
    required this.workspaceName,
    required this.generalChannelId,
    required this.standupChannelId,
    required this.seeded,
  });

  final String teamId;
  final String workspaceName;
  final String generalChannelId;
  final String standupChannelId;

  /// True when this call created the default workspace or general channel.
  final bool seeded;
}
