# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Technology Stack

- Flutter
- Firebase (Authentication, Firestore, Cloud Functions)
- TypeScript
- Google Cloud's Operations Suite
- Firebase Crashlytics

## 1.3 Monitoring Components

- Google Cloud Monitoring
- Google Cloud Logging
- Firebase Crashlytics
- GCP Billing Alerts

## 1.4 Requirements

- REQ-1-067 (Performance Targets)
- REQ-1-070 (Availability)
- REQ-1-076 (Monitoring & Alerting)

## 1.5 Environment

production

# 2.0 Standard System Metrics Selection

## 2.1 Hardware Utilization Metrics

*No items available*

## 2.2 Runtime Metrics

- {'name': 'cloud_function.memory_usage', 'type': 'gauge', 'unit': 'Megabytes', 'description': 'Memory consumed by individual Cloud Function invocations to monitor for over-provisioning and potential memory leaks.', 'technology': 'Node.js', 'collection': {'interval': 'real-time', 'method': 'Google Cloud Monitoring Agent'}, 'criticality': 'medium'}

## 2.3 Request Response Metrics

- {'name': 'cloud_function.execution_times', 'type': 'histogram', 'unit': 'Milliseconds', 'description': 'Latency of all Cloud Function executions, essential for tracking overall backend performance and identifying slow functions.', 'dimensions': ['function_name', 'region', 'status'], 'percentiles': ['p50', 'p95', 'p99'], 'collection': {'interval': 'real-time', 'method': 'Google Cloud Monitoring Agent'}}

## 2.4 Availability Metrics

- {'name': 'system.availability', 'type': 'gauge', 'unit': 'Percentage', 'description': 'The overall availability of the service, measured by periodic uptime checks against a critical health-check endpoint.', 'calculation': '(Successful Checks / Total Checks) * 100 over a rolling window.', 'slaTarget': '99.9'}

## 2.5 Scalability Metrics

- {'name': 'cloud_function.active_instances', 'type': 'gauge', 'unit': 'Count', 'description': 'Number of active (warm) Cloud Function instances. Helps in understanding scaling behavior and potential cold start impact.', 'capacityThreshold': 'N/A (Serverless)', 'autoScalingTrigger': True}

# 3.0 Application Specific Metrics Design

## 3.1 Transaction Metrics

- {'name': 'attendance.submission.count', 'type': 'counter', 'unit': 'Count', 'description': 'Total number of attendance check-in/out events submitted, representing the core transaction of the application.', 'business_context': 'Core user activity', 'dimensions': ['tenantId', 'submission_mode: (online|offline)', 'action: (check_in|check_out)'], 'collection': {'interval': 'real-time', 'method': 'Application Instrumentation'}, 'aggregation': {'functions': ['sum', 'rate'], 'window': '1m'}}

## 3.2 Cache Performance Metrics

*No items available*

## 3.3 External Dependency Metrics

### 3.3.1 external.api.request.latency

#### 3.3.1.1 Name

external.api.request.latency

#### 3.3.1.2 Type

🔹 histogram

#### 3.3.1.3 Unit

Milliseconds

#### 3.3.1.4 Description

Latency of outbound API calls from Cloud Functions to external services like Google Sheets and SendGrid.

#### 3.3.1.5 Dependency

Google Sheets, SendGrid

#### 3.3.1.6 Circuit Breaker Integration

❌ No

#### 3.3.1.7 Sla

##### 3.3.1.7.1 Response Time

N/A (Best Effort)

##### 3.3.1.7.2 Availability

N/A (Best Effort)

### 3.3.2.0.0 external.api.request.errors.count

#### 3.3.2.1.0 Name

external.api.request.errors.count

#### 3.3.2.2.0 Type

🔹 counter

#### 3.3.2.3.0 Unit

Count

#### 3.3.2.4.0 Description

Count of failed API calls to external services, categorized by service and error code.

#### 3.3.2.5.0 Dependency

Google Sheets, SendGrid

