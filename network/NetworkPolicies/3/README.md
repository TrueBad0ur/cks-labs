# Task 3 — Cross-namespace ingress (namespaceSelector)

## Task

Two namespaces exist: `np-3-trusted` and `np-3-untrusted`.  
Pod `api` lives in namespace `np-3-backend`.

- `caller` from `np-3-trusted` curls `api`
- `intruder` from `np-3-untrusted` curls `api`

**Create a NetworkPolicy in namespace `np-3-backend` that allows ingress to `api` only from namespace `np-3-trusted`. Traffic from `np-3-untrusted` must be blocked.**

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
# caller (trusted) — expected OK
kubectl -n np-3-trusted logs -f deploy/caller

# intruder (untrusted) — expected FAIL/TIMEOUT
kubectl -n np-3-untrusted logs -f deploy/intruder
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concepts

- `namespaceSelector` identifies a namespace by its label
- Every namespace automatically has `kubernetes.io/metadata.name: <name>` label
- `namespaceSelector: {}` allows traffic from ALL namespaces
