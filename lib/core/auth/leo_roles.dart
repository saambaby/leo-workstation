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
