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

echo "=== Task 3 verify ==="
check "caller (trusted)     -> api ALLOWED" np-3-trusted   caller   "http://api.np-3-backend.svc.cluster.local" "ok"
check "intruder (untrusted) -> api BLOCKED" np-3-untrusted intruder "http://api.np-3-backend.svc.cluster.local" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK" || echo "ERROR"
