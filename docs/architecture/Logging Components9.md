# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Technology Stack

- Flutter
- Firebase (Cloud Functions, Firestore, Authentication)
- TypeScript
- Google Cloud's Operations Suite (Logging, Monitoring)
- Firebase Crashlytics

## 1.3 Monitoring Requirements

- REQ-1-076: Real-time client crash reporting (Crashlytics)
- REQ-1-076: Centralized server-side logging (Cloud Logging)
- REQ-1-076: Alerting on Cloud Function error rates > 1%
- REQ-1-076: GCP budget alerts for cost control
- REQ-1-067: p95 response time for Cloud Functions < 500ms
- REQ-1-060: Logging and alerting on external API integration errors (Google Sheets)

## 1.4 System Architecture

Serverless on Firebase/GCP, with a multi-tenant data model and a cross-platform Flutter client.

## 1.5 Environment

production

# 2.0 Log Level And Category Strategy

## 2.1 Default Log Level

INFO

## 2.2 Environment Specific Levels

### 2.2.1 Environment

#### 2.2.1.1 Environment

development

#### 2.2.1.2 Log Level

DEBUG

#### 2.2.1.3 Justification

Provides detailed information for troubleshooting and development without impacting production performance or cost.

### 2.2.2.0 Environment

#### 2.2.2.1 Environment

staging

#### 2.2.2.2 Log Level

DEBUG

#### 2.2.2.3 Justification

Allows for thorough pre-production validation and debugging of application behavior.

## 2.3.0.0 Component Categories

### 2.3.1.0 Component

#### 2.3.1.1 Component

callable-functions-api-002

#### 2.3.1.2 Category

🔹 API

#### 2.3.1.3 Log Level

INFO

#### 2.3.1.4 Verbose Logging

❌ No

#### 2.3.1.5 Justification

Logs request start/end, status, and duration for core API interactions. Errors are logged at ERROR level.

### 2.3.2.0 Component

#### 2.3.2.1 Component

event-triggered-functions-006

#### 2.3.2.2 Category

🔹 BusinessLogic

#### 2.3.2.3 Log Level

INFO

#### 2.3.2.4 Verbose Logging

❌ No

#### 2.3.2.5 Justification

Logs the triggering event, key identifiers (e.g., document ID), and the outcome of the business logic.

### 2.3.3.0 Component

#### 2.3.3.1 Component

scheduled-task-functions-009

#### 2.3.3.2 Category

🔹 BatchJob

#### 2.3.3.3 Log Level

INFO

#### 2.3.3.4 Verbose Logging

❌ No

#### 2.3.3.5 Justification

Logs the start and end of batch jobs, with a summary of records processed, successes, and failures.

### 2.3.4.0 Component

#### 2.3.4.1 Component

flutter-mobile-web-client-001

#### 2.3.4.2 Category

🔹 Client

#### 2.3.4.3 Log Level

ERROR

#### 2.3.4.4 Verbose Logging

❌ No

#### 2.3.4.5 Justification

Client-side crash and non-fatal error reporting is handled by Firebase Crashlytics as per REQ-1-076. General logging is not required to be sent to a central store.

## 2.4.0.0 Sampling Strategies

*No items available*

## 2.5.0.0 Logging Approach

### 2.5.1.0 Structured

✅ Yes

### 2.5.2.0 Format

JSON

### 2.5.3.0 Standard Fields

- timestamp
- severity
- message
- traceId
- tenantId
- actingUserId

### 2.5.4.0 Custom Fields

- componentName
- functionName
- durationMs
- correlationId

# 3.0.0.0 Log Aggregation Architecture

## 3.1.0.0 Collection Mechanism

### 3.1.1.0 Type

🔹 direct

### 3.1.2.0 Technology

Google Cloud Logging

### 3.1.3.0 Configuration

*No data available*

### 3.1.4.0 Justification

Native, zero-configuration integration for Firebase Cloud Functions as mandated by the architecture (REQ-1-013, REQ-1-076). All logs written to standard output are automatically ingested.

## 3.2.0.0 Strategy

| Property | Value |
|----------|-------|
| Approach | centralized |
| Reasoning | All server-side logs are automatically aggregated ... |
| Local Retention | N/A |

## 3.3.0.0 Shipping Methods

*No items available*

## 3.4.0.0 Buffering And Batching

