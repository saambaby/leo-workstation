import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_models.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import 'otp_input_row.dart';

class WorkspaceAvatarButton extends ConsumerStatefulWidget {
  const WorkspaceAvatarButton({super.key, required this.role});

  final String role;

  @override
  ConsumerState<WorkspaceAvatarButton> createState() =>
      _WorkspaceAvatarButtonState();
}

class _WorkspaceAvatarButtonState extends ConsumerState<WorkspaceAvatarButton> {
  var _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: AuthStrings.yourWorkspaces,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => setState(() => _menuOpen = !_menuOpen),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LeoColors.black600,
                shape: BoxShape.circle,
                border: Border.all(color: LeoColors.black400),
              ),
              child: Text(
                widget.role.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: LeoColors.black100,
                ),
              ),
            ),
          ),
        ),
        if (_menuOpen)
          Positioned(
            top: 48,
            right: 0,
            child: _WorkspaceMenu(
              onClose: () => setState(() => _menuOpen = false),
            ),
          ),
      ],
    );
  }
}

class _WorkspaceMenu extends ConsumerStatefulWidget {
  const _WorkspaceMenu({required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<_WorkspaceMenu> createState() => _WorkspaceMenuState();
}

class _WorkspaceMenuState extends ConsumerState<_WorkspaceMenu> {
  String? _expandedTenantId;
  var _loading = false;
  List<Membership> _memberships = const [];

  @override
  void initState() {
    super.initState();
    _loadMemberships();
  }

  Future<void> _loadMemberships() async {
    final list = await ref.read(authRepositoryProvider).listMemberships();
    if (mounted) setState(() => _memberships = list);
  }

  Future<void> _switchTo(Membership m, {String? mfaCode}) async {
    setState(() => _loading = true);
    await ref.read(authNotifierProvider.notifier).switchTenant(
          tenantId: m.tenantId,
          mfaCode: mfaCode,
        );
    if (mounted) {
      setState(() => _loading = false);
      final auth = ref.read(authNotifierProvider);
      if (auth is AuthAuthenticated || auth is AuthMfaRequired) {
        widget.onClose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final currentTenant = auth is AuthAuthenticated ? auth.tenantId : null;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: LeoColors.black800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LeoColors.black600),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Text(
              AuthStrings.yourWorkspaces,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LeoColors.signalWhite,
              ),
            ),
          ),
          ..._memberships.map((m) {
            final isCurrent = m.tenantId == currentTenant;
            final expanded = _expandedTenantId == m.tenantId;
            final privileged = roleRequiresMfa(m.role);

            return Column(
              children: [
                Semantics(
                  button: !privileged,
                  label: m.tenantName,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    onPressed: _loading
                        ? null
                        : () {
                            if (privileged) {
                              setState(
                                () => _expandedTenantId =
                                    expanded ? null : m.tenantId,
                              );
                            } else {
                              _switchTo(m);
                            }
                          },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.tenantName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isCurrent
                                      ? LeoColors.signalLive
                                      : LeoColors.signalWhite,
                                ),
                              ),
                              Text(
                                _roleLabel(m.role),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: LeoColors.black300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!privileged)
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            onPressed: _loading ? null : () => _switchTo(m),
                            child: const Text(
                              AuthStrings.switchWorkspace,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (expanded) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Column(
                      children: [
                        const Text(
                          AuthStrings.privilegedSwitchNote,
                          style: TextStyle(
                            fontSize: 11,
                            color: LeoColors.signalWarn,
                          ),
                        ),
                        const SizedBox(height: 10),
                        OtpInputRow(
                          enabled: !_loading,
                          onCompleted: (code) => _switchTo(m, mfaCode: code),
                        ),
                        const SizedBox(height: 8),
                        CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          onPressed: _loading
                              ? null
                              : () => _switchTo(m, mfaCode: '000000'),
                          child: const Text(
                            AuthStrings.verifyAndSwitch,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Container(height: 1, color: LeoColors.black600),
              ],
            );
          }),
          Semantics(
            button: true,
            label: AuthStrings.signOut,
            child: CupertinoButton(
              onPressed: () {
                widget.onClose();
                ref.read(authNotifierProvider.notifier).logout();
              },
              child: const Text(
                AuthStrings.signOut,
                style: TextStyle(color: LeoColors.signalError),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(String role) => switch (role) {
        LeoRoles.lspAdmin => 'LSP Admin',
        LeoRoles.subAdmin => 'Sub Admin',
        LeoRoles.interpreter => 'Interpreter',
        LeoRoles.platformAdmin => 'Platform Admin',
        _ => role,
      };
}
