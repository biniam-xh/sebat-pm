import 'package:sebatpm/data/integration/task_ref.dart';

/// PM calls this contract; Chat owns the message write schema.
///
/// Stub until Track I (T-020) wires Firestore.
abstract interface class BoardChannelPoster {
  Future<void> postStatusChange({
    required String channelId,
    required TaskRef task,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
  });
}

/// No-op poster for shell / tests.
class NoOpBoardChannelPoster implements BoardChannelPoster {
  const NoOpBoardChannelPoster();

  @override
  Future<void> postStatusChange({
    required String channelId,
    required TaskRef task,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
  }) async {}
}