#### 3.3.2.6.0 Circuit Breaker Integration

❌ No

#### 3.3.2.7.0 Sla

*Not specified*

## 3.4.0.0.0 Error Metrics

### 3.4.1.0.0 cloud_function.error.rate

#### 3.4.1.1.0 Name

cloud_function.error.rate

#### 3.4.1.2.0 Type

🔹 gauge

#### 3.4.1.3.0 Unit

Percentage

#### 3.4.1.4.0 Description

The rate of Cloud Function executions that result in an error, as a percentage of total executions.

#### 3.4.1.5.0 Error Types

- unhandled_exception
- timeout

#### 3.4.1.6.0 Dimensions

- function_name
- region

#### 3.4.1.7.0 Alert Threshold

>1%

### 3.4.2.0.0 client.crash.rate

#### 3.4.2.1.0 Name

client.crash.rate

#### 3.4.2.2.0 Type

🔹 gauge

#### 3.4.2.3.0 Unit

Percentage

#### 3.4.2.4.0 Description

Percentage of user sessions that end in a crash, reported by Firebase Crashlytics.

#### 3.4.2.5.0 Error Types

- fatal

#### 3.4.2.6.0 Dimensions

- app_version
- os_version
- device_model

#### 3.4.2.7.0 Alert Threshold

>0.5%

### 3.4.3.0.0 offline.sync.failure.count

#### 3.4.3.1.0 Name

offline.sync.failure.count

#### 3.4.3.2.0 Type

🔹 counter

#### 3.4.3.3.0 Unit

Count

#### 3.4.3.4.0 Description

Number of times a user is presented with a persistent sync failure notification after 24 hours of unsuccessful sync attempts.

#### 3.4.3.5.0 Error Types

- persistent_sync_failure

#### 3.4.3.6.0 Dimensions

*No items available*

#### 3.4.3.7.0 Alert Threshold

N/A

## 3.5.0.0.0 Throughput And Latency Metrics

- {'name': 'callable_function.request.latency', 'type': 'histogram', 'unit': 'Milliseconds', 'description': 'End-to-end latency for synchronous, client-invoked (Callable) Cloud Functions, as specified in REQ-1-067.', 'percentiles': ['p50', 'p95', 'p99'], 'buckets': ['100', '250', '500', '1000', '2000'], 'slaTargets': {'p95': '< 500ms', 'p99': '< 1000ms'}}

# 4.0.0.0.0 Business Kpi Identification

## 4.1.0.0.0 Critical Business Metrics

- {'name': 'tenant.active.count', 'type': 'gauge', 'unit': 'Count', 'description': 'Total number of active customer organizations (tenants).', 'businessOwner': 'Product Management', 'calculation': "COUNT(tenants WHERE status = 'active')", 'reportingFrequency': 'daily', 'target': 'N/A'}

## 4.2.0.0.0 User Engagement Metrics

- {'name': 'daily_active_users', 'type': 'gauge', 'unit': 'Count', 'description': 'Number of unique users who perform at least one action (e.g., login, check-in) in a 24-hour period.', 'segmentation': ['subscription_plan', 'user_role'], 'cohortAnalysis': False}

## 4.3.0.0.0 Conversion Metrics

- {'name': 'user.invitation_to_activation.rate', 'type': 'gauge', 'unit': 'Percentage', 'description': 'The percentage of invited users who successfully complete registration and activate their account.', 'funnelStage': 'Onboarding', 'conversionTarget': '>85%'}

## 4.4.0.0.0 Operational Efficiency Kpis

- {'name': 'attendance.approval.time.avg', 'type': 'gauge', 'unit': 'Hours', 'description': 'The average time it takes for a supervisor to approve or reject a pending attendance record.', 'calculation': 'AVG(approval_timestamp - submission_timestamp)', 'benchmarkTarget': '< 24 hours'}

## 4.5.0.0.0 Revenue And Cost Metrics

