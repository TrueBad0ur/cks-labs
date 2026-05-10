# Task 1 — Default Deny Ingress

## Task

Namespace `np-1` has two pods: `web` and `client`.  
`client` continuously curls `web:80`.

**Create a NetworkPolicy that denies all incoming traffic to pod `web`.**

After applying the policy, `client` logs should show `FAIL`.

## Apply environment

```bash
kubectl apply -f configs/
```

## Check before policy

```bash
kubectl -n np-1 logs -f deploy/client
# Expected: [web:80] OK
```

## Check after policy

```bash
kubectl -n np-1 logs -f deploy/client
# Expected: [web:80] FAIL/TIMEOUT
```

## Automated check

```bash
bash configs/verify.sh
```

## Hint

`podSelector: {}` selects all pods in the namespace.  
`policyTypes: [Ingress]` with no `ingress` rules = deny all incoming traffic.
