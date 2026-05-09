# Task 8 — Three-tier application (frontend → backend → db)

## Task

Three namespaces: `np-8-frontend`, `np-8-backend`, `np-8-db`.

Traffic rules:
- `frontend` → `backend` on port 8080: **allowed**
- `backend` → `db` on port 5432: **allowed**
- `frontend` → `db` on port 5432: **blocked** (no direct DB access)
- `db` → anything: **blocked** (db never initiates connections)

**Create NetworkPolicies to enforce all four rules above.**

Hint: you'll need policies in multiple namespaces. Think about which namespace each policy belongs to and whether it's ingress, egress, or both.

## Apply environment

```bash
kubectl apply -f configs/
```

## Check

```bash
kubectl -n np-8-frontend logs -f deploy/frontend  # backend OK, db FAIL
kubectl -n np-8-backend  logs -f deploy/backend   # db OK
```

## Automated check

```bash
bash configs/verify.sh
```

## Key concept

Multiple policies in different namespaces work together.  
Think about each pod's perspective:
- Who can send **to** this pod? (ingress policy on the receiver)
- Where can this pod send **to**? (egress policy on the sender)

You don't need to cover every case with a single policy — use multiple targeted policies.
