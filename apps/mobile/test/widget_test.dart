import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sebatpm/app/app.dart';
import 'package:sebatpm/app/app_mode.dart';
import 'package:sebatpm/app/app_shell.dart';
import 'package:sebatpm/data/integration/task_ref.dart';
import 'package:sebatpm/data/team/team_bootstrap.dart';
import 'package:sebatpm/firebase_options.dart';

import 'fake_auth_repository.dart';

void main() {
  testWidgets('signed-out cold start shows Google sign-in', (tester) async {
    final auth = FakeAuthRepository.signedOut();
    addTearDown(auth.dispose);

    await tester.pumpWidget(SebatPmApp(authRepository: auth));
    await tester.pump();

    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('#general'), findsNothing);
  });

  testWidgets('cold start signed-in shows Chat mode by default', (tester) async {
    final auth = FakeAuthRepository.signedIn();
    addTearDown(auth.dispose);

    await tester.pumpWidget(SebatPmApp(authRepository: auth));
    await tester.pump();

    expect(find.text('SebatPM'), findsOneWidget);
    expect(find.text('#general'), findsWidgets);
    expect(find.text('Channels'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.byTooltip('Sign out'), findsOneWidget);
  });

  testWidgets('sign out returns to sign-in screen', (tester) async {
    final auth = FakeAuthRepository.signedIn();
    addTearDown(auth.dispose);

    await tester.pumpWidget(SebatPmApp(authRepository: auth));
    await tester.pump();

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();

    expect(auth.signOutCalls, 1);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('#general'), findsNothing);
  });

  testWidgets('mode switch shows Projects stub', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(),
      ),
    );

    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(find.text('Mobile App'), findsOneWidget);
    expect(find.text('Website Redesign'), findsOneWidget);
  });

  testWidgets('AppShell can start on Projects when requested', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(initialMode: AppMode.projects),
      ),
    );

    expect(find.text('Mobile App'), findsOneWidget);
  });

  test('TaskStatus wire names match architecture', () {
    expect(TaskStatus.inProgress.wireName, 'in_progress');
    expect(TaskStatus.parse('in_review'), TaskStatus.inReview);
  });

  test('TeamBootstrap returns shared default team', () async {
    final result = await const TeamBootstrap().ensureReady();
    expect(result.teamId, TeamBootstrap.defaultTeamId);
    expect(result.generalChannelId, TeamBootstrap.generalChannelName);
    expect(result.standupChannelId, TeamBootstrap.standupChannelName);
  });

  test('Firebase options expose a projectId for bootstrap', () {
    expect(DefaultFirebaseOptions.android.projectId, isNotEmpty);
    expect(DefaultFirebaseOptions.android.apiKey, isNotEmpty);
  });
}