| Property | Value |
|----------|-------|
| Buffer Size | N/A |
| Batch Size | 0 |
| Flush Interval | N/A |
| Backpressure Handling | Managed by the GCP platform. |

## 3.5.0.0 Transformation And Enrichment

- {'transformation': 'Add Contextual Fields', 'purpose': 'Enrich logs with tenantId, userId, and traceId to enable effective filtering and troubleshooting in a multi-tenant environment.', 'stage': 'collection'}

## 3.6.0.0 High Availability

| Property | Value |
|----------|-------|
| Required | ✅ |
| Redundancy | Regional |
| Failover Strategy | Managed by the underlying Google Cloud Logging ser... |

# 4.0.0.0 Retention Policy Design

## 4.1.0.0 Retention Periods

### 4.1.1.0 Log Type

#### 4.1.1.1 Log Type

ApplicationLogs

#### 4.1.1.2 Retention Period

90 days

#### 4.1.1.3 Justification

Provides a sufficient window for debugging recent production issues and analyzing short-term trends.

#### 4.1.1.4 Compliance Requirement

N/A

### 4.1.2.0 Log Type

#### 4.1.2.1 Log Type

AuditTrailLogs

#### 4.1.2.2 Retention Period

Configurable per tenant

#### 4.1.2.3 Justification

The application's functional `AuditLog` is stored in Firestore, with retention defined by REQ-1-061. This is separate from system logs.

#### 4.1.2.4 Compliance Requirement

REQ-1-061

## 4.2.0.0 Compliance Requirements

- {'regulation': 'GDPR', 'applicableLogTypes': ['ApplicationLogs'], 'minimumRetention': 'N/A', 'specialHandling': 'Personally Identifiable Information (PII) must be excluded from logs. Log user IDs instead of names or emails.'}

## 4.3.0.0 Volume Impact Analysis

| Property | Value |
|----------|-------|
| Estimated Daily Volume | Dependent on user activity |
| Storage Cost Projection | Must be monitored via GCP Billing and controlled w... |
| Compression Ratio | Managed by Google Cloud Logging. |

## 4.4.0.0 Storage Tiering

### 4.4.1.0 Hot Storage

| Property | Value |
|----------|-------|
| Duration | 90 days |
| Accessibility | immediate |
| Cost | medium |

### 4.4.2.0 Warm Storage

| Property | Value |
|----------|-------|
| Duration | N/A |
| Accessibility | minutes |
| Cost | medium |

### 4.4.3.0 Cold Storage

| Property | Value |
|----------|-------|
| Duration | N/A |
| Accessibility | hours |
| Cost | low |

## 4.5.0.0 Compression Strategy

| Property | Value |
|----------|-------|
| Algorithm | N/A |
| Compression Level | N/A |
| Expected Ratio | Managed by Google Cloud Logging. |

## 4.6.0.0 Anonymization Requirements

*No items available*

# 5.0.0.0 Search Capability Requirements

## 5.1.0.0 Essential Capabilities

### 5.1.1.0 Capability

#### 5.1.1.1 Capability

Filter logs by tenantId

#### 5.1.1.2 Performance Requirement

< 5 seconds

#### 5.1.1.3 Justification

Essential for isolating issues to a specific customer in a multi-tenant architecture (REQ-1-002).

### 5.1.2.0 Capability

#### 5.1.2.1 Capability

Filter logs by traceId

#### 5.1.2.2 Performance Requirement

< 5 seconds

#### 5.1.2.3 Justification

Essential for correlating logs from a single request flow across multiple function invocations.

### 5.1.3.0 Capability

#### 5.1.3.1 Capability

Full-text search on log messages

#### 5.1.3.2 Performance Requirement

< 10 seconds

#### 5.1.3.3 Justification

Required for general-purpose troubleshooting and keyword-based error searching.

## 5.2.0.0 Performance Characteristics

| Property | Value |
|----------|-------|
| Search Latency | Sub-second for indexed fields, seconds for full-te... |
| Concurrent Users | 5 |
| Query Complexity | simple |
| Indexing Strategy | Automatic indexing on standard and JSON payload fi... |

## 5.3.0.0 Indexed Fields

### 5.3.1.0 Field

#### 5.3.1.1 Field

severity

#### 5.3.1.2 Index Type

Keyword

#### 5.3.1.3 Search Pattern

Filtering (e.g., severity = 'ERROR')

#### 5.3.1.4 Frequency

high

