import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/auth_models.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_screen_layout.dart';

class TenantPickerScreen extends ConsumerWidget {
  const TenantPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final memberships = auth is AuthPickMembership ? auth.memberships : <Membership>[];
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.selectWorkspace,
      subtitle: AuthStrings.selectWorkspaceSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          if (loading)
            const Center(child: CupertinoActivityIndicator())
          else
            ...memberships.map((m) => _MembershipRow(membership: m)),
        ],
      ),
    );
  }
}

class _MembershipRow extends ConsumerWidget {
  const _MembershipRow({required this.membership});

  final Membership membership;

  String get _roleLabel => switch (membership.role) {
        LeoRoles.lspAdmin => 'LSP Admin',
        LeoRoles.subAdmin => 'Sub Admin',
        LeoRoles.interpreter => 'Interpreter',
        LeoRoles.customerUser => 'Customer',
        LeoRoles.customerAdmin => 'Customer Admin',
        LeoRoles.platformAdmin => 'Platform Admin',
        _ => membership.role,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: '${membership.tenantName}, $_roleLabel',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => ref
            .read(authNotifierProvider.notifier)
            .selectMembership(membership),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: LeoColors.black700,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LeoColors.black500),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership.tenantName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LeoColors.signalWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _roleLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: LeoColors.black200,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: LeoColors.black200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
