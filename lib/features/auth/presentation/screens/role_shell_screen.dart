import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/platform/external_url.dart';
import '../../../../core/shell/workstation_scaffold.dart';
import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/workspace_switcher.dart';

/// Wraps role-home content in [WorkstationScaffold] with workspace chrome.
class RoleShellScreen extends ConsumerWidget {
  const RoleShellScreen({
    super.key,
    required this.persona,
    required this.title,
    required this.routeLabel,
    required this.railItems,
    required this.child,
  });

  final String persona;
  final String title;
  final String routeLabel;
  final List<Widget> railItems;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final role = auth is AuthAuthenticated ? auth.role : LeoRoles.interpreter;
    final tenantId = auth is AuthAuthenticated ? auth.tenantId : null;

    return WorkstationScaffold(
      role: role,
      railLogo: _RailLogo(persona: persona),
      railItems: railItems,
      tenantChip: TenantChip(tenantId: tenantId, role: role),
      avatar: WorkspaceAvatarButton(role: role),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PageHeader(title: title, routeLabel: routeLabel),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _RailLogo extends StatelessWidget {
  const _RailLogo({required this.persona});

  final String persona;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: LeoColors.signalWhite,
          letterSpacing: 0.06 * 15,
        ),
        children: [
          const TextSpan(text: 'LEO '),
          TextSpan(
            text: persona,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: LeoColors.black300,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.routeLabel});

  final String title;
  final String routeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: LeoColors.black900,
        border: Border(bottom: BorderSide(color: LeoColors.black600)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: LeoColors.signalWhite,
                ),
              ),
              Text(
                routeLabel,
                style: const TextStyle(
                  fontSize: 10,
                  color: LeoColors.black300,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TenantChip extends StatelessWidget {
  const TenantChip({super.key, required this.tenantId, required this.role});

  final String? tenantId;
  final String role;

  @override
  Widget build(BuildContext context) {
    final label = tenantId == null
        ? 'Tenant-less · ${roleDisplayLabel(role)}'
        : 'Active workspace · ${roleDisplayLabel(role)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: LeoColors.black700,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LeoColors.black500),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: LeoColors.black100),
      ),
    );
  }
}

class WebHandoffScreen extends ConsumerWidget {
  const WebHandoffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(appConfigProvider).webAdminBaseUrl;

    return CupertinoPageScaffold(
      backgroundColor: LeoColors.black900,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AuthStrings.webHandoffTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: LeoColors.signalWhite,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  AuthStrings.webHandoffSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LeoColors.black100, height: 1.4),
                ),
                const SizedBox(height: 24),
                if (url.isNotEmpty)
                  Semantics(
                    button: true,
                    label: AuthStrings.openWebDashboard,
                    child: CupertinoButton.filled(
                      onPressed: () => launchExternalUrl(url),
                      child: const Text(AuthStrings.openWebDashboard),
                    ),
                  ),
                const SizedBox(height: 16),
                Semantics(
                  button: true,
                  label: AuthStrings.signOut,
                  child: CupertinoButton(
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).logout(),
                    child: const Text(AuthStrings.signOut),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlockedSurfaceScreen extends StatelessWidget {
  const BlockedSurfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: LeoColors.black900,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.device_phone_portrait,
                  size: 48,
                  color: LeoColors.black200,
                ),
                SizedBox(height: 16),
                Text(
                  AuthStrings.blockedSurfaceTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: LeoColors.signalWhite,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  AuthStrings.blockedSurfaceSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LeoColors.black100, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPlaceholderScreen extends StatelessWidget {
  const OnboardingPlaceholderScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: LeoColors.black900,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Onboarding'),
      ),
      child: Center(
        child: Text(
          'Onboarding placeholder ($path)',
          style: const TextStyle(color: LeoColors.black100),
        ),
      ),
    );
  }
}
