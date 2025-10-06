# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Technology Stack

- Flutter
- Firebase (Firestore, Authentication, Cloud Functions)
- TypeScript
- Google Cloud's Operations Suite
- Google Maps API
- Google Sheets API
- SendGrid

## 1.3 Architecture Patterns

- Serverless
- Multi-Tenant
- Event-Driven
- Clean Architecture (Client)

## 1.4 Data Handling Needs

- GPS location data
- User personal data
- Multi-tenant data isolation
- Automated data export

## 1.5 Performance Expectations

Highly responsive user experience with low-latency (p95 < 500ms) server-side functions and fast mobile app start times (< 3s).

## 1.6 Regulatory Requirements

- GDPR

# 2.0 Environment Strategy

## 2.1 Environment Types

### 2.1.1 Development

#### 2.1.1.1 Type

🔹 Development

#### 2.1.1.2 Purpose

Used by developers for coding, unit testing, and local feature validation using the Firebase Local Emulator Suite.

#### 2.1.1.3 Usage Patterns

- Frequent deployments
- Individual developer sandboxes
- Low data volume

#### 2.1.1.4 Isolation Level

complete

#### 2.1.1.5 Data Policy

Synthetic or strictly anonymized data only. No production data allowed.

#### 2.1.1.6 Lifecycle Management

Can be torn down and reprovisioned on demand.

### 2.1.2.0 Staging

#### 2.1.2.1 Type

🔹 Staging

#### 2.1.2.2 Purpose

Pre-production environment for User Acceptance Testing (UAT), integration testing, and performance validation. Mirrors production configuration.

#### 2.1.2.3 Usage Patterns

- Controlled deployments from main branch
- Used by QA and pilot users
- Near production-scale data

#### 2.1.2.4 Isolation Level

complete

#### 2.1.2.5 Data Policy

Anonymized production data snapshot or high-quality synthetic data.

#### 2.1.2.6 Lifecycle Management

Persistent and long-running.

### 2.1.3.0 Production

#### 2.1.3.1 Type

🔹 Production

#### 2.1.3.2 Purpose

Live environment serving all end-users and customers. Subject to strict change control and monitoring.

#### 2.1.3.3 Usage Patterns

- Infrequent, planned deployments
- High availability and performance required
- Real user data

#### 2.1.3.4 Isolation Level

complete

#### 2.1.3.5 Data Policy

Live customer data, subject to all GDPR and privacy policy constraints.

#### 2.1.3.6 Lifecycle Management

Persistent and continuously monitored.

### 2.1.4.0 DR

#### 2.1.4.1 Type

🔹 DR

#### 2.1.4.2 Purpose

Disaster Recovery environment, primarily consisting of data backups and IaC templates for rapid reprovisioning.

#### 2.1.4.3 Usage Patterns

- Cold/standby
- Activated only in a declared disaster scenario

#### 2.1.4.4 Isolation Level

complete

#### 2.1.4.5 Data Policy

Encrypted production backups stored in a geographically separate region.

#### 2.1.4.6 Lifecycle Management

Provisioned on-demand during a DR event.

## 2.2.0.0 Promotion Strategy

### 2.2.1.0 Workflow

Development -> Staging -> Production. Code is promoted via pull requests from feature branches to 'main' (for Staging) and then tagged releases from 'main' (for Production).

### 2.2.2.0 Approval Gates

- Code review and successful automated tests before merging to main.
- Successful UAT sign-off in Staging before deploying to Production.

### 2.2.3.0 Automation Level

automated

### 2.2.4.0 Rollback Procedure

Redeploy the previous stable version/tag using the automated CI/CD pipeline.

## 2.3.0.0 Isolation Strategies

- {'environment': 'All', 'isolationType': 'complete', 'implementation': 'Each environment (Dev, Staging, Production) shall be a completely separate and dedicated Firebase/GCP Project, as specified in REQ-DEP-001. This provides total isolation of data, authentication, compute, and configuration.', 'justification': 'Prevents any possibility of cross-environment contamination, ensuring maximum security and stability for the production environment.'}

## 2.4.0.0 Scaling Approaches

### 2.4.1.0 Environment

#### 2.4.1.1 Environment

Production

#### 2.4.1.2 Scaling Type

auto

#### 2.4.1.3 Triggers

- Request volume
- Concurrent connections

#### 2.4.1.4 Limits

Managed by the serverless Firebase/GCP platform. Cost limits and alerts will be in place.

### 2.4.2.0 Environment

#### 2.4.2.1 Environment

