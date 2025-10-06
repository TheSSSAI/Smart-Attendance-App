# 1 Diagram Info

## 1.1 Diagram Name

Tenant Usage Alerting Process

## 1.2 Diagram Type

sequenceDiagram

## 1.3 Purpose

To visualize the automated backend process that monitors tenant resource usage, compares it against subscription limits, and sends alerts to Admins when predefined thresholds are crossed, as described in US-087.

## 1.4 Target Audience

- developers
- product managers
- QA engineers

## 1.5 Complexity Level

high

## 1.6 Estimated Review Time

5 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | sequenceDiagram
    participant GoogleCloudSchedul... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | This sequence diagram clearly shows the backend or... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- Google Cloud Scheduler
- UsageAnalysisFunction (Cloud Function)
- BigQuery
- Firestore Database
- SendGrid API
- Admin Web Dashboard (Client)

## 3.2 Key Processes

- Scheduled job invocation
- Querying aggregated usage data
- Comparing usage against tier limits
- Checking for previously sent alerts (idempotency)
- Dispatching email notifications
- Updating alert status in database
- Real-time UI update via Firestore listener

## 3.3 Decision Points

- Check if usage exceeds a threshold (e.g., 80%)
- Check if an alert for that threshold has already been sent in the current billing cycle

## 3.4 Success Paths

- Usage threshold is crossed for the first time, an email alert is sent, and the database is updated to prevent duplicates.

## 3.5 Error Scenarios

- BigQuery API is unavailable
- SendGrid API returns an error
- Firestore write fails

## 3.6 Edge Cases Covered

- A tenant has already received an alert for the current cycle (idempotency check)
- A new billing cycle starts, requiring alert flags to be reset

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A sequence diagram illustrating the automated proc... |
| Color Independence | Diagram uses standard sequence arrows and text, no... |
| Screen Reader Friendly | All participants and interactions have clear, desc... |
| Print Compatibility | Diagram is in black and white and prints clearly. |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Diagram scales well for both wide and narrow viewp... |
| Theme Compatibility | Designed to work with default light and dark theme... |
| Performance Notes | The sequence is linear and does not contain comple... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During backend development of the usage monitoring feature, for creating integration tests, and during security reviews of the data pipeline.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear, step-by-step guide for implement... |
| Designers | Helps understand the asynchronous nature of the in... |
| Product Managers | Visually confirms that the business rules for aler... |
| Qa Engineers | Outlines the full data flow, enabling the design o... |

## 6.3 Maintenance Notes

Update this diagram if new alertable metrics are added, if the source of usage data changes from BigQuery, or if the notification channel expands beyond email.

## 6.4 Integration Recommendations

Embed this diagram in the technical design document for the billing and alerting system and in the associated user story (US-087).

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

