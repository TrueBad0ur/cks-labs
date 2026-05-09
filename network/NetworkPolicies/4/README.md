# Task 4 — AND condition: namespaceSelector + podSelector

## Task

Namespace `np-4-backend` has pod `api`.  
Namespace `np-4-clients` has two pods:
- `trusted-client` (label: `role=trusted`)
- `rogue-client` (label: `role=rogue`)

Namespace `np-4-other` has pod `spy` (label: `role=trusted`).

**Create a NetworkPolicy that allows ingress to `api` only from pods with label `role=trusted` AND only from namespace `np-4-clients`.  
`spy` from a different namespace — even with the correct label — must be blocked.**

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
kubectl -n np-4-clients logs -f deploy/trusted-client   # OK
kubectl -n np-4-clients logs -f deploy/rogue-client     # FAIL
kubectl -n np-4-other   logs -f deploy/spy              # FAIL (correct label, wrong namespace)
```

## Automated check

```bash
bash configs/verify.sh
```

## KEY TRAP: AND vs OR

```yaml
# CORRECT — AND (namespace AND pod label — one list item):
ingress:
  - from:
      - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: np-4-clients
        podSelector:                    # same dash as namespaceSelector = AND
            matchLabels:
              role: trusted

# WRONG — OR (two separate list items = OR):
ingress:
  - from:
      - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: np-4-clients
      - podSelector:                    # separate dash = OR
            matchLabels:
              role: trusted
```

The difference is **one dash or two**. One dash before `namespaceSelector` = AND.