### 5.3.2.0 Field

#### 5.3.2.1 Field

jsonPayload.tenantId

#### 5.3.2.2 Index Type

Keyword

#### 5.3.2.3 Search Pattern

Filtering

#### 5.3.2.4 Frequency

high

### 5.3.3.0 Field

#### 5.3.3.1 Field

jsonPayload.traceId

#### 5.3.3.2 Index Type

Keyword

#### 5.3.3.3 Search Pattern

Correlation

#### 5.3.3.4 Frequency

high

## 5.4.0.0 Full Text Search

### 5.4.1.0 Required

✅ Yes

### 5.4.2.0 Fields

- textPayload
- jsonPayload.message

### 5.4.3.0 Search Engine

Google Cloud Logging

### 5.4.4.0 Relevance Scoring

✅ Yes

## 5.5.0.0 Correlation And Tracing

### 5.5.1.0 Correlation Ids

- traceId

### 5.5.2.0 Trace Id Propagation

Handled by GCP for traces initiated by HTTP functions. Must be manually propagated for background/event-driven flows.

### 5.5.3.0 Span Correlation

✅ Yes

### 5.5.4.0 Cross Service Tracing

✅ Yes

## 5.6.0.0 Dashboard Requirements

- {'dashboard': 'Cloud Function Health', 'purpose': 'Monitor overall error rates, invocation counts, and latencies for all server-side functions.', 'refreshInterval': '1 minute', 'audience': 'Development/Operations'}

# 6.0.0.0 Storage Solution Selection

## 6.1.0.0 Selected Technology

### 6.1.1.0 Primary

Google Cloud Logging

### 6.1.2.0 Reasoning

It is the native, fully managed, and deeply integrated solution for the mandated Firebase/GCP technology stack (REQ-1-012, REQ-1-076).

### 6.1.3.0 Alternatives

*No items available*

## 6.2.0.0 Scalability Requirements

| Property | Value |
|----------|-------|
| Expected Growth Rate | Variable |
| Peak Load Handling | Handled automatically by the serverless platform. |
| Horizontal Scaling | ✅ |

## 6.3.0.0 Cost Performance Analysis

- {'solution': 'Google Cloud Logging', 'costPerGB': 'Usage-based pricing with a generous free tier.', 'queryPerformance': 'Excellent for indexed fields, acceptable for full-text search.', 'operationalComplexity': 'low'}

## 6.4.0.0 Backup And Recovery

