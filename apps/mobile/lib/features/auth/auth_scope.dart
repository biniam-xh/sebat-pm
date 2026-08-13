import 'package:flutter/material.dart';

import 'package:sebatpm/features/auth/auth_repository.dart';

/// Inherited access to [AuthRepository] for sign-out and session helpers.
class AuthScope extends InheritedWidget {
  const AuthScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final AuthRepository repository;

  static AuthRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found in widget tree');
    return scope!.repository;
  }

  static AuthRepository? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthScope>()?.repository;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) {
    return repository != oldWidget.repository;
  }
}
