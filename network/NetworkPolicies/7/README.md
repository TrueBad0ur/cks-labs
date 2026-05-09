# Task 7 — Combined Ingress + Egress on the same pod

## Task

Namespace `np-7` has four pods: `producer`, `processor`, `consumer`, `intruder`.

- `producer` sends to `processor:8080`
- `processor` sends to `consumer:9090`
- `intruder` tries to reach `processor:8080` and `consumer:9090`

**Create a single NetworkPolicy for pod `processor` that:**
1. Allows ingress only from `producer` on port 8080
2. Allows egress only to `consumer` on port 9090 (+ DNS)
3. Blocks everything else in both directions

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
kubectl -n np-7 logs -f deploy/producer   # [->processor:8080] OK
kubectl -n np-7 logs -f deploy/intruder   # [->processor:8080] FAIL, [->consumer:9090] FAIL
kubectl -n np-7 logs -f deploy/processor  # [->consumer:9090] OK
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concept

One policy can control both Ingress and Egress simultaneously:
```yaml
policyTypes:
  - Ingress
  - Egress
ingress:
  - from: [...]
egress:
  - to: [...]
```
Both sections must be present — if you omit `ingress` with `policyTypes: [Ingress, Egress]`, all ingress is denied.
