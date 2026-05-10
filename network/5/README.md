# Task 5 — Egress restriction

## Task

Namespace `np-5-worker` has pod `worker`.  
`worker` continuously curls two services:
- `target` in namespace `np-5-allowed` — must work
- `blocked` in namespace `np-5-blocked` — must be blocked

**Create a NetworkPolicy in namespace `np-5-worker` that allows egress from `worker` only to namespace `np-5-allowed`. Traffic to `np-5-blocked` must be denied.**

Don't forget DNS.

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
kubectl -n np-5-worker logs -f deploy/worker
# Expected:
# [->allowed] OK
# [->blocked] FAIL/TIMEOUT
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concepts

- `policyTypes: [Egress]` — controls outgoing traffic
- Policy lives in the **sender's** namespace (`np-5-worker`)
- DNS (port 53) is blocked along with all other egress — must be explicitly allowed
- `namespaceSelector` in `egress.to` works the same as in `ingress.from`
