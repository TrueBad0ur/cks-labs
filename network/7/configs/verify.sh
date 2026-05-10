#!/usr/bin/env bash
set -euo pipefail
NS=np-7
PASS=0; FAIL=0

check_curl() {
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

check_wget() {
  local desc=$1 pod=$2 target=$3 expect=$4
  result=$(kubectl -n "$NS" exec "deploy/$pod" -- \
    wget -q -O- --timeout=4 "$target" > /dev/null 2>&1 && echo "ok" || echo "fail")
  if [ "$result" = "$expect" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS+1))
  else
    echo "  FAIL: $desc (got=$result, want=$expect)"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Task 7 verify ==="
check_curl "producer  -> processor:8080 ALLOWED"  producer  "http://processor.np-7.svc.cluster.local:8080" "ok"
check_curl "intruder  -> processor:8080 BLOCKED"  intruder  "http://processor.np-7.svc.cluster.local:8080" "fail"
check_wget "processor -> consumer:9090  ALLOWED"  processor "http://consumer.np-7.svc.cluster.local:9090"  "ok"

echo ""
echo "Result: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "OK: ingress + egress on same pod works" || echo "ERROR"