- {'name': 'gcp.project.cost.monthly', 'type': 'gauge', 'unit': 'USD', 'description': 'Total monthly cost of the GCP project, used for budget alerting.', 'frequency': 'daily', 'accuracy': 'High'}

## 4.6.0.0.0 Customer Satisfaction Indicators

*No items available*

# 5.0.0.0.0 Collection Interval Optimization

## 5.1.0.0.0 Sampling Frequencies

### 5.1.1.0.0 Metric Category

#### 5.1.1.1.0 Metric Category

Cloud Function Performance

#### 5.1.1.2.0 Interval

real-time

#### 5.1.1.3.0 Justification

Required for immediate performance monitoring and alerting on latency/errors.

#### 5.1.1.4.0 Resource Impact

low

### 5.1.2.0.0 Metric Category

#### 5.1.2.1.0 Metric Category

Client-Side Performance

#### 5.1.2.2.0 Interval

per-session

#### 5.1.2.3.0 Justification

Data is collected by the SDK during user sessions and sent in batches.

#### 5.1.2.4.0 Resource Impact

low

### 5.1.3.0.0 Metric Category

#### 5.1.3.1.0 Metric Category

Business KPIs

#### 5.1.3.2.0 Interval

24h

#### 5.1.3.3.0 Justification

Business trends do not require real-time updates; daily aggregation is sufficient and cost-effective.

#### 5.1.3.4.0 Resource Impact

low

## 5.2.0.0.0 High Frequency Metrics

- {'name': 'callable_function.request.latency', 'interval': 'real-time', 'criticality': 'high', 'costJustification': 'Directly tied to user experience and a core performance requirement (REQ-1-067).'}

## 5.3.0.0.0 Cardinality Considerations

- {'metricName': 'attendance.submission.count', 'estimatedCardinality': 'Medium (proportional to number of tenants)', 'dimensionStrategy': 'Include `tenantId` to allow for per-customer analysis.', 'mitigationApproach': 'Monitor costs associated with high-cardinality dimensions. If costs become prohibitive, consider aggregating at a regional or plan level.'}

## 5.4.0.0.0 Aggregation Periods

### 5.4.1.0.0 Metric Type

#### 5.4.1.1.0 Metric Type

Performance

#### 5.4.1.2.0 Periods

- 1m
- 5m
- 1h

#### 5.4.1.3.0 Retention Strategy

Raw data for 30 days, aggregated for 1 year.

### 5.4.2.0.0 Metric Type

#### 5.4.2.1.0 Metric Type

Business

#### 5.4.2.2.0 Periods

- 1d
- 1w
- 1m

#### 5.4.2.3.0 Retention Strategy

Aggregated data retained for 2+ years.

## 5.5.0.0.0 Collection Methods

### 5.5.1.0.0 Method

#### 5.5.1.1.0 Method

real-time

#### 5.5.1.2.0 Applicable Metrics

- cloud_function.execution_times
- cloud_function.error.rate
- callable_function.request.latency

#### 5.5.1.3.0 Implementation

Default behavior of Google Cloud Monitoring for Firebase.

#### 5.5.1.4.0 Performance

High

### 5.5.2.0.0 Method

#### 5.5.2.1.0 Method

batch

#### 5.5.2.2.0 Applicable Metrics

- daily_active_users
- tenant.active.count
- attendance.approval.time.avg

#### 5.5.2.3.0 Implementation

Scheduled Cloud Function running daily to calculate and write metrics to a summary collection or monitoring service.

#### 5.5.2.4.0 Performance

N/A (background)

# 6.0.0.0.0 Aggregation Method Selection

## 6.1.0.0.0 Statistical Aggregations

- {'metricName': 'callable_function.request.latency', 'aggregationFunctions': ['p95', 'avg', 'max', 'count'], 'windows': ['1m', '5m', '1h'], 'justification': 'P95 is required by REQ-1-067. Avg/max/count provide a complete performance picture.'}

## 6.2.0.0.0 Histogram Requirements

