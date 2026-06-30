import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/auth_models.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_ui_provider.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';

class TenantPickerScreen extends ConsumerWidget {
  const TenantPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.selectWorkspaceSub,
      error: ui.errorMessage,
      width: AuthCardWidth.wide,
      child: ui.isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ui.pickMemberships
                  .map((m) => _MembershipRow(membership: m))
                  .toList(),
            ),
    );
  }
}

class _MembershipRow extends ConsumerWidget {
  const _MembershipRow({required this.membership});

  final Membership membership;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleLabel = roleDisplayLabel(
      membership.role,
      style: RoleLabelStyle.slug,
    );

    return Semantics(
      button: true,
      label: '${membership.tenantName}, $roleLabel',
      child: GestureDetector(
        onTap: () => ref
            .read(authNotifierProvider.notifier)
            .selectMembership(membership),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: LeoColors.black800,
            borderRadius: BorderRadius.circular(LeoRadii.md),
            border: Border.all(color: LeoColors.black600),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership.tenantName,
                      style: LeoTypography.listRowTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(roleLabel, style: LeoTypography.listRowMeta),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: LeoColors.black300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
