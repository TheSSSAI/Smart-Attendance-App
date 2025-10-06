# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-025 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin cancels a pending tenant deletion |
| As A User Story | As an Admin of an organization, I want to cancel a... |
| User Persona | Admin: The primary administrator of an organizatio... |
| Business Value | Provides a critical safety net to prevent accident... |
| Functional Area | Tenant Management |
| Story Theme | Tenant Offboarding Lifecycle |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully cancels a pending deletion within the grace period

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an authenticated Admin for a tenant whose status is 'pending_deletion' and the current date is within the 30-day grace period

### 3.1.5 When

I navigate to the 'Tenant Settings' page in the web dashboard, click the 'Cancel Scheduled Deletion' button, and confirm the action in the subsequent modal

### 3.1.6 Then

The system updates the tenant's status in Firestore from 'pending_deletion' to 'active'.

### 3.1.7 Validation Notes

Verify in Firestore that the tenant document's 'status' field is 'active' and any deletion-related timestamps are cleared. Confirm the UI returns to the standard active state.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

UI reflects the restored active state after cancellation

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

An Admin has successfully cancelled a pending tenant deletion

### 3.2.5 When

The 'Tenant Settings' page reloads or is refreshed

### 3.2.6 Then

The warning banner about the pending deletion is no longer visible.

### 3.2.7 Validation Notes

The UI should display a success toast message like 'The scheduled deletion has been cancelled.' The 'Request Deletion' functionality should be available again.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Cancellation action is recorded in the audit log

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

An Admin has successfully cancelled a pending tenant deletion

### 3.3.5 When

The cancellation action is processed by the system

### 3.3.6 Then

A new entry is created in the tenant's 'auditLog' collection.

### 3.3.7 Validation Notes

Query the 'auditLog' collection for the tenant and verify a new document exists with 'actionType': 'tenant.deletion.cancelled', the correct 'actorUserId', and 'targetEntityId'.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User is required to confirm the cancellation

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

I am an authenticated Admin on the 'Tenant Settings' page for a tenant pending deletion

### 3.4.5 When

I click the 'Cancel Scheduled Deletion' button

### 3.4.6 Then

A confirmation modal appears with the title 'Confirm Cancellation' and text 'Are you sure you want to cancel the scheduled deletion of your organization's account? This will restore full access for all users.'

### 3.4.7 Validation Notes

The modal must contain 'Confirm' and 'Cancel' (or similar) buttons. The action should only proceed upon clicking 'Confirm'.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Attempt to cancel deletion outside the grace period

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A tenant's 30-day grace period for deletion has expired

### 3.5.5 When

An Admin attempts to trigger the cancellation action (e.g., via a stale UI or direct API call)

### 3.5.6 Then

The system must reject the request with an error message like 'The grace period has expired. This action can no longer be performed.'

### 3.5.7 Validation Notes

This should be enforced server-side in the Cloud Function. The UI for cancellation should ideally not be rendered after the grace period expires.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Non-Admin user attempts to access cancellation functionality

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

I am an authenticated user with a 'Supervisor' or 'Subordinate' role

### 3.6.5 When

I attempt to navigate to the 'Tenant Settings' page or trigger the cancellation action

### 3.6.6 Then

I am denied access, and the cancellation UI is not visible to me.

### 3.6.7 Validation Notes

Verify using Firestore Security Rules and server-side checks in the Cloud Function that only users with the 'Admin' role can perform this action.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A prominent, non-dismissible warning banner on the Admin's 'Tenant Settings' page when deletion is pending.
- A 'Cancel Scheduled Deletion' button within the warning banner.
- A confirmation modal with clear explanatory text and action buttons ('Confirm', 'Cancel').
- A success toast notification upon successful cancellation.

## 4.2.0 User Interactions

- Clicking the 'Cancel Scheduled Deletion' button must trigger the confirmation modal.
- Confirming the action in the modal initiates the backend process.
- Cancelling in the modal closes it with no state change.

## 4.3.0 Display Requirements

- The warning banner must display the exact date and time when the permanent deletion will occur, formatted for the Admin's local timezone.

## 4.4.0 Accessibility Needs

- The warning banner must have an appropriate ARIA role (e.g., 'alert').
- All buttons and interactive elements in the flow must be keyboard-navigable and have accessible labels for screen readers.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'A pending tenant deletion can only be cancelled within the 30-day grace period following the initial request.', 'enforcement_point': 'Server-side (Cloud Function) before processing the cancellation request.', 'violation_handling': 'The request is rejected, and an error is returned to the client.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-022

#### 6.1.1.2 Dependency Reason

This story depends on the functionality to initiate a tenant deletion, which sets the 'pending_deletion' state.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-024

#### 6.1.2.2 Dependency Reason

This story relies on the concept of a 30-day grace period being established and communicated to the user.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user role verification.
- Firebase Firestore for storing and updating tenant status.
- Firebase Cloud Functions for secure, server-side execution of the cancellation logic.

## 6.3.0.0 Data Dependencies

- The tenant document in Firestore must have a 'status' field and a 'deletionScheduledAt' timestamp field.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The client-side UI should update within 1 second of receiving a successful response from the server.
- The backend Cloud Function execution time should be less than 500ms.

## 7.2.0.0 Security

- The action must be protected by Firestore Security Rules to ensure only an Admin of the specific tenant can modify its status.
- The callable Cloud Function must validate the caller's JWT to confirm their identity and role ('Admin' custom claim) before executing.

## 7.3.0.0 Usability

- The cancellation process must be simple and provide clear, unambiguous feedback to the user at each step.

## 7.4.0.0 Accessibility

- All UI components related to this feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must be fully functional on the latest stable versions of Chrome, Firefox, Safari, and Edge for the web dashboard.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both frontend (Flutter Web) and backend (Cloud Function) development.
- Involves a state change on a critical data entity (the tenant document).
- Requires careful implementation of security rules and server-side validation.
- Interaction with a scheduled process (the deletion function) adds complexity; the deletion function must be designed to check the tenant's status before acting.

## 8.3.0.0 Technical Risks

- Potential for a race condition if the deletion job runs at the exact moment a cancellation is requested. The deletion job must re-verify the tenant status in a transaction before deleting.

## 8.4.0.0 Integration Points

- The frontend UI must call a specific callable Cloud Function.
- The Cloud Function must perform a transactional write to Firestore, updating the tenant document and creating an audit log entry.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify successful cancellation within the grace period.
- Verify failed cancellation attempt after the grace period has expired.
- Verify non-Admin users cannot see or access the feature.
- Verify the audit log is correctly written upon cancellation.
- Verify the UI state correctly reflects the tenant's status before and after cancellation.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user.
- Ability to set the tenant's status to 'pending_deletion' and manipulate the 'deletionScheduledAt' timestamp for testing grace period logic.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and integration testing.
- Jest for Cloud Function unit tests.
- flutter_test for widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for the Cloud Function and UI components, with >80% coverage
- Integration testing completed successfully using the Firebase Emulator Suite
- End-to-end test scenario automated and passing
- User interface reviewed and approved by UX/Product Owner
- Security rules and server-side validation logic have been peer-reviewed
- Documentation for the feature (if any) has been updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is blocked by US-022 and US-024.
- Requires a developer with both frontend (Flutter) and backend (TypeScript Cloud Functions) skills, or collaboration between two specialists.

## 11.4.0.0 Release Impact

This is a critical feature for the tenant offboarding epic. The ability to initiate deletion should not be released without this corresponding cancellation feature to prevent irreversible mistakes.

