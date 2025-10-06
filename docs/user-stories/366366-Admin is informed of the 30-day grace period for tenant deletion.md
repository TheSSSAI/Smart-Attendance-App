# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-024 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin is informed of the 30-day grace period for t... |
| As A User Story | As an Admin who has just confirmed a request to de... |
| User Persona | Admin: The primary administrator of an organizatio... |
| Business Value | Provides a critical safety mechanism to prevent ac... |
| Functional Area | Tenant Management |
| Story Theme | Tenant Offboarding Workflow |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Display of grace period information after deletion confirmation

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

An Admin is logged into the web dashboard and has just successfully re-authenticated to confirm the tenant deletion request

### 3.1.5 When

the system processes the deletion request successfully

### 3.1.6 Then

the UI immediately transitions to a confirmation screen or displays a prominent, persistent banner on the dashboard.

### 3.1.7 Validation Notes

Verify that after the final confirmation click in the deletion flow, the user is presented with the grace period information without needing to navigate elsewhere.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Content of the grace period notification

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the grace period confirmation screen is displayed

### 3.2.5 When

the Admin views the content

### 3.2.6 Then

the message must explicitly state that a 30-day grace period has begun.

### 3.2.7 And

the message must clearly state that the deletion can be cancelled anytime before this date.

### 3.2.8 Validation Notes

Check the screen for the literal text '30-day grace period', a calculated date 30 days in the future, and a clear statement about the reversibility of the action.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Email notification of pending deletion

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

an Admin has successfully confirmed the tenant deletion request

### 3.3.5 When

the backend processes the request

### 3.3.6 Then

the system sends an email to the initiating Admin's registered email address.

### 3.3.7 And

the email body contains the same information as the on-screen notification: the 30-day grace period and the exact permanent deletion date.

### 3.3.8 Validation Notes

Check the SendGrid logs or the Admin's inbox to confirm receipt of the email and verify its content for accuracy and clarity.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Persistent status indicator on Admin dashboard

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

a tenant is in the 30-day grace period for deletion

### 3.4.5 When

an Admin logs in or navigates to the main dashboard

### 3.4.6 Then

a persistent, highly visible banner is displayed at the top of every page in the Admin dashboard.

### 3.4.7 And

this banner states that the account is scheduled for deletion and shows the remaining time or the final deletion date.

### 3.4.8 Validation Notes

Log in as an Admin for a tenant marked for deletion. Navigate between different sections of the dashboard (e.g., Users, Teams, Settings) and verify the banner remains visible.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A full-page confirmation view or a large, non-dismissible modal dialog.
- A persistent banner for the Admin dashboard.
- A clearly labeled button/link to 'Cancel Deletion Request' (which triggers US-025).

## 4.2.0 User Interactions

- The user is automatically redirected to the confirmation screen after the action.
- The persistent banner on the dashboard should not obstruct core UI elements but must be impossible to ignore.

## 4.3.0 Display Requirements

- Use of warning colors (e.g., amber, red) and icons (e.g., warning triangle, hourglass) to convey the seriousness of the status.
- The permanent deletion date must be formatted unambiguously, e.g., 'Tuesday, March 18, 2025, at 23:59 UTC'.

## 4.4.0 Accessibility Needs

- All text must meet WCAG 2.1 AA color contrast ratios.
- All information must be accessible to screen readers, and the banner should use appropriate ARIA roles (e.g., 'alert').

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'The grace period is a fixed duration of 30 calendar days from the moment of confirmation.', 'enforcement_point': 'Backend Cloud Function that processes the deletion request.', 'violation_handling': 'The calculation must be fixed. No custom grace periods are allowed. If the calculation fails, the process must fail and log an error.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-022

#### 6.1.1.2 Dependency Reason

This story describes the UI that is shown immediately after the action in US-022 (and its confirmation in US-023) is completed.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-023

#### 6.1.2.2 Dependency Reason

The re-authentication step in US-023 is the final trigger for displaying the grace period notification.

## 6.2.0.0 Technical Dependencies

- A backend mechanism (Cloud Function) to update the tenant document in Firestore with a 'status' of 'pending_deletion' and a 'deletionScheduledAt' timestamp.
- Integration with the SendGrid transactional email service (via Firebase Extension) to send the confirmation email.

## 6.3.0.0 Data Dependencies

- Requires access to the tenant's document to update its status.
- Requires the Admin's registered email address to send the notification.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The confirmation screen must load in under 500ms after the deletion request is submitted.

## 7.2.0.0 Security

- The tenant status and deletion date information must only be visible to users with the 'Admin' role within that specific tenant.
- The email notification must not contain any sensitive data beyond what is necessary to identify the account and the action taken.

## 7.3.0.0 Usability

- The language used must be simple, direct, and free of technical jargon to ensure the user fully understands the situation.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The confirmation screen and dashboard banner must render correctly on all supported web browsers (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Primarily consists of frontend UI work to display information provided by the backend.
- Backend logic is simple: update a document and trigger an email.
- Requires careful handling of date and timezone calculations to avoid ambiguity.

## 8.3.0.0 Technical Risks

- Potential for timezone-related bugs if not handled carefully (e.g., storing all timestamps in UTC).
- Email delivery issues (e.g., being marked as spam) should be mitigated by using a reputable transactional email provider and proper domain authentication (DKIM, SPF).

## 8.4.0.0 Integration Points

- Firestore: The Cloud Function will update the `/tenants/{tenantId}` document.
- SendGrid: The Cloud Function will call the SendGrid API to dispatch the notification email.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify the end-to-end flow: Admin confirms deletion -> confirmation screen appears with correct date -> email is received.
- Verify the date calculation is correct, especially around month-ends and leap years.
- Verify the persistent banner appears on all Admin dashboard pages after logging out and back in.
- Test the UI on different screen sizes to ensure responsiveness.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user account that can be safely marked for deletion.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and testing of the Cloud Function and Firestore rules.
- Jest for backend unit tests.
- Flutter's `integration_test` for E2E testing of the web dashboard flow.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for date calculation logic and passing with >80% coverage
- Integration testing between the frontend, Cloud Function, and Firestore completed successfully
- User interface reviewed and approved by UX/Product Owner
- Accessibility requirements validated using automated tools and manual checks
- Documentation for the tenant offboarding process is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is part of the 'Tenant Offboarding' epic and should be planned alongside US-022, US-023, and US-025 to deliver the complete feature.
- The UI/UX design for the confirmation screen and dashboard banner must be finalized before development begins.

## 11.4.0.0 Release Impact

This is a critical component of the tenant lifecycle management feature. The ability for users to self-service delete their accounts cannot be released without this safety notification.