- {'metricName': 'callable_function.request.latency', 'buckets': ['100', '250', '500', '1000', '2000'], 'percentiles': ['p95'], 'accuracy': 'High'}

## 6.3.0.0.0 Percentile Calculations

- {'metricName': 'callable_function.request.latency', 'percentiles': ['p95'], 'algorithm': 'Default GCP Monitoring algorithm', 'accuracy': 'High'}

## 6.4.0.0.0 Metric Types

### 6.4.1.0.0 tenant.active.count

#### 6.4.1.1.0 Name

tenant.active.count

#### 6.4.1.2.0 Implementation

gauge

#### 6.4.1.3.0 Reasoning

Represents a point-in-time value that can go up or down.

#### 6.4.1.4.0 Resets Handling

N/A

### 6.4.2.0.0 attendance.submission.count

#### 6.4.2.1.0 Name

attendance.submission.count

#### 6.4.2.2.0 Implementation

counter

#### 6.4.2.3.0 Reasoning

A monotonically increasing value representing total events.

#### 6.4.2.4.0 Resets Handling

Handled by monitoring system to calculate rate.

## 6.5.0.0.0 Dimensional Aggregation

- {'metricName': 'cloud_function.error.rate', 'dimensions': ['function_name'], 'aggregationStrategy': 'Average rate across all instances of a given function.', 'cardinalityImpact': 'Low'}

## 6.6.0.0.0 Derived Metrics

### 6.6.1.0.0 system.availability

#### 6.6.1.1.0 Name

system.availability

#### 6.6.1.2.0 Calculation

(Successful Uptime Checks / Total Uptime Checks) * 100

#### 6.6.1.3.0 Source Metrics

- uptime_check.success.count
- uptime_check.total.count

#### 6.6.1.4.0 Update Frequency

1m

### 6.6.2.0.0 user.invitation_to_activation.rate

#### 6.6.2.1.0 Name

user.invitation_to_activation.rate

#### 6.6.2.2.0 Calculation

COUNT(user.registration.complete) / COUNT(user.invitation.sent)

#### 6.6.2.3.0 Source Metrics

- user.registration.complete.count
- user.invitation.sent.count

#### 6.6.2.4.0 Update Frequency

24h

# 7.0.0.0.0 Storage Requirements Planning

## 7.1.0.0.0 Retention Periods

### 7.1.1.0.0 Metric Type

#### 7.1.1.1.0 Metric Type

High-Resolution Performance

#### 7.1.1.2.0 Retention Period

30 days

#### 7.1.1.3.0 Justification

Sufficient for recent performance debugging and analysis.

#### 7.1.1.4.0 Compliance Requirement

N/A

### 7.1.2.0.0 Metric Type

#### 7.1.2.1.0 Metric Type

Aggregated Business KPIs

#### 7.1.2.2.0 Retention Period

2 years

#### 7.1.2.3.0 Justification

Needed for year-over-year business trend analysis.

#### 7.1.2.4.0 Compliance Requirement

N/A

## 7.2.0.0.0 Data Resolution

### 7.2.1.0.0 Time Range

#### 7.2.1.1.0 Time Range

0-30 days

#### 7.2.1.2.0 Resolution

1 minute

#### 7.2.1.3.0 Query Performance

High

#### 7.2.1.4.0 Storage Optimization

None

### 7.2.2.0.0 Time Range

#### 7.2.2.1.0 Time Range

31 days - 2 years

#### 7.2.2.2.0 Resolution

1 hour / 1 day

#### 7.2.2.3.0 Query Performance

Medium

#### 7.2.2.4.0 Storage Optimization

Downsampling

## 7.3.0.0.0 Downsampling Strategies

- {'sourceResolution': '1 minute', 'targetResolution': '1 hour', 'aggregationMethod': 'avg for latency, sum for counts', 'triggerCondition': 'Data older than 30 days'}

## 7.4.0.0.0 Storage Performance

