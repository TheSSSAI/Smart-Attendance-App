# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Architecture Style

Serverless, Multi-Tenant, Event-Driven

## 1.3 Technology Stack

- Firebase/GCP
- Flutter
- Firestore
- Cloud Functions
- TypeScript

## 1.4 Compliance Requirements

- GDPR
- Data Residency

## 1.5 Availability Target

99.9% (REQ-NFR-004)

# 2.0 Hosting Strategy

| Property | Value |
|----------|-------|
| Hosting Model | Cloud-Native |
| Cloud Provider | Google Cloud Platform (GCP) |
| Justification | The system is explicitly required to be exclusivel... |
| Multi Cloud Strategy | Not Applicable |
| On Premise Strategy | Not Applicable |

# 3.0 Environments

## 3.1 Development & Testing

### 3.1.1 Name

Development & Testing

### 3.1.2 Purpose

Local development, unit testing, and integration testing.

### 3.1.3 Hosting

Firebase Local Emulator Suite on developer machines, with a dedicated GCP Project for shared dev resources.

### 3.1.4 Justification

Required by REQ-DEP-001 for a dedicated development environment and REQ-NFR-006 to improve developer velocity and reduce costs.

### 3.1.5 Configuration

| Property | Value |
|----------|-------|
| Gcp Project | dedicated-dev-project-id |
| Database | Local Firestore Emulator |
| Compute | Local Cloud Functions Emulator |
| Ci Cd Trigger | On push to feature branches |

## 3.2.0 Staging / UAT

### 3.2.1 Name

Staging / UAT

### 3.2.2 Purpose

User Acceptance Testing, pre-production validation, and integration testing against live cloud services.

### 3.2.3 Hosting

Dedicated Firebase/GCP Project

### 3.2.4 Justification

Required by REQ-DEP-001 for a separate staging environment to ensure stability before production releases.

### 3.2.5 Configuration

| Property | Value |
|----------|-------|
| Gcp Project | dedicated-staging-project-id |
| Database | Cloud Firestore (Staging instance) |
| Compute | Cloud Functions (Staging instances) |
| Ci Cd Trigger | On merge to `staging` branch |

## 3.3.0 Production

### 3.3.1 Name

Production

### 3.3.2 Purpose

Live environment for all end-users.

### 3.3.3 Hosting

Dedicated Firebase/GCP Project

### 3.3.4 Justification

Required by REQ-DEP-001 for the live production environment, providing isolation from non-production workloads.

### 3.3.5 Configuration

