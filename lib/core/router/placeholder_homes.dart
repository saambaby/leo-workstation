import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../features/auth/presentation/screens/role_shell_screen.dart';

class IdleHomeScreen extends ConsumerWidget {
  const IdleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleShellScreen(
      persona: 'interpreter',
      title: 'Idle',
      routeLabel: '/idle',
      railItems: [
        _RailNavItem(
          label: 'Idle',
          active: true,
          onTap: () => context.go('/idle'),
        ),
        _RailNavItem(
          label: 'Requests',
          onTap: () => context.go('/idle/requests'),
        ),
      ],
      child: const Center(
        child: Text(
          'Interpreter idle — placeholder (P2)',
          style: TextStyle(color: LeoColors.black100),
        ),
      ),
    );
  }
}

class CallHomeScreen extends ConsumerWidget {
  const CallHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleShellScreen(
      persona: 'customer',
      title: 'New call',
      routeLabel: '/call',
      railItems: [
        _RailNavItem(
          label: 'New call',
          active: true,
          onTap: () => context.go('/call'),
        ),
        _RailNavItem(
          label: 'My Requests',
          onTap: () => context.go('/call/requests'),
        ),
      ],
      child: const Center(
        child: Text(
          'Customer call — placeholder (P2)',
          style: TextStyle(color: LeoColors.black100),
        ),
      ),
    );
  }
}

class DispatchHomeScreen extends ConsumerWidget {
  const DispatchHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleShellScreen(
      persona: 'dispatch',
      title: 'Live board',
      routeLabel: '/dispatch',
      railItems: [
        _RailNavItem(
          label: 'Unassigned',
          active: true,
          onTap: () => context.go('/dispatch'),
        ),
        _RailNavItem(
          label: 'In progress',
          onTap: () => context.go('/dispatch/active'),
        ),
      ],
      child: const Center(
        child: Text(
          'Dispatch board — placeholder (P2)',
          style: TextStyle(color: LeoColors.black100),
        ),
      ),
    );
  }
}

class _RailNavItem extends StatelessWidget {
  const _RailNavItem({
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        alignment: Alignment.centerLeft,
        onPressed: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: active ? LeoColors.black600 : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: active ? LeoColors.signalWhite : LeoColors.black200,
            ),
          ),
        ),
      ),
    );
  }
}