Staging

#### 2.4.2.2 Scaling Type

auto

#### 2.4.2.3 Triggers

- Request volume

#### 2.4.2.4 Limits

Leverages serverless auto-scaling but expected load is lower. Cost controls are stricter.

### 2.4.3.0 Environment

#### 2.4.3.1 Environment

Development

#### 2.4.3.2 Scaling Type

auto

#### 2.4.3.3 Triggers

- N/A (Primarily uses local emulator)

#### 2.4.3.4 Limits

Usage is expected to stay within the free tier of Firebase/GCP.

## 2.5.0.0 Provisioning Automation

| Property | Value |
|----------|-------|
| Tool | Firebase CLI |
| Templating | Configuration files for Firestore rules (`firestor... |
| State Management | State is managed by the Firebase project itself. I... |
| Cicd Integration | ✅ |

# 3.0.0.0 Resource Requirements Analysis

## 3.1.0.0 Workload Analysis

### 3.1.1.0 Workload Type

#### 3.1.1.1 Workload Type

Transactional API

#### 3.1.1.2 Expected Load

High volume of small read/write operations (attendance check-ins).

#### 3.1.1.3 Peak Capacity

Thousands of concurrent users during peak business hours.

#### 3.1.1.4 Resource Profile

io-intensive

### 3.1.2.0 Workload Type

#### 3.1.2.1 Workload Type

Batch Processing

#### 3.1.2.2 Expected Load

Scheduled daily/weekly jobs for reporting, data export, and maintenance.

#### 3.1.2.3 Peak Capacity

Processing up to tens of thousands of records per job.

#### 3.1.2.4 Resource Profile

cpu-intensive

## 3.2.0.0 Compute Requirements

### 3.2.1.0 Environment

#### 3.2.1.1 Environment

Production

#### 3.2.1.2 Instance Type

Firebase Cloud Function

#### 3.2.1.3 Cpu Cores

0

#### 3.2.1.4 Memory Gb

0

#### 3.2.1.5 Instance Count

0

#### 3.2.1.6 Auto Scaling

##### 3.2.1.6.1 Enabled

✅ Yes

##### 3.2.1.6.2 Min Instances

0

##### 3.2.1.6.3 Max Instances

1,000

##### 3.2.1.6.4 Scaling Triggers

- HTTP Requests
- Event Triggers (Firestore, Auth)

#### 3.2.1.7.0 Justification

Serverless functions scale automatically. Memory will be allocated based on function needs (e.g., 256MB for simple triggers, 1GB for data processing). Min instances can be set to 1 for latency-sensitive functions if needed.

### 3.2.2.0.0 Environment

#### 3.2.2.1.0 Environment

Staging

#### 3.2.2.2.0 Instance Type

Firebase Cloud Function

#### 3.2.2.3.0 Cpu Cores

0

#### 3.2.2.4.0 Memory Gb

0

#### 3.2.2.5.0 Instance Count

0

#### 3.2.2.6.0 Auto Scaling

##### 3.2.2.6.1 Enabled

✅ Yes

##### 3.2.2.6.2 Min Instances

0

##### 3.2.2.6.3 Max Instances

50

##### 3.2.2.6.4 Scaling Triggers

- HTTP Requests
- Event Triggers

#### 3.2.2.7.0 Justification

Mirrors production but with lower maximum instance limits to control costs.

## 3.3.0.0.0 Storage Requirements

### 3.3.1.0.0 Environment

#### 3.3.1.1.0 Environment

Production

#### 3.3.1.2.0 Storage Type

object

#### 3.3.1.3.0 Capacity

Scales automatically

#### 3.3.1.4.0 Iops Requirements

Scales automatically

#### 3.3.1.5.0 Throughput Requirements

Scales automatically

#### 3.3.1.6.0 Redundancy

Multi-regional (Firestore default)

#### 3.3.1.7.0 Encryption

✅ Yes

### 3.3.2.0.0 Environment

#### 3.3.2.1.0 Environment

DR

#### 3.3.2.2.0 Storage Type

object

#### 3.3.2.3.0 Capacity

Dependent on production data size

#### 3.3.2.4.0 Iops Requirements

N/A (archive)

#### 3.3.2.5.0 Throughput Requirements

Low

#### 3.3.2.6.0 Redundancy

Cross-regional

#### 3.3.2.7.0 Encryption

✅ Yes

## 3.4.0.0.0 Special Hardware Requirements

*No items available*

## 3.5.0.0.0 Scaling Strategies

- {'environment': 'Production', 'strategy': 'reactive', 'implementation': 'Native auto-scaling of Firebase services (Firestore, Cloud Functions) based on real-time demand.', 'costOptimization': 'Leverage free tiers, write efficient Firestore queries and indexes, and use GCP Budget Alerts as per REQ-1-076.'}

# 4.0.0.0.0 Security Architecture

## 4.1.0.0.0 Authentication Controls

- {'method': 'mfa', 'scope': 'All users', 'implementation': 'Firebase Authentication with Email/Password and Phone OTP support.', 'environment': 'All'}

## 4.2.0.0.0 Authorization Controls

- {'model': 'rbac', 'implementation': 'JWT Custom Claims (`tenantId`, `role`) issued by Firebase Auth and enforced by declarative Firestore Security Rules.', 'granularity': 'fine-grained', 'environment': 'All'}

## 4.3.0.0.0 Certificate Management

| Property | Value |
|----------|-------|
| Authority | external |
| Rotation Policy | Managed automatically by Google Cloud for all Fire... |
| Automation | ✅ |
| Monitoring | ✅ |

## 4.4.0.0.0 Encryption Standards

### 4.4.1.0.0 Scope

#### 4.4.1.1.0 Scope

data-in-transit

#### 4.4.1.2.0 Algorithm

TLS 1.2+

#### 4.4.1.3.0 Key Management

Managed by Google

#### 4.4.1.4.0 Compliance

- GDPR

### 4.4.2.0.0 Scope

#### 4.4.2.1.0 Scope

data-at-rest

#### 4.4.2.2.0 Algorithm

AES-256

#### 4.4.2.3.0 Key Management

Managed by Google

#### 4.4.2.4.0 Compliance

- GDPR

## 4.5.0.0.0 Access Control Mechanisms

### 4.5.1.0.0 iam

#### 4.5.1.1.0 Type

🔹 iam

#### 4.5.1.2.0 Configuration

Principle of Least Privilege. Specific roles for developers (e.g., Firebase Developer) and CI/CD service accounts.

#### 4.5.1.3.0 Environment

All

#### 4.5.1.4.0 Rules

*No items available*

### 4.5.2.0.0 Firestore Security Rules

#### 4.5.2.1.0 Type

🔹 Firestore Security Rules

#### 4.5.2.2.0 Configuration

Primary mechanism for data access control, enforcing multi-tenancy and RBAC.

#### 4.5.2.3.0 Environment

All

#### 4.5.2.4.0 Rules

- Allow read/write only if request.auth.token.tenantId matches resource.data.tenantId.

## 4.6.0.0.0 Data Protection Measures

### 4.6.1.0.0 Data Type

#### 4.6.1.1.0 Data Type

pii

#### 4.6.1.2.0 Protection Method

anonymization

#### 4.6.1.3.0 Implementation

Scheduled Cloud Function to anonymize user data after 90 days of deactivation as per REQ-1-074.

#### 4.6.1.4.0 Compliance

- GDPR

### 4.6.2.0.0 Data Type

#### 4.6.2.1.0 Data Type

api-keys

#### 4.6.2.2.0 Protection Method

encryption

#### 4.6.2.3.0 Implementation

All third-party API keys stored in Google Secret Manager as per REQ-1-065.

#### 4.6.2.4.0 Compliance

*No items available*

## 4.7.0.0.0 Network Security

- {'control': 'Serverless VPC Access', 'implementation': 'Not required for the initial design as all services are on the public GCP network. Can be implemented later if direct private access to other GCP services is needed.', 'rules': [], 'monitoring': False}

## 4.8.0.0.0 Security Monitoring

- {'type': 'siem', 'implementation': 'Google Cloud Audit Logs for tracking access and changes to GCP resources. Application-level audit log in Firestore for critical business actions.', 'frequency': 'real-time', 'alerting': True}

## 4.9.0.0.0 Backup Security

| Property | Value |
|----------|-------|
| Encryption | ✅ |
| Access Control | Strict IAM policies on the GCS backup bucket, allo... |
| Offline Storage | ❌ |
| Testing Frequency | semi-annually |

## 4.10.0.0.0 Compliance Frameworks

- {'framework': 'gdpr', 'applicableEnvironments': ['Production', 'Staging'], 'controls': ['Data Processing Addendum (DPA) provided to customers.', 'User consent flows.', 'Configurable data residency.', 'Anonymization for right to be forgotten.'], 'auditFrequency': 'annually'}

# 5.0.0.0.0 Network Design

## 5.1.0.0.0 Network Segmentation

- {'environment': 'All', 'segmentType': 'public', 'purpose': "All Firebase services operate on Google's public network, secured by IAM and service-specific controls (e.g., Firestore Rules) rather than traditional network perimeters.", 'isolation': 'virtual'}

## 5.2.0.0.0 Subnet Strategy

*No items available*

## 5.3.0.0.0 Security Group Rules

*No items available*

## 5.4.0.0.0 Connectivity Requirements

### 5.4.1.0.0 Source

#### 5.4.1.1.0 Source

Flutter Client

#### 5.4.1.2.0 Destination

Firebase Services

#### 5.4.1.3.0 Protocol

HTTPS/gRPC

#### 5.4.1.4.0 Bandwidth

Standard Internet

#### 5.4.1.5.0 Latency

< 200ms

### 5.4.2.0.0 Source

#### 5.4.2.1.0 Source

Cloud Functions

#### 5.4.2.2.0 Destination

Google APIs / SendGrid

#### 5.4.2.3.0 Protocol

HTTPS

#### 5.4.2.4.0 Bandwidth

High

#### 5.4.2.5.0 Latency

< 500ms

## 5.5.0.0.0 Network Monitoring

- {'type': 'performance-monitoring', 'implementation': 'Firebase Performance Monitoring for client-side network call analysis.', 'alerting': False, 'retention': '90 days'}

## 5.6.0.0.0 Bandwidth Controls

*No items available*

## 5.7.0.0.0 Service Discovery

| Property | Value |
|----------|-------|
| Method | dns |
| Implementation | Managed by Google Cloud. Clients connect to global... |
| Health Checks | ✅ |

## 5.8.0.0.0 Environment Communication

*No items available*

# 6.0.0.0.0 Data Management Strategy

## 6.1.0.0.0 Data Isolation

- {'environment': 'All', 'isolationLevel': 'complete', 'method': 'separate-instances', 'justification': 'Using separate Firebase Projects for Dev, Staging, and Production provides the strongest possible data isolation.'}

## 6.2.0.0.0 Backup And Recovery

### 6.2.1.0.0 Environment

#### 6.2.1.1.0 Environment

Production

#### 6.2.1.2.0 Backup Frequency

daily

#### 6.2.1.3.0 Retention Period

30 days

#### 6.2.1.4.0 Recovery Time Objective

4 hours

#### 6.2.1.5.0 Recovery Point Objective

24 hours

#### 6.2.1.6.0 Testing Schedule

semi-annually

### 6.2.2.0.0 Environment

#### 6.2.2.1.0 Environment

Staging

#### 6.2.2.2.0 Backup Frequency

weekly

#### 6.2.2.3.0 Retention Period

14 days

#### 6.2.2.4.0 Recovery Time Objective

24 hours

#### 6.2.2.5.0 Recovery Point Objective

7 days

#### 6.2.2.6.0 Testing Schedule

annually

## 6.3.0.0.0 Data Masking Anonymization

### 6.3.1.0.0 Environment

#### 6.3.1.1.0 Environment

Staging

#### 6.3.1.2.0 Data Type

pii

#### 6.3.1.3.0 Masking Method

anonymization

#### 6.3.1.4.0 Coverage

complete

#### 6.3.1.5.0 Compliance

- GDPR

### 6.3.2.0.0 Environment

#### 6.3.2.1.0 Environment

Development

#### 6.3.2.2.0 Data Type

All

#### 6.3.2.3.0 Masking Method

static

#### 6.3.2.4.0 Coverage

complete

#### 6.3.2.5.0 Compliance

- GDPR

## 6.4.0.0.0 Migration Processes

- {'sourceEnvironment': 'Staging', 'targetEnvironment': 'Production', 'migrationMethod': 'etl', 'validation': 'Schema changes are migrated via IaC (Firebase CLI). Data is not migrated between environments.', 'rollbackPlan': 'Revert IaC code in Git and redeploy the previous version.'}

## 6.5.0.0.0 Retention Policies

### 6.5.1.0.0 Environment

#### 6.5.1.1.0 Environment

Production

#### 6.5.1.2.0 Data Type

Attendance Records

#### 6.5.1.3.0 Retention Period

2 years (default)

#### 6.5.1.4.0 Archival Method

Automated deletion via scheduled Cloud Function.

#### 6.5.1.5.0 Compliance Requirement

REQ-1-074

### 6.5.2.0.0 Environment

#### 6.5.2.1.0 Environment

Production

#### 6.5.2.2.0 Data Type

Audit Logs

#### 6.5.2.3.0 Retention Period

7 years (default)

#### 6.5.2.4.0 Archival Method

Automated archival/deletion via scheduled Cloud Function.

#### 6.5.2.5.0 Compliance Requirement

REQ-1-074

## 6.6.0.0.0 Data Classification

- {'classification': 'restricted', 'handlingRequirements': ['Encryption at rest and in transit', 'Strict access control via Firestore Rules'], 'accessControls': ['RBAC'], 'environments': ['Production']}

## 6.7.0.0.0 Disaster Recovery

- {'environment': 'Production', 'drSite': 'A different GCP region from the primary.', 'replicationMethod': 'snapshot', 'failoverTime': '< 4 hours (RTO)', 'testingFrequency': 'semi-annually'}

# 7.0.0.0.0 Monitoring And Observability

## 7.1.0.0.0 Monitoring Components

### 7.1.1.0.0 Component

#### 7.1.1.1.0 Component

apm

#### 7.1.1.2.0 Tool

Firebase Performance Monitoring, Firebase Crashlytics

#### 7.1.1.3.0 Implementation

Integrated via Firebase SDK in the Flutter client.

#### 7.1.1.4.0 Environments

- Staging
- Production

### 7.1.2.0.0 Component

#### 7.1.2.1.0 Component

infrastructure

#### 7.1.2.2.0 Tool

Google Cloud Monitoring

#### 7.1.2.3.0 Implementation

Native integration for Firebase/GCP services.

#### 7.1.2.4.0 Environments

- Staging
- Production

### 7.1.3.0.0 Component

#### 7.1.3.1.0 Component

logs

#### 7.1.3.2.0 Tool

Google Cloud Logging

#### 7.1.3.3.0 Implementation

Native integration.

#### 7.1.3.4.0 Environments

- Development
- Staging
- Production

### 7.1.4.0.0 Component

#### 7.1.4.1.0 Component

alerting

#### 7.1.4.2.0 Tool

Google Cloud Monitoring, GCP Billing

#### 7.1.4.3.0 Implementation

Configuration of alert policies and budget alerts.

#### 7.1.4.4.0 Environments

- Production

## 7.2.0.0.0 Environment Specific Thresholds

### 7.2.1.0.0 Environment

#### 7.2.1.1.0 Environment

Production

#### 7.2.1.2.0 Metric

Cloud Function Error Rate

#### 7.2.1.3.0 Warning Threshold

0.5%

#### 7.2.1.4.0 Critical Threshold

1%

#### 7.2.1.5.0 Justification

REQ-1-076

### 7.2.2.0.0 Environment

#### 7.2.2.1.0 Environment

Production

#### 7.2.2.2.0 Metric

Callable Function p95 Latency

#### 7.2.2.3.0 Warning Threshold

400ms

#### 7.2.2.4.0 Critical Threshold

500ms

#### 7.2.2.5.0 Justification

REQ-NFR-001

### 7.2.3.0.0 Environment

#### 7.2.3.1.0 Environment

Staging

#### 7.2.3.2.0 Metric

Cloud Function Error Rate

#### 7.2.3.3.0 Warning Threshold

2%

#### 7.2.3.4.0 Critical Threshold

5%

#### 7.2.3.5.0 Justification

More tolerant of errors during testing phases.

## 7.3.0.0.0 Metrics Collection

### 7.3.1.0.0 Category

#### 7.3.1.1.0 Category

🔹 application

#### 7.3.1.2.0 Metrics

- Client crash rates
- App start time
- API request latency

#### 7.3.1.3.0 Collection Interval

real-time

#### 7.3.1.4.0 Retention

90 days

### 7.3.2.0.0 Category

#### 7.3.2.1.0 Category

🔹 infrastructure

#### 7.3.2.2.0 Metrics

- Cloud Function invocation count
- Cloud Function execution time
- Firestore read/write operations

#### 7.3.2.3.0 Collection Interval

1 minute

#### 7.3.2.4.0 Retention

30 days

## 7.4.0.0.0 Health Check Endpoints

- {'component': 'Backend API', 'endpoint': 'A designated lightweight HTTPS Callable Function.', 'checkType': 'liveness', 'timeout': '2s', 'frequency': '1 minute'}

## 7.5.0.0.0 Logging Configuration

### 7.5.1.0.0 Environment

#### 7.5.1.1.0 Environment

Production

#### 7.5.1.2.0 Log Level

info

#### 7.5.1.3.0 Destinations

- Google Cloud Logging

#### 7.5.1.4.0 Retention

90 days

#### 7.5.1.5.0 Sampling

100%

### 7.5.2.0.0 Environment

#### 7.5.2.1.0 Environment

Staging

#### 7.5.2.2.0 Log Level

debug

#### 7.5.2.3.0 Destinations

- Google Cloud Logging

#### 7.5.2.4.0 Retention

30 days

#### 7.5.2.5.0 Sampling

100%

## 7.6.0.0.0 Escalation Policies

### 7.6.1.0.0 Environment

#### 7.6.1.1.0 Environment

Production

#### 7.6.1.2.0 Severity

critical

#### 7.6.1.3.0 Escalation Path

- Primary On-Call Engineer
- Secondary On-Call Engineer
- Engineering Lead

#### 7.6.1.4.0 Timeouts

- 5 minutes
- 15 minutes

#### 7.6.1.5.0 Channels

- PagerDuty
- Email

### 7.6.2.0.0 Environment

#### 7.6.2.1.0 Environment

Staging

#### 7.6.2.2.0 Severity

critical

#### 7.6.2.3.0 Escalation Path

- Development Team Channel

#### 7.6.2.4.0 Timeouts

*No items available*

#### 7.6.2.5.0 Channels

- Slack

## 7.7.0.0.0 Dashboard Configurations

- {'dashboardType': 'operational', 'audience': 'Engineering Team', 'refreshInterval': '1 minute', 'metrics': ['System Availability (Uptime)', 'Overall p95 API Latency', 'Overall Function Error Rate', 'Top 5 Slowest Functions', 'Top 5 Erroring Functions']}

# 8.0.0.0.0 Project Specific Environments

## 8.1.0.0.0 Environments

### 8.1.1.0.0 Development Project

#### 8.1.1.1.0 Id

attendance-app-dev

#### 8.1.1.2.0 Name

Development Project

#### 8.1.1.3.0 Type

🔹 Development

#### 8.1.1.4.0 Provider

gcp

#### 8.1.1.5.0 Region

us-central1

#### 8.1.1.6.0 Configuration

| Property | Value |
|----------|-------|
| Instance Type | N/A (Serverless) |
| Auto Scaling | enabled |
| Backup Enabled | ❌ |
| Monitoring Level | basic |

#### 8.1.1.7.0 Security Groups

*No items available*

#### 8.1.1.8.0 Network

##### 8.1.1.8.1 Vpc Id

N/A

##### 8.1.1.8.2 Subnets

*No items available*

##### 8.1.1.8.3 Security Groups

*No items available*

##### 8.1.1.8.4 Internet Gateway

N/A

##### 8.1.1.8.5 Nat Gateway

N/A

#### 8.1.1.9.0 Monitoring

##### 8.1.1.9.1 Enabled

✅ Yes

##### 8.1.1.9.2 Metrics

- Basic function metrics

##### 8.1.1.9.3 Alerts

*No data available*

##### 8.1.1.9.4 Dashboards

*No items available*

#### 8.1.1.10.0 Compliance

##### 8.1.1.10.1 Frameworks

*No items available*

##### 8.1.1.10.2 Controls

*No items available*

##### 8.1.1.10.3 Audit Schedule

N/A

#### 8.1.1.11.0 Data Management

| Property | Value |
|----------|-------|
| Backup Schedule | N/A |
| Retention Policy | 30 days |
| Encryption Enabled | ✅ |
| Data Masking | ✅ |

### 8.1.2.0.0 Staging Project

#### 8.1.2.1.0 Id

attendance-app-staging

#### 8.1.2.2.0 Name

Staging Project

#### 8.1.2.3.0 Type

🔹 Staging

#### 8.1.2.4.0 Provider

gcp

#### 8.1.2.5.0 Region

us-central1

#### 8.1.2.6.0 Configuration

| Property | Value |
|----------|-------|
| Instance Type | N/A (Serverless) |
| Auto Scaling | enabled |
| Backup Enabled | ✅ |
| Monitoring Level | enhanced |

#### 8.1.2.7.0 Security Groups

*No items available*

#### 8.1.2.8.0 Network

##### 8.1.2.8.1 Vpc Id

N/A

##### 8.1.2.8.2 Subnets

*No items available*

##### 8.1.2.8.3 Security Groups

*No items available*

##### 8.1.2.8.4 Internet Gateway

N/A

##### 8.1.2.8.5 Nat Gateway

N/A

#### 8.1.2.9.0 Monitoring

##### 8.1.2.9.1 Enabled

✅ Yes

##### 8.1.2.9.2 Metrics

- All production metrics

##### 8.1.2.9.3 Alerts

###### 8.1.2.9.3.1 Error Rate

Enabled with higher thresholds

##### 8.1.2.9.4.0 Dashboards

- Operational Dashboard Clone

#### 8.1.2.10.0.0 Compliance

##### 8.1.2.10.1.0 Frameworks

- GDPR

##### 8.1.2.10.2.0 Controls

- Data anonymization

##### 8.1.2.10.3.0 Audit Schedule

N/A

#### 8.1.2.11.0.0 Data Management

| Property | Value |
|----------|-------|
| Backup Schedule | weekly |
| Retention Policy | 90 days |
| Encryption Enabled | ✅ |
| Data Masking | ✅ |

### 8.1.3.0.0.0 Production Project

#### 8.1.3.1.0.0 Id

attendance-app-prod

#### 8.1.3.2.0.0 Name

Production Project

#### 8.1.3.3.0.0 Type

🔹 Production

#### 8.1.3.4.0.0 Provider

gcp

#### 8.1.3.5.0.0 Region

Configurable per tenant

#### 8.1.3.6.0.0 Configuration

| Property | Value |
|----------|-------|
| Instance Type | N/A (Serverless) |
| Auto Scaling | enabled |
| Backup Enabled | ✅ |
| Monitoring Level | enhanced |

#### 8.1.3.7.0.0 Security Groups

*No items available*

#### 8.1.3.8.0.0 Network

##### 8.1.3.8.1.0 Vpc Id

N/A

##### 8.1.3.8.2.0 Subnets

*No items available*

##### 8.1.3.8.3.0 Security Groups

*No items available*

##### 8.1.3.8.4.0 Internet Gateway

N/A

##### 8.1.3.8.5.0 Nat Gateway

N/A

#### 8.1.3.9.0.0 Monitoring

##### 8.1.3.9.1.0 Enabled

✅ Yes

##### 8.1.3.9.2.0 Metrics

- All defined metrics

##### 8.1.3.9.3.0 Alerts

*No data available*

##### 8.1.3.9.4.0 Dashboards

- Operational Dashboard
- Business KPI Dashboard

#### 8.1.3.10.0.0 Compliance

##### 8.1.3.10.1.0 Frameworks

- GDPR

##### 8.1.3.10.2.0 Controls

- All required controls

##### 8.1.3.10.3.0 Audit Schedule

annually

#### 8.1.3.11.0.0 Data Management

| Property | Value |
|----------|-------|
| Backup Schedule | daily |
| Retention Policy | Configurable per tenant |
| Encryption Enabled | ✅ |
| Data Masking | ❌ |

## 8.2.0.0.0.0 Configuration

| Property | Value |
|----------|-------|
| Global Timeout | 60s (for Cloud Functions) |
| Max Instances | 1000 |
| Backup Schedule | daily |
| Deployment Strategy | rolling |
| Rollback Strategy | redeploy-previous-tag |
| Maintenance Window | Announced as needed, low-traffic hours |

## 8.3.0.0.0.0 Cross Environment Policies

- {'policy': 'data-flow', 'implementation': 'No direct data flow is permitted between environments. Staging data is populated from a sanitized production backup.', 'enforcement': 'automated'}

# 9.0.0.0.0.0 Implementation Priority

## 9.1.0.0.0.0 Component

### 9.1.1.0.0.0 Component

Production Environment Provisioning (IaC)

### 9.1.2.0.0.0 Priority

🔴 high

### 9.1.3.0.0.0 Dependencies

*No items available*

### 9.1.4.0.0.0 Estimated Effort

Medium

### 9.1.5.0.0.0 Risk Level

high

## 9.2.0.0.0.0 Component

### 9.2.1.0.0.0 Component

CI/CD Pipeline for Automated Deployments

### 9.2.2.0.0.0 Priority

🔴 high

### 9.2.3.0.0.0 Dependencies

- Production Environment Provisioning (IaC)

### 9.2.4.0.0.0 Estimated Effort

High

### 9.2.5.0.0.0 Risk Level

medium

## 9.3.0.0.0.0 Component

### 9.3.1.0.0.0 Component

Security & Monitoring Configuration (Alerts, Rules)

### 9.3.2.0.0.0 Priority

🔴 high

### 9.3.3.0.0.0 Dependencies

- Production Environment Provisioning (IaC)

### 9.3.4.0.0.0 Estimated Effort

Medium

### 9.3.5.0.0.0 Risk Level

high

## 9.4.0.0.0.0 Component

### 9.4.1.0.0.0 Component

Backup and Disaster Recovery Strategy

### 9.4.2.0.0.0 Priority

🟡 medium

### 9.4.3.0.0.0 Dependencies

- Production Environment Provisioning (IaC)

### 9.4.4.0.0.0 Estimated Effort

Medium

### 9.4.5.0.0.0 Risk Level

medium

# 10.0.0.0.0.0 Risk Assessment

## 10.1.0.0.0.0 Risk

### 10.1.1.0.0.0 Risk

Uncontrolled cloud costs due to a bug in a Cloud Function causing recursive invocations.

### 10.1.2.0.0.0 Impact

high

### 10.1.3.0.0.0 Probability

medium

### 10.1.4.0.0.0 Mitigation

Implement GCP Budget Alerts as per REQ-1-076. Enforce strict code reviews for all functions with triggers.

### 10.1.5.0.0.0 Contingency Plan

Disable the faulty function immediately upon alert. Analyze logs to find the root cause.

## 10.2.0.0.0.0 Risk

### 10.2.1.0.0.0 Risk

Data leakage between tenants due to misconfigured Firestore Security Rules.

### 10.2.2.0.0.0 Impact

high

### 10.2.3.0.0.0 Probability

low

### 10.2.4.0.0.0 Mitigation

All security rule changes must be peer-reviewed and deployed via the automated IaC pipeline. Utilize the Firestore emulator for extensive testing of rules.

### 10.2.5.0.0.0 Contingency Plan

Deploy a restrictive 'deny all' rule set immediately to halt access. Identify and fix the faulty rule.

## 10.3.0.0.0.0 Risk

### 10.3.1.0.0.0 Risk

GDPR non-compliance due to PII in non-production environments.

### 10.3.2.0.0.0 Impact

high

### 10.3.3.0.0.0 Probability

medium

### 10.3.4.0.0.0 Mitigation

Implement a strict data policy enforced by automated scripts for anonymizing production data before restoring it to Staging.

### 10.3.5.0.0.0 Contingency Plan

Purge the non-compliant data from the environment. Conduct a root cause analysis of the policy failure.

# 11.0.0.0.0.0 Recommendations

## 11.1.0.0.0.0 Category

### 11.1.1.0.0.0 Category

🔹 Security

### 11.1.2.0.0.0 Recommendation

Enforce a strict policy that all Firebase resource configurations (Security Rules, Indexes, Function deployments) are managed exclusively through an Infrastructure as Code (IaC) approach using the Firebase CLI and a CI/CD pipeline.

### 11.1.3.0.0.0 Justification

This prevents manual, untracked, and potentially erroneous changes in the production environment, providing an auditable and repeatable deployment process, which is critical for security and stability.

### 11.1.4.0.0.0 Priority

🔴 high

### 11.1.5.0.0.0 Implementation Notes

The CI/CD service account should have deployment permissions, while individual developer IAM roles should be read-only for the production project.

## 11.2.0.0.0.0 Category

### 11.2.1.0.0.0 Category

🔹 Compliance

### 11.2.2.0.0.0 Recommendation

Develop and automate a data sanitization pipeline for restoring production backups into the Staging environment.

### 11.2.3.0.0.0 Justification

To comply with GDPR's principle of data minimization and reduce risk, it is crucial that no live PII exists in non-production environments. An automated pipeline ensures this process is reliable and repeatable.

### 11.2.4.0.0.0 Priority

🔴 high

### 11.2.5.0.0.0 Implementation Notes

This can be a series of Cloud Functions or a Dataflow job that is triggered after a backup is created, which anonymizes the data and places the sanitized version in a separate GCS bucket for Staging restores.

## 11.3.0.0.0.0 Category

### 11.3.1.0.0.0 Category

🔹 Cost Management

### 11.3.2.0.0.0 Recommendation

Proactively configure granular GCP Budget Alerts for each environment project, with notifications sent to different stakeholders (e.g., dev team for dev project, finance/ops for prod).

### 11.3.3.0.0.0 Justification

The serverless architecture's primary risk is cost overrun. As per REQ-1-076, this proactive monitoring is essential to catch bugs or unexpected usage patterns before they result in significant financial impact.

### 11.3.4.0.0.0 Priority

🔴 high

### 11.3.5.0.0.0 Implementation Notes

Set multiple alert thresholds (e.g., at 50%, 90%, and 100% of the forecasted budget) to provide early warnings.