| Property | Value |
|----------|-------|
| Gcp Project | dedicated-production-project-id |
| Database | Cloud Firestore (Production instance) |
| Compute | Cloud Functions (Production instances) |
| Ci Cd Trigger | On merge to `main` branch (with manual approval ga... |

# 4.0.0 Infrastructure Components

## 4.1.0 Serverless (FaaS)

### 4.1.1 Component Name

Application Compute

### 4.1.2 Service

Firebase Cloud Functions (v2)

### 4.1.3 Type

🔹 Serverless (FaaS)

### 4.1.4 Justification

Primary component for all server-side logic, integrations, and batch jobs as per REQ-ARC-001. Automatically scales and requires no server management.

### 4.1.5 Configuration

| Property | Value |
|----------|-------|
| Runtime | Node.js 18+ |
| Memory | Configured per-function (e.g., 256MB for simple tr... |
| Timeout | Configured per-function (e.g., 60s for HTTP, 540s ... |
| Scaling | Event-driven automatic scaling. Min/Max instances ... |
| Iam Role | Dedicated service account with least-privilege per... |

## 4.2.0 Managed NoSQL Database

### 4.2.1 Component Name

Primary Database

### 4.2.2 Service

Cloud Firestore

### 4.2.3 Type

🔹 Managed NoSQL Database

### 4.2.4 Justification

Core data store for all application data. Required for its serverless nature, real-time sync, offline capabilities, and security rules (REQ-ARC-001, REQ-DEP-002).

### 4.2.5 Configuration

| Property | Value |
|----------|-------|
| Mode | Native Mode |
| Location | Configured per tenant at registration to meet data... |
| Security | Access is controlled via Firestore Security Rules,... |

## 4.3.0 Managed Identity Service (IDaaS)

### 4.3.1 Component Name

User Authentication

### 4.3.2 Service

Firebase Authentication

### 4.3.3 Type

🔹 Managed Identity Service (IDaaS)

### 4.3.4 Justification

Handles all user identity, login, and session management, including multi-factor authentication and password policies as required (REQ-FUN-003, REQ-NFR-003).

### 4.3.5 Configuration

| Property | Value |
|----------|-------|
| Providers | Email/Password, Phone OTP enabled. |
| Security | Brute-force protection enabled (REQ-FUN-003). |
| Custom Claims | Used to store `tenantId` and `role` for RBAC enfor... |

## 4.4.0 Managed Web Hosting

### 4.4.1 Component Name

Web Application Hosting

### 4.4.2 Service

Firebase Hosting

### 4.4.3 Type

🔹 Managed Web Hosting

### 4.4.4 Justification

Serves the Flutter for Web admin dashboard, providing a global CDN, automated SSL, and simple deployment (REQ-TEC-001).

### 4.4.5 Configuration

#### 4.4.5.1 Deployment Source

CI/CD pipeline.

#### 4.4.5.2 Caching

CDN-enabled by default.

## 4.5.0.0 Managed Secrets Store

### 4.5.1.0 Component Name

Secrets Management

### 4.5.2.0 Service

Google Secret Manager

### 4.5.3.0 Type

🔹 Managed Secrets Store

### 4.5.4.0 Justification

Required for securely storing all third-party API keys and credentials, which are accessed at runtime by Cloud Functions (REQ-NFR-003).

### 4.5.5.0 Configuration

#### 4.5.5.1 Access Control

Managed via GCP IAM roles granted to Cloud Function service accounts.

## 4.6.0.0 Managed Cron Service

### 4.6.1.0 Component Name

Scheduled Tasks

### 4.6.2.0 Service

Google Cloud Scheduler

### 4.6.3.0 Type

🔹 Managed Cron Service

### 4.6.4.0 Justification

Triggers all time-based background jobs, such as auto-checkout (REQ-FUN-005), data export (REQ-FUN-012), and approval escalation (REQ-FUN-008).

### 4.6.5.0 Configuration

#### 4.6.5.1 Target

Pub/Sub topic that triggers a Cloud Function.

#### 4.6.5.2 Schedule

Defined per-job (e.g., daily, weekly).

## 4.7.0.0 Object Storage

### 4.7.1.0 Component Name

Database Backups

### 4.7.2.0 Service

Google Cloud Storage

### 4.7.3.0 Type

🔹 Object Storage

### 4.7.4.0 Justification

Required for storing daily automated backups of the Firestore database for disaster recovery (REQ-NFR-002).

### 4.7.5.0 Configuration

| Property | Value |
|----------|-------|
| Storage Class | Standard or Nearline. |
| Location | A separate region from the primary database for DR... |
| Lifecycle Policy | Configured to delete old backups after a defined r... |

## 4.8.0.0 CI/CD & IaC Tooling

### 4.8.1.0 Component Name

Deployment Automation

### 4.8.2.0 Service

GitHub Actions & Firebase CLI

### 4.8.3.0 Type

🔹 CI/CD & IaC Tooling

### 4.8.4.0 Justification

Manages the automated testing and deployment of all backend resources (functions, rules, indexes) and the client application, adhering to IaC best practices (REQ-NFR-006, REQ-TEC-001).

### 4.8.5.0 Configuration

#### 4.8.5.1 Workflow Files

Stored in the source code repository (`.github/workflows`).

#### 4.8.5.2 Iac Files

`firebase.json`, `firestore.rules`, `firestore.indexes.json`.

# 5.0.0.0 Region And Availability

## 5.1.0.0 Primary Region Strategy

Tenant-Selectable at Onboarding

## 5.2.0.0 Region Options

A curated list of supported GCP regions (e.g., `us-central1`, `europe-west1`).

## 5.3.0.0 High Availability

Achieved by deploying all services within a single high-availability GCP region. GCP services are zonally redundant by default.

## 5.4.0.0 Disaster Recovery

| Property | Value |
|----------|-------|
| Strategy | Restore from Backup |
| Rpo | 24 hours (via daily backups) |
| Rto | 4 hours (target time to restore service) |
| Backup Location | A different GCP region than the primary data store... |
| Justification | Meets the explicit RPO/RTO defined in REQ-NFR-002. |

# 6.0.0.0 Networking And Security

| Property | Value |
|----------|-------|
| Vpc Strategy | Not Applicable. The serverless model does not requ... |
| Network Security | All traffic between the client and Firebase servic... |
| Data Isolation | Enforced at the application layer via Firestore Se... |
| Identity And Access | GCP IAM is used to control access for developers a... |

