/// Lightweight task reference for chat chips and deep links.
class TaskRef {
  const TaskRef({
    required this.taskId,
    required this.title,
    required this.status,
  });

  final String taskId;
  final String title;
  final TaskStatus status;
}

/// Fixed MVP status enum (matches architecture).
enum TaskStatus {
  backlog,
  ready,
  inProgress,
  inReview,
  done;

  String get wireName => switch (this) {
        TaskStatus.backlog => 'backlog',
        TaskStatus.ready => 'ready',
        TaskStatus.inProgress => 'in_progress',
        TaskStatus.inReview => 'in_review',
        TaskStatus.done => 'done',
      };

  static TaskStatus parse(String value) {
    return switch (value) {
      'backlog' => TaskStatus.backlog,
      'ready' => TaskStatus.ready,
      'in_progress' => TaskStatus.inProgress,
      'in_review' => TaskStatus.inReview,
      'done' => TaskStatus.done,
      _ => throw FormatException('Unknown task status: $value'),
    };
  }
}
