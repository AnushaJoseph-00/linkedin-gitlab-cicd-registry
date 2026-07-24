# LinkedIn App — DevSecOps Pipeline | GitLab CI | Trivy | GitLab Container Registry

A DevSecOps CI/CD pipeline built on top of a MERN LinkedIn clone, demonstrating automated Docker builds, dependency validation, security vulnerability scanning, and container image delivery to GitLab Container Registry using GitLab CI/CD.

---

## Pipeline Overview

![Pipeline Success](images/pipeline-success.png)

---

## Tech Stack

| Category | Tool |
|----------|------|
| Application | React.js + Node.js (Express) |
| Database | MongoDB (local instance on port 27017) |
| Containerisation | Docker (Multi-stage build) |
| CI/CD | GitLab CI/CD |
| Security Scanning | Trivy |
| Image Registry | GitLab Container Registry |
| Cloud | GitLab SaaS |

---

## Pipeline Stages

### 1. Build
- Builds Docker image using `docker:latest` with Docker-in-Docker (DinD)
- Tags image with `$CI_PIPELINE_IID` for traceability

![Build Stage](images/build-success.png)

### 2. Test
- Runs `npm install` on both `frontend/` and `backend/`
- Validates all Node.js dependencies are installable
- Caches `node_modules` to speed up future runs
- Fails pipeline if any dependency is broken

![Test Stage](images/npm-test-success.png)

### 3. Security Scan
- Rebuilds Docker image in isolated scan environment
- Installs and runs **Trivy** vulnerability scanner
- Scans for **HIGH** and **CRITICAL** vulnerabilities
- Only flags issues with a fix available
- Exports scan results as a **JSON artifact**

![Trivy Scan](images/trivy-scan-success.png)

### 4. Push
- Authenticates to GitLab Container Registry automatically via built-in CI variables
- Tags image with both `$CI_PIPELINE_IID` and `latest`
- Pushes both tags to registry
- Only runs on `main` branch

![Registry Push](images/registry-push.png)

### 5. Notify
- Runs only when any previous stage fails
- Prints failure notification with project name
- Can be extended to send Slack/email alerts

---

## GitLab Container Registry

![Container Registry](images/gitlab-registry.png)

---

## Trivy Security Scan Artifact

![Trivy Artifact](images/trivy-artifact.png)

---

## Project Structure

```
linkedin-project/
├── .gitlab-ci.yml
├── frontend/
├── backend/
├── Dockerfile
├── .gitignore
└── README.md
```

---

## Pipeline Variables

| Variable | Description |
|----------|-------------|
| `CI_REGISTRY` | GitLab Container Registry URL (auto-injected) |
| `CI_REGISTRY_USER` | Registry username (auto-injected) |
| `CI_REGISTRY_PASSWORD` | Registry token (auto-injected) |
| `CI_REGISTRY_IMAGE` | Full image path (auto-injected) |
| `CI_PIPELINE_IID` | Unique pipeline number for image tagging |

No manual secrets required : GitLab injects all registry credentials automatically!

---

## Key Decisions

- **Docker-in-Docker (DinD)** — enables Docker commands inside GitLab CI runner containers
- **npm validation before scan** — catches dependency issues before building final image
- **Trivy after build, before push** — ensures no vulnerable images reach the registry
- **GitLab Container Registry over AWS ECR** — zero credential setup, native GitLab integration
- **`only: main`** — only production-ready code on main branch reaches the registry
- **`when: on_failure`** — notify job only triggers when pipeline fails, not on success

---

## Comparison — GitHub Actions vs GitLab CI

| Feature | GitHub Actions | GitLab CI |
|---------|---------------|-----------|
| Config file | `.github/workflows/deploy.yml` | `.gitlab-ci.yml` |
| Pipeline trigger | `on: push` | automatic on push |
| Registry | AWS ECR | GitLab Container Registry |
| Secrets | GitHub Secrets | CI/CD Variables |
| Auth for registry | Manual AWS keys | Auto-injected |
| Security scanning | Trivy | Trivy |

---

## Future Improvement Suggestion

- Deploy to AWS ECS Fargate
- Add Slack notification on pipeline failure
- Add SAST scanning using GitLab native security

---

## Related Project

GitHub Actions version of this pipeline:
[linkedin-devsecops-githubactions-ecr](https://github.com/AnushaJoseph-00/linkedin-devsecops-githubactions-ecr)

---

## Credits

Original MERN LinkedIn clone by [Gustavo Noronha](https://github.com/gusttavonl/LinkedInMernClone)

CI/CD pipeline, Dockerfile, and GitLab CI configuration built by [AnushaJoseph-00](https://github.com/AnushaJoseph-00)
