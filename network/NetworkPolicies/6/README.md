# Task 6 — Port-specific egress + cross-namespace (exam level)

## Task

Namespace `np-6-backend` has pod `api` listening on ports **8080** and **9090**.  
Namespace `np-6-gateway` has two pods:
- `gateway-v1` — must reach only port **8080**
- `gateway-v2` — must reach only port **9090**

**Create two NetworkPolicies in namespace `np-6-gateway`:**
1. `gateway-v1` can reach `np-6-backend` only on port 8080
2. `gateway-v2` can reach `np-6-backend` only on port 9090

Both pods must retain DNS resolution.

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
# gateway-v1: 8080 OK, 9090 FAIL
kubectl -n np-6-gateway logs -f deploy/gateway-v1

# gateway-v2: 9090 OK, 8080 FAIL
kubectl -n np-6-gateway logs -f deploy/gateway-v2
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concepts

- Two egress rules in one policy are OR'd (port 8080 OR DNS)
- DNS must be a separate rule without `to` — kube-dns is in kube-system, not in np-6-backend
- `to` and `ports` are siblings inside one rule — `ports` restricts which ports on the destination
- Policy lives in the **sender's** namespace (np-6-gateway)

## Policy template

```yaml
spec:
  podSelector:
    matchLabels:
      app: gateway-v1
  policyTypes: [Egress]
  egress:
    - ports:           # rule 1: DNS to anywhere
        - port: 53
          protocol: UDP
    - to:              # rule 2: traffic to backend:8080
        - namespaceSelector: ...
          podSelector: ...
      ports:
        - port: 8080
```