| Property | Value |
|----------|-------|
| Write Latency | < 1s |
| Query Latency | < 5s for dashboards |
| Throughput Requirements | Handled by Google Cloud Monitoring |
| Scalability Needs | Handled by Google Cloud Monitoring |

## 7.5.0.0.0 Query Optimization

*No items available*

## 7.6.0.0.0 Cost Optimization

- {'strategy': 'Data Downsampling and Retention Policies', 'implementation': 'Configure retention rules in Google Cloud Monitoring.', 'expectedSavings': 'Significant (50-80% of long-term storage costs)', 'tradeoffs': 'Loss of fine-grained historical data beyond 30 days.'}

# 8.0.0.0.0 Project Specific Metrics Config

## 8.1.0.0.0 Standard Metrics

### 8.1.1.0.0 cloud_function.execution_times

#### 8.1.1.1.0 Name

cloud_function.execution_times

#### 8.1.1.2.0 Type

🔹 histogram

#### 8.1.1.3.0 Unit

Milliseconds

#### 8.1.1.4.0 Collection

##### 8.1.1.4.1 Interval

real-time

##### 8.1.1.4.2 Method

Google Cloud Monitoring

#### 8.1.1.5.0 Thresholds

##### 8.1.1.5.1 Warning

p95 > 400ms

##### 8.1.1.5.2 Critical

p95 > 500ms

#### 8.1.1.6.0 Dimensions

- function_name

### 8.1.2.0.0 cloud_function.error.rate

#### 8.1.2.1.0 Name

cloud_function.error.rate

#### 8.1.2.2.0 Type

🔹 gauge

#### 8.1.2.3.0 Unit

Percentage

#### 8.1.2.4.0 Collection

##### 8.1.2.4.1 Interval

real-time

##### 8.1.2.4.2 Method

Google Cloud Monitoring

#### 8.1.2.5.0 Thresholds

##### 8.1.2.5.1 Warning

>0.5%

##### 8.1.2.5.2 Critical

>1%

#### 8.1.2.6.0 Dimensions

- function_name

### 8.1.3.0.0 client.crash.rate

#### 8.1.3.1.0 Name

client.crash.rate

#### 8.1.3.2.0 Type

🔹 gauge

#### 8.1.3.3.0 Unit

Percentage

#### 8.1.3.4.0 Collection

##### 8.1.3.4.1 Interval

per-session

##### 8.1.3.4.2 Method

Firebase Crashlytics

#### 8.1.3.5.0 Thresholds

##### 8.1.3.5.1 Warning

>0.25%

##### 8.1.3.5.2 Critical

>0.5%

#### 8.1.3.6.0 Dimensions

- app_version
- os_version

## 8.2.0.0.0 Custom Metrics

- {'name': 'tenant.active.count', 'description': 'Total number of active customer organizations.', 'calculation': 'Scheduled function queries Firestore daily.', 'type': 'gauge', 'unit': 'Count', 'businessContext': 'Primary business growth KPI.', 'collection': {'interval': '24h', 'method': 'Batch Job'}, 'alerting': {'enabled': False, 'conditions': []}}

## 8.3.0.0.0 Dashboard Metrics

### 8.3.1.0.0 Dashboard

#### 8.3.1.1.0 Dashboard

Operations Health Dashboard

#### 8.3.1.2.0 Metrics

- system.availability
- callable_function.request.latency (p95)
- cloud_function.error.rate
- client.crash.rate
- gcp.project.cost.monthly

#### 8.3.1.3.0 Refresh Interval

1m

#### 8.3.1.4.0 Audience

Engineering/DevOps

### 8.3.2.0.0 Dashboard

#### 8.3.2.1.0 Dashboard

Business KPI Dashboard

#### 8.3.2.2.0 Metrics

- tenant.active.count
- daily_active_users
- user.invitation_to_activation.rate
- attendance.approval.time.avg

#### 8.3.2.3.0 Refresh Interval

1h

#### 8.3.2.4.0 Audience

Product Management/Leadership

# 9.0.0.0.0 Implementation Priority