| Property | Value |
|----------|-------|
| Backup Frequency | N/A (Logs can be exported via sinks for long-term ... |
| Recovery Time Objective | N/A |
| Recovery Point Objective | N/A |
| Testing Frequency | N/A |

## 6.5.0.0 Geo Distribution

### 6.5.1.0 Required

❌ No

### 6.5.2.0 Regions

*No items available*

### 6.5.3.0 Replication Strategy

N/A

## 6.6.0.0 Data Sovereignty

*No items available*

# 7.0.0.0 Access Control And Compliance

## 7.1.0.0 Access Control Requirements

- {'role': 'Developer', 'permissions': ['logging.logEntries.list', 'monitoring.timeSeries.list'], 'logTypes': ['ApplicationLogs'], 'justification': 'Developers require access to logs in all environments for troubleshooting and debugging.'}

## 7.2.0.0 Sensitive Data Handling

- {'dataType': 'PII', 'handlingStrategy': 'exclude', 'fields': ['email', 'name', 'password', 'phone number'], 'complianceRequirement': 'GDPR (REQ-1-023)'}

## 7.3.0.0 Encryption Requirements

### 7.3.1.0 In Transit

| Property | Value |
|----------|-------|
| Required | ✅ |
| Protocol | TLS |
| Certificate Management | Managed by Google Cloud. |

### 7.3.2.0 At Rest

| Property | Value |
|----------|-------|
| Required | ✅ |
| Algorithm | AES-256 |
| Key Management | Managed by Google Cloud. |

## 7.4.0.0 Audit Trail

| Property | Value |
|----------|-------|
| Log Access | ✅ |
| Retention Period | 400 days |
| Audit Log Location | Google Cloud Audit Logs |
| Compliance Reporting | ✅ |

## 7.5.0.0 Regulatory Compliance

- {'regulation': 'GDPR', 'applicableComponents': ['All components processing or logging user data.'], 'specificRequirements': ['Do not log PII.', 'Adhere to data retention policies.'], 'evidenceCollection': "Via Cloud Audit Logs and application's own AuditLog table."}

## 7.6.0.0 Data Protection Measures

*No items available*

# 8.0.0.0 Project Specific Logging Config

## 8.1.0.0 Logging Config

### 8.1.1.0 Level

🔹 INFO

### 8.1.2.0 Retention

90 days

### 8.1.3.0 Aggregation

Centralized in Google Cloud Logging

### 8.1.4.0 Storage

Google Cloud Logging

### 8.1.5.0 Configuration

*No data available*

## 8.2.0.0 Component Configurations

- {'component': 'All Cloud Functions', 'logLevel': 'INFO', 'outputFormat': 'Structured JSON', 'destinations': ['stdout'], 'sampling': {'enabled': False, 'rate': 'N/A'}, 'customFields': ['tenantId', 'actingUserId', 'traceId']}

## 8.3.0.0 Metrics

### 8.3.1.0 Custom Metrics

*No data available*

## 8.4.0.0 Alert Rules

- {'name': 'Cloud Function High Error Rate', 'condition': 'Error rate for any function exceeds 1% over a 5-minute window.', 'severity': 'High', 'actions': [{'type': 'email', 'target': 'on-call-dev-team@example.com', 'configuration': {}}], 'suppressionRules': [], 'escalationPath': []}

# 9.0.0.0 Implementation Priority

## 9.1.0.0 Component

### 9.1.1.0 Component

Structured Logging Implementation

### 9.1.2.0 Priority

🔴 high

### 9.1.3.0 Dependencies

*No items available*

### 9.1.4.0 Estimated Effort

Medium

### 9.1.5.0 Risk Level

low

## 9.2.0.0 Component

### 9.2.1.0 Component

Error Rate Alerting Configuration

### 9.2.2.0 Priority

🔴 high

### 9.2.3.0 Dependencies

*No items available*

### 9.2.4.0 Estimated Effort

Low

### 9.2.5.0 Risk Level

low

## 9.3.0.0 Component

### 9.3.1.0 Component

Client-Side Crashlytics Integration

### 9.3.2.0 Priority

🔴 high

### 9.3.3.0 Dependencies

*No items available*

### 9.3.4.0 Estimated Effort

Low

### 9.3.5.0 Risk Level

low

# 10.0.0.0 Risk Assessment

## 10.1.0.0 Risk

### 10.1.1.0 Risk

Accidental logging of PII.

### 10.1.2.0 Impact

high

### 10.1.3.0 Probability

medium

### 10.1.4.0 Mitigation

Implement a shared logging utility that scrubs or omits sensitive fields. Enforce via code reviews.

### 10.1.5.0 Contingency Plan

Procedure to purge specific logs from Google Cloud Logging.

## 10.2.0.0 Risk

### 10.2.1.0 Risk

Excessive logging leading to high costs.

### 10.2.2.0 Impact

medium

### 10.2.3.0 Probability

medium

### 10.2.4.0 Mitigation

Set default log level to INFO in production. Implement GCP budget alerts as required by REQ-1-076.

### 10.2.5.0 Contingency Plan

Temporarily raise the log level to WARN or ERROR for noisy components while investigating.

# 11.0.0.0 Recommendations

## 11.1.0.0 Category

### 11.1.1.0 Category

🔹 Development

### 11.1.2.0 Recommendation

Create and enforce the use of a shared logging utility/wrapper for all Cloud Functions.

### 11.1.3.0 Justification

Ensures all logs are consistently structured with essential fields like `tenantId` and `traceId`, which is critical for effective troubleshooting in a multi-tenant, serverless environment.

### 11.1.4.0 Priority

🔴 high

### 11.1.5.0 Implementation Notes

The utility should accept a standard object and automatically enrich it with context from the request or event.

## 11.2.0.0 Category

### 11.2.1.0 Category

🔹 Operations

### 11.2.2.0 Recommendation

Manually propagate a `traceId` for asynchronous, event-driven workflows that are not automatically traced by GCP.

### 11.2.3.0 Justification

Allows for end-to-end visibility of a business process that spans multiple, decoupled function invocations (e.g., a user action leading to a Firestore write, which triggers another function).

### 11.2.4.0 Priority

🟡 medium

### 11.2.5.0 Implementation Notes

Pass the traceId from the initial function's execution context into the metadata of any new event or document being created.

