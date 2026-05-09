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

URL="http://api.np-4-backend.svc.cluster.local"

echo "=== Task 4 verify ==="
check "trusted-client (clients, role=trusted) -> api ALLOWED"        np-4-clients trusted-client "$URL" "ok"
check "rogue-client   (clients, role=rogue)   -> api BLOCKED"        np-4-clients rogue-client   "$URL" "fail"
check "spy            (other,   role=trusted) -> api BLOCKED (AND)"  np-4-other   spy            "$URL" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK: AND condition works" || echo "ERROR: check AND vs OR in your policy"
