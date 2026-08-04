/// Implicit shared-team bootstrap (Track S / T-005).
///
/// MVP has no create-workspace UI. Bootstrap ensures team metadata and
/// `#general` exist once Firebase is wired.
class TeamBootstrap {
  const TeamBootstrap({this.teamId = defaultTeamId});

  static const defaultTeamId = 'default';
  static const generalChannelName = 'general';
  static const standupChannelName = 'standup';

  final String teamId;

  /// Placeholder until Cloud Function / Firestore seed lands in T-005.
  Future<TeamBootstrapResult> ensureReady() async {
    return const TeamBootstrapResult(
      teamId: defaultTeamId,
      generalChannelId: generalChannelName,
      standupChannelId: standupChannelName,
      seeded: false,
    );
  }
}

class TeamBootstrapResult {
  const TeamBootstrapResult({
    required this.teamId,
    required this.generalChannelId,
    required this.standupChannelId,
    required this.seeded,
  });

  final String teamId;
  final String generalChannelId;
  final String standupChannelId;

  /// True when this call created seed channels; false when they already existed
  /// or seed is not yet wired.
  final bool seeded;
}
