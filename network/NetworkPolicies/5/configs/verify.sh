#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0

check() {
  local desc=$1 ns=$2 pod=$3 target=$4 expect=$5
  result=$(kubectl -n "$ns" exec "deploy/$pod" -- \
    curl -s --max-time 4 "$target" > /dev/null 2>&1 && echo "ok" || echo "fail")
  if [ "$result" = "$expect" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS+1))
  else
    echo "  FAIL: $desc (got=$result, want=$expect)"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Task 5 verify ==="
check "worker -> allowed ALLOWED" np-5-worker worker "http://target.np-5-allowed.svc.cluster.local"  "ok"
check "worker -> blocked BLOCKED" np-5-worker worker "http://blocked.np-5-blocked.svc.cluster.local" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK" || echo "ERROR: did you add DNS?"
