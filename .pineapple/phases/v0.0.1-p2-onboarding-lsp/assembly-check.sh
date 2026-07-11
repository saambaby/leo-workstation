#!/usr/bin/env bash
# Phase v0.0.1-p2-onboarding-lsp assembly check — generated from integration_contract by /pineapple:workorders.
# Prints one "ASSEMBLY pass|fail <field> <detail>" line per check; exit 1 if any fail.
# The orchestrator emits one assembly_check event per line.
set -uo pipefail
fail=0
chk() { local name="$1"; shift; if "$@" >/dev/null 2>&1; then echo "ASSEMBLY pass $name"; else echo "ASSEMBLY fail $name"; fail=1; fi; }

# integration_contract.owner_task: LSP-T-01 — wire facts for signup_lsp.
# Guard later-wave UI symbols behind file existence so wave-1 boundaries can still pass.

chk "wire.SignupPath.lsp" \
  bash -c 'grep -qE "^\s*lsp,?\s*$" lib/core/auth/domain/email_verification.dart'

chk "wire.verifyEmailLocation.path-lsp" \
  bash -c 'grep -q "SignupPath.lsp" lib/core/auth/domain/email_verification.dart'

chk "dto.SignupLspRequestDto" \
  bash -c 'grep -q "SignupLspRequestDto" lib/core/auth/data/dto/auth_dto.dart'

chk "dto.SignupLspRequestDto.business_type_lsp" \
  bash -c 'grep -qE "@Default\('\''lsp'\''\)|@Default\(\"lsp\"\)" lib/core/auth/data/dto/auth_dto.dart'

chk "dto.ConsentDto.baa_ack" \
  bash -c 'grep -q "baa_ack" lib/core/auth/data/dto/auth_dto.dart'

chk "repo.signupLsp" \
  bash -c 'grep -q "signupLsp" lib/core/auth/data/auth_repository.dart'

chk "repo.signupLsp.uses_SignupLspRequestDto" \
  bash -c 'grep -q "SignupLspRequestDto" lib/core/auth/data/auth_repository.dart'

chk "repo.signupLsp.posts_baaAck" \
  bash -c 'grep -A40 "Future<SignupResult> signupLsp" lib/core/auth/data/auth_repository.dart | grep -q "baaAck"'

chk "route.verify-email.path-lsp" \
  bash -c 'grep -q "SignupPath.lsp" lib/features/onboarding/presentation/routes/onboarding_routes.dart'

# Wave-2 UI (LSP-T-02) — only assert when the notifier already has submitLsp (post T-02).
if grep -q "submitLsp" lib/features/onboarding/presentation/notifiers/signup_notifier.dart 2>/dev/null; then
  chk "ui.submitLsp" \
    bash -c 'grep -q "submitLsp" lib/features/onboarding/presentation/notifiers/signup_notifier.dart'
  chk "ui.type-screen.no-launchUrl" \
    bash -c '! grep -q "launchUrl" lib/features/onboarding/presentation/screens/signup_type_screen.dart'
  chk "ui.details.baaAck" \
    bash -c 'grep -qE "_baaAck|baaAck" lib/features/onboarding/presentation/screens/signup_details_screen.dart'
  chk "ui.strings.acceptBaa" \
    bash -c 'grep -q "acceptBaa" lib/features/onboarding/l10n/onboarding_strings.dart'
else
  echo "ASSEMBLY pass ui.wave2-deferred (submitLsp not present yet)"
fi

# No runtime ports / env in this phase's integration_contract (Flutter client; env: []).
echo "ASSEMBLY pass env.none-declared"

exit $fail
