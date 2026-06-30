/// Canonical JWT role slugs (INV-CLIENT-AUTH-2). Referenced by shell, auth, router.
abstract final class LeoRoles {
  static const interpreter = 'interpreter';
  static const customerUser = 'customer_user';
  static const customerAdmin = 'customer_admin';
  static const subAdmin = 'sub_admin';
  static const lspAdmin = 'lsp_admin';
  static const platformAdmin = 'platform_admin';
}

/// Privileged roles that require MFA on login and switch-tenant.
bool roleRequiresMfa(String role) =>
    role == LeoRoles.platformAdmin ||
    role == LeoRoles.lspAdmin ||
    role == LeoRoles.subAdmin;

enum RoleLabelStyle { display, slug }

/// Single source of truth for role labels in UI and semantics.
String roleDisplayLabel(
  String role, {
  RoleLabelStyle style = RoleLabelStyle.display,
}) {
  if (style == RoleLabelStyle.slug) {
    return switch (role) {
      LeoRoles.lspAdmin => 'lsp_admin',
      LeoRoles.subAdmin => 'sub_admin',
      LeoRoles.interpreter => 'interpreter',
      LeoRoles.customerUser => 'customer_user',
      LeoRoles.customerAdmin => 'customer_admin',
      LeoRoles.platformAdmin => 'platform_admin',
      _ => role,
    };
  }

  return switch (role) {
    LeoRoles.lspAdmin => 'LSP Admin',
    LeoRoles.subAdmin => 'Sub Admin',
    LeoRoles.interpreter => 'Interpreter',
    LeoRoles.customerUser => 'Customer',
    LeoRoles.customerAdmin => 'Customer Admin',
    LeoRoles.platformAdmin => 'Platform Admin',
    _ => role,
  };
}
