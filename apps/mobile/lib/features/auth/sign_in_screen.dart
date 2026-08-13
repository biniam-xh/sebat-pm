import 'package:flutter/material.dart';

import 'package:sebatpm/features/auth/auth_repository.dart';

/// Google Sign-In entry screen (email/Apple deferred).
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _onGooglePressed() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.authRepository.signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _friendlyError(e);
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.contains('GooglePlayServices') ||
        text.contains('SERVICE_VERSION_UPDATE_REQUIRED') ||
        text.contains('SERVICE_OUTDATED') ||
        text.contains('out of date')) {
      return 'Google Play Services on this emulator is outdated.\n'
          'Open the Play Store → update “Google Play services”, '
          'then add a Google account and try again.';
    }
    if (text.contains('No credential') ||
        text.contains('no_credential') ||
        text.contains('ApiException: 10') ||
        text.contains('DEVELOPER_ERROR')) {
      return 'Google Sign-In is not ready on this device.\n'
          'Add a Google account in Android Settings → Passwords & accounts, '
          'confirm Google is enabled in Firebase Auth, and that the app SHA-1 '
          'matches Firebase.';
    }
    if (text.contains('network') || text.contains('NETWORK')) {
      return 'Network error during Google Sign-In. Check connectivity and try again.';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                'SebatPM',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue to Chat and Projects.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (_error != null) ...[
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton.icon(
                onPressed: _busy ? null : _onGooglePressed,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                label: Text(_busy ? 'Signing in…' : 'Continue with Google'),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
