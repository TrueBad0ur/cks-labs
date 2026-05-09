#!/usr/bin/env bash
set -euo pipefail
NS=np-1
PASS=0; FAIL=0

check() {
  local desc=$1 pod=$2 target=$3 expect=$4
  result=$(kubectl -n "$NS" exec "deploy/$pod" -- \
    curl -s --max-time 4 "$target" > /dev/null 2>&1 && echo "ok" || echo "fail")
  if [ "$result" = "$expect" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS+1))
  else
    echo "  FAIL: $desc (got=$result, want=$expect)"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Task 1 verify (policy must already be applied) ==="
check "client -> web BLOCKED" client "http://web.np-1.svc.cluster.local" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK: policy works correctly" || echo "ERROR: check your policy"
