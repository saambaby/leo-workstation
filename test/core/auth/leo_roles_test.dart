import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/core/auth/leo_roles.dart';

void main() {
  group('roleDisplayLabel', () {
    test('display style returns human labels', () {
      expect(roleDisplayLabel(LeoRoles.lspAdmin), 'LSP Admin');
      expect(roleDisplayLabel(LeoRoles.interpreter), 'Interpreter');
      expect(roleDisplayLabel(LeoRoles.customerUser), 'Customer');
    });

    test('slug style returns canonical slugs', () {
      expect(
        roleDisplayLabel(LeoRoles.lspAdmin, style: RoleLabelStyle.slug),
        'lsp_admin',
      );
      expect(
        roleDisplayLabel(LeoRoles.customerAdmin, style: RoleLabelStyle.slug),
        'customer_admin',
      );
    });

    test('unknown role passes through', () {
      expect(roleDisplayLabel('custom_role'), 'custom_role');
    });
  });

  group('roleRequiresMfa', () {
    test('privileged roles require MFA', () {
      expect(roleRequiresMfa(LeoRoles.lspAdmin), isTrue);
      expect(roleRequiresMfa(LeoRoles.subAdmin), isTrue);
      expect(roleRequiresMfa(LeoRoles.platformAdmin), isTrue);
    });

    test('non-privileged roles do not require MFA', () {
      expect(roleRequiresMfa(LeoRoles.interpreter), isFalse);
      expect(roleRequiresMfa(LeoRoles.customerUser), isFalse);
    });
  });
}
