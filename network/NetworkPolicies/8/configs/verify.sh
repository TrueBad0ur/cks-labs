#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0

check_curl() {
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

check_wget() {
  local desc=$1 ns=$2 pod=$3 target=$4 expect=$5
  result=$(kubectl -n "$ns" exec "deploy/$pod" -- \
    wget -q -O- --timeout=4 "$target" > /dev/null 2>&1 && echo "ok" || echo "fail")
  if [ "$result" = "$expect" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS+1))
  else
    echo "  FAIL: $desc (got=$result, want=$expect)"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Task 8 verify ==="
check_curl "frontend -> backend:8080 ALLOWED"  np-8-frontend frontend "http://backend.np-8-backend.svc.cluster.local:8080" "ok"
check_curl "frontend -> db:5432      BLOCKED"  np-8-frontend frontend "http://db.np-8-db.svc.cluster.local:5432"           "fail"
check_wget "backend  -> db:5432      ALLOWED"  np-8-backend  backend  "http://db.np-8-db.svc.cluster.local:5432"           "ok"
check_wget "db       -> backend:8080 BLOCKED"  np-8-db       db       "http://backend.np-8-backend.svc.cluster.local:8080" "fail"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK: three-tier isolation works" || echo "ERROR"
