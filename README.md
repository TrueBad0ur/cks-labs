# cks-labs

Practice materials for the Certified Kubernetes Security Specialist (CKS) exam.

## Structure

```
cks-labs/
├── real-cks/1/       # CKS practice set 1 — 17 questions with configs and test pods
├── real-cks/2/       # CKS practice set 2 — 17 questions (SBOM, Falco, Istio, CSR, upgrade...)
├── prepare/          # Task-based labs (Falco, ETCD, audit, RBAC, etc.)
├── auth/             # Kubernetes auth deep-dive (X.509 users, ServiceAccounts)
├── certificates/     # Certificate management labs
├── kodekloud/        # KodeKloud CKS exercises
└── tetragon/         # Tetragon runtime security
```

## real-cks/1

17 practical CKS questions covering:

| # | Topic |
|---|---|
| 1 | Contexts & certificate extraction |
| 2 | Image vulnerability scanning (trivy) |
| 3 | Apiserver security (NodePort → ClusterIP) |
| 4 | ServiceAccount token expiration & projected volumes |
| 5 | CIS Benchmark (kube-bench) |
| 6 | Immutable root filesystem |
| 7 | Pod Security Standards & Admission |
| 8 | Docker ICC |
| 9 | AppArmor profiles |
| 10 | gVisor RuntimeClass |
| 11 | Secret management (immutable, move, convert from ConfigMap) |
| 12 | ImagePolicyWebhook |
| 13 | CiliumNetworkPolicy (block metadata server) |
| 14 | ETCD encryption at rest |
| 15 | TLS on Ingress |
| 16 | Falco custom rules |
| 17 | Audit log policy |

Each question has its own directory (`q1/`–`q17/`) with:
- YAML manifests ready to apply
- Test pods to verify behavior
- `README.md` with step-by-step setup and verification

## real-cks/2

17 practical CKS questions covering:

| # | Topic |
|---|---|
| 1 | SBOM generation (bom, trivy, SPDX, CycloneDX) |
| 2 | Runtime security with Falco (custom rules, log format) |
| 3 | Manual static analysis (credential exposure in Dockerfiles/YAML) |
| 4 | Pod Security Standards (baseline enforcement) |
| 5 | NetworkPolicy (egress between namespaces) |
| 6 | Platform binary verification (sha512sum) |
| 7 | KubeletConfiguration via kubeadm (containerLogMaxSize/Files) |
| 8 | CiliumNetworkPolicy (L3/L4 deny, mutual authentication) |
| 9 | Certificate Signing Requests (approve, deny, create from .csr) |
| 10 | Istio sidecar injection |
| 11 | Secrets in ETCD (direct etcdctl read) |
| 12 | RBAC permission escape (restricted context, exec, SA tokens) |
| 13 | RBAC for operator (CSR approval permissions) |
| 14 | Syscall activity (kill syscall detection with strace) |
| 15 | Apiserver TLS min version (VersionTLS13) |
| 16 | Docker image attack surface (alpine, curl removal, non-root user) |
| 17 | Kubernetes cluster upgrade (kubeadm, apt, drain/uncordon) |

## Cluster

Labs are designed for a multi-node Kubernetes cluster (1 controlplane + workers).
Some configurations assume:
- Cilium as the CNI
- Falco deployed via Helm
- MetalLB + ingress-nginx for Ingress
