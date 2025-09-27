# DevSecOps Assessment - [Olumide Olowe]

## Overview
This repo contains design, docs and implementation for the Senior DevSecOps assessment.
It integrates the provided sample services as git submodules (in `sample-services/`).

## Quick links
- Crisis assessment (Part 1): `docs/crisis-assessment.pdf`
- Implementation guide: `docs/implementation-guide.md`
- Architecture diagrams: `docs/architecture-diagrams/`
- CI/CD pipelines: `implementation/ci-cd/pipelines/`
- Docker overlays: `implementation/docker/`
- Kubernetes manifests per env: `implementation/k8s/{dev,uat,prod,dr}/`
- Local run: `sample-services/docker-compose.yml`

## How pipelines work
- Branch model:
  - `feature/*` → auto-deploy to **dev**
  - `dev` branch → deploy to **dev**
  - `uat` branch → deploy to **uat**
  - `main` → deploy to **prod** and **dr**
- GitHub secrets required (list below).

## Required GitHub secrets
- `IMAGE_REPO` (e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com)
- `ARGOCD_URL` (ArgoCD API endpoint)
- `ARGOCD_TOKEN`
- `PROD_DB_HOST`, `PROD_DB_PORT`, `PROD_DB_NAME`, `PROD_DB_USER`, `PROD_DB_PASSWORD`
- `STAGING_DB_*` for UAT (if used)
- `COSIGN_KEY` and `COSIGN_PASSWORD` (optional)
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (if pipelines call AWS)

## How to test locally
1. Build and run services:
