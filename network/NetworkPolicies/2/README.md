# Task 2 — Allow Ingress from a specific pod

## Task

Namespace `np-2` has three pods: `backend`, `frontend`, `other`.  
Both `frontend` and `other` continuously curl `backend:80`.

**Create a NetworkPolicy that allows ingress to `backend` only from pod `frontend` on port 80. All other connections to `backend` must be denied.**

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
# frontend can reach backend — expected OK
kubectl -n np-2 logs -f deploy/frontend

# other cannot reach backend — expected FAIL/TIMEOUT
kubectl -n np-2 logs -f deploy/other
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concepts

- `podSelector` in `spec.podSelector` — which pods this policy applies to
- `podSelector` in `ingress.from` — which pods are allowed to send traffic
- These are two different podSelectors with different meanings
