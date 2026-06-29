import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/leo_roles.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

/// Shared workstation chrome (P1-T-02): left rail slots + header tenant-chip /
/// avatar mounts. Per-role rail *contents* are injected by each feature.
class WorkstationScaffold extends ConsumerWidget {
  const WorkstationScaffold({
    super.key,
    required this.role,
    required this.railItems,
    required this.body,
    this.railLogo,
    this.railFooter,
    this.tenantChip,
    this.avatar,
  });

  /// Active membership role slug (e.g. `lsp_admin`) — drives admin-link visibility.
  final String role;

  /// Role-specific navigation items rendered in the left rail.
  final List<Widget> railItems;

  /// Main content area (feature-owned screens mount here).
  final Widget body;

  /// Optional logo / persona label above rail items (e.g. "LEO · dispatch").
  final Widget? railLogo;

  /// Optional widgets above the built-in admin link in the rail footer.
  final Widget? railFooter;

  /// Active-tenant status label in the header (non-interactive).
  final Widget? tenantChip;

  /// Avatar mount — parent wraps with tap handler for the workspace menu.
  final Widget? avatar;

  static const _railWidth = 220.0;
  static const _headerHeight = 56.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final showAdminLink =
        role == LeoRoles.lspAdmin && config.webAdminBaseUrl.isNotEmpty;

    return ColoredBox(
      color: LeoColors.black900,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _railWidth,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: LeoColors.black800,
                border: Border(
                  right: BorderSide(color: LeoColors.black600),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (railLogo != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                      child: railLogo,
                    ),
                  ],
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: railItems,
                    ),
                  ),
                  if (railFooter != null || showAdminLink)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 1,
                            color: LeoColors.black600,
                          ),
                          if (railFooter != null) ...[
                            const SizedBox(height: 10),
                            railFooter!,
                          ],
                          if (showAdminLink) ...[
                            const SizedBox(height: 10),
                            _AdminDashboardLink(url: config.webAdminBaseUrl),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (tenantChip != null || avatar != null)
                  SizedBox(
                    height: _headerHeight,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: LeoColors.black900,
                        border: Border(
                          bottom: BorderSide(color: LeoColors.black600),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          children: [
                            const Spacer(),
                            if (tenantChip != null) ...[
                              tenantChip!,
                              const SizedBox(width: 12),
                            ],
                            ?avatar,
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminDashboardLink extends StatelessWidget {
  const _AdminDashboardLink({required this.url});

  final String url;

  Future<void> _open() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Admin dashboard',
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 6),
        minimumSize: Size.zero,
        alignment: Alignment.centerLeft,
        onPressed: _open,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.arrow_up_right_square,
              size: 14,
              color: LeoColors.black200,
            ),
            SizedBox(width: 8),
            Text(
              'Admin dashboard',
              style: TextStyle(
                fontSize: 11,
                color: LeoColors.black200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