## 9.1.0.0.0 Component

### 9.1.1.0.0 Component

Cloud Function & Client Performance/Error Metrics

### 9.1.2.0.0 Priority

🔴 high

### 9.1.3.0.0 Dependencies

*No items available*

### 9.1.4.0.0 Estimated Effort

Low (mostly out-of-the-box)

### 9.1.5.0.0 Risk Level

low

## 9.2.0.0.0 Component

### 9.2.1.0.0 Component

Alerting Configuration

### 9.2.2.0.0 Priority

🔴 high

### 9.2.3.0.0 Dependencies

- Cloud Function & Client Performance/Error Metrics

### 9.2.4.0.0 Estimated Effort

Low

### 9.2.5.0.0 Risk Level

low

## 9.3.0.0.0 Component

### 9.3.1.0.0 Component

Transaction & External Dependency Metrics

### 9.3.2.0.0 Priority

🟡 medium

### 9.3.3.0.0 Dependencies

*No items available*

### 9.3.4.0.0 Estimated Effort

Medium (requires custom instrumentation)

### 9.3.5.0.0 Risk Level

medium

## 9.4.0.0.0 Component

### 9.4.1.0.0 Component

Business KPI Batch Jobs & Dashboards

### 9.4.2.0.0 Priority

🟡 medium

### 9.4.3.0.0 Dependencies

*No items available*

### 9.4.4.0.0 Estimated Effort

High (requires development of aggregation functions)

### 9.4.5.0.0 Risk Level

medium

# 10.0.0.0.0 Risk Assessment

## 10.1.0.0.0 Risk

### 10.1.1.0.0 Risk

High cardinality dimensions (`tenantId`) significantly increase monitoring costs.

### 10.1.2.0.0 Impact

medium

### 10.1.3.0.0 Probability

medium

### 10.1.4.0.0 Mitigation

Start with `tenantId` included, but actively monitor costs. If necessary, switch to an opt-in model for per-tenant metrics for specific, high-value customers.

### 10.1.5.0.0 Contingency Plan

Remove the `tenantId` dimension from high-frequency metrics and rely on logs for per-tenant debugging.

## 10.2.0.0.0 Risk

### 10.2.1.0.0 Risk

Alert fatigue for operations team due to poorly tuned thresholds.

### 10.2.2.0.0 Impact

medium

### 10.2.3.0.0 Probability

high

### 10.2.4.0.0 Mitigation

Establish initial alerting thresholds based on requirements, but plan to review and adjust them based on real-world performance after the first month of operation.

### 10.2.5.0.0 Contingency Plan

Temporarily disable non-critical alerts until they can be properly tuned.

# 11.0.0.0.0 Recommendations

## 11.1.0.0.0 Category

### 11.1.1.0.0 Category

🔹 Implementation

### 11.1.2.0.0 Recommendation

Leverage log-based metrics in Google Cloud Monitoring to create application-specific metrics (e.g., `offline.sync.failure.count`) without requiring complex custom instrumentation.

### 11.1.3.0.0 Justification

This is a fast and cost-effective way to get custom metrics from structured logs, reducing initial development effort.

### 11.1.4.0.0 Priority

🔴 high

### 11.1.5.0.0 Implementation Notes

Ensure all relevant events are logged with a consistent JSON structure containing a unique `eventName` field to filter on.

## 11.2.0.0.0 Category

### 11.2.1.0.0 Category

🔹 Strategy

### 11.2.2.0.0 Recommendation

Create two primary dashboards: one for real-time operational health (for engineers) and another for daily/weekly business trends (for product/management).

### 11.2.3.0.0 Justification

Separating these concerns provides the right level of detail to the right audience, making the metrics more actionable and preventing information overload.

### 11.2.4.0.0 Priority

🔴 high

### 11.2.5.0.0 Implementation Notes

Use Google Cloud Monitoring for the operational dashboard and a tool like Looker Studio (connected to a BigQuery sink) for the business dashboard.

