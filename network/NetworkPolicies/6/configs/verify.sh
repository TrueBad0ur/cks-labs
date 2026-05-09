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

API="api.np-6-backend.svc.cluster.local"

echo "=== Task 6 verify ==="
check "gateway-v1 -> api:8080 ALLOWED" np-6-gateway gateway-v1 "http://$API:8080" "ok"
check "gateway-v1 -> api:9090 BLOCKED" np-6-gateway gateway-v1 "http://$API:9090" "fail"
check "gateway-v2 -> api:9090 ALLOWED" np-6-gateway gateway-v2 "http://$API:9090" "ok"
check "gateway-v2 -> api:8080 BLOCKED" np-6-gateway gateway-v2 "http://$API:8080" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK: port-specific egress works" || echo "ERROR"
