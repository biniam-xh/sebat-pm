import 'package:flutter/material.dart';

/// Deep-link target stub until Track P ships real task detail.
class TaskDetailStubScreen extends StatelessWidget {
  const TaskDetailStubScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task')),
      body: Center(
        child: Text('Task detail stub\n$taskId'),
      ),
    );
  }
}
