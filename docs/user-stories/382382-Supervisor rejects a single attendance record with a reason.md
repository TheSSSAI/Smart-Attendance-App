# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-040 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor rejects a single attendance record with... |
| As A User Story | As a Supervisor, I want to reject a subordinate's ... |
| User Persona | Supervisor |
| Business Value | Ensures data accuracy in attendance records, provi... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-040-01

### 3.1.2 Scenario

Happy Path: Supervisor successfully rejects a record with a valid reason

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A Supervisor is viewing a 'pending' attendance record for one of their direct subordinates

### 3.1.5 When

The Supervisor selects the 'Reject' action for that record, enters a reason that meets the validation requirements (e.g., 'Checked in from incorrect location'), and confirms the action

### 3.1.6 Then

The attendance record's status in Firestore is updated from 'pending' to 'rejected'.

### 3.1.7 Validation Notes

Verify the document in the `/tenants/{tenantId}/attendance/{recordId}` collection has its `status` field set to 'rejected' and the `rejectionReason` field contains the text entered by the supervisor.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-040-02

### 3.2.2 Scenario

UI updates after successful rejection

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

A Supervisor has successfully rejected an attendance record

### 3.2.5 When

The data update is confirmed by the backend

### 3.2.6 Then

A success notification (e.g., toast/snackbar) is displayed to the Supervisor.

### 3.2.7 And

The rejected record is removed from the list of 'pending' items in the Supervisor's dashboard.

### 3.2.8 Validation Notes

Observe the UI behavior in the mobile app. The list of pending records should refresh and no longer contain the rejected item.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-040-03

### 3.3.2 Scenario

Error Condition: Attempting to reject without providing a reason

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

A Supervisor has initiated the rejection process for an attendance record

### 3.3.5 When

The Supervisor attempts to confirm the rejection without entering any text in the reason field

### 3.3.6 Then

The system displays a validation error message like 'A reason is required for rejection'.

### 3.3.7 And

The rejection action is blocked, and the record's status remains 'pending'.

### 3.3.8 Validation Notes

The 'Confirm' button in the rejection dialog should be disabled, or clicking it should show an error message without making a backend call.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-040-04

### 3.4.2 Scenario

Canceling the rejection process

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

A Supervisor has opened the rejection dialog for an attendance record

### 3.4.5 When

The Supervisor selects the 'Cancel' action

### 3.4.6 Then

The dialog is dismissed, and no changes are made to the attendance record.

### 3.4.7 And

The record's status remains 'pending'.

### 3.4.8 Validation Notes

Verify that after closing the dialog, the record is still visible in the pending list and its data in Firestore is unchanged.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-040-05

### 3.5.2 Scenario

Audit log is created for the rejection action

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

A Supervisor successfully rejects an attendance record

### 3.5.5 When

The record's status is updated to 'rejected'

### 3.5.6 Then

A new, immutable document is created in the `auditLog` collection.

### 3.5.7 And

The audit log entry contains the `actorUserId` (the Supervisor's ID), `actionType` ('ATTENDANCE_REJECT'), `targetEntityId` (the attendance record ID), and `details` including the rejection reason.

### 3.5.8 Validation Notes

Check the `/tenants/{tenantId}/auditLog` collection for a new entry corresponding to this action. This may be implemented via a Cloud Function trigger.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-040-06

### 3.6.2 Scenario

Error Condition: Attempting to reject a record that is no longer pending

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

A Supervisor is viewing a pending record, but its status is changed by another process (e.g., an Admin approves it)

### 3.6.5 When

The Supervisor attempts to submit a rejection for that record

### 3.6.6 Then

The system prevents the update and displays an informative error message (e.g., 'This record has already been processed').

### 3.6.7 And

The Supervisor's view is refreshed to show the record's current status.

### 3.6.8 Validation Notes

This can be tested by manually changing the record's status in the database while the rejection dialog is open in the app. The subsequent rejection attempt should fail gracefully.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Reject' button or action associated with each pending attendance record in the Supervisor's dashboard.
- A modal dialog or dedicated screen for entering the rejection reason.
- A multi-line text input field for the reason.
- A 'Confirm Rejection' button (or similar).
- A 'Cancel' button or action to close the dialog.
- Validation message display area for the reason field.

## 4.2.0 User Interactions

- Tapping 'Reject' opens the reason dialog.
- The 'Confirm Rejection' button is disabled until a reason of minimum required length is entered.
- Tapping 'Cancel' dismisses the dialog with no action.
- Tapping 'Confirm Rejection' with a valid reason shows a loading indicator, then a success message, and closes the dialog.

## 4.3.0 Display Requirements

- The prompt for the reason must be clear (e.g., 'Please provide a reason for rejection').
- Success and error messages must be user-friendly and informative.

## 4.4.0 Accessibility Needs

- The rejection dialog must be fully accessible via screen readers.
- All buttons and the text input field must have proper labels (e.g., `contentDescription`, `aria-label`).
- Color contrast for text and buttons must meet WCAG 2.1 AA standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-REJECT-01

### 5.1.2 Rule Description

A reason is mandatory when rejecting an attendance record.

### 5.1.3 Enforcement Point

Client-side validation and server-side (Firestore Security Rules).

### 5.1.4 Violation Handling

The rejection action is blocked, and an error message is displayed to the user.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-REJECT-02

### 5.2.2 Rule Description

The rejection reason must be at least 10 characters long to ensure it is meaningful.

### 5.2.3 Enforcement Point

Client-side validation.

### 5.2.4 Violation Handling

The rejection action is blocked, and a validation error message is displayed.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-037', 'dependency_reason': 'This story requires the Supervisor to have a view of pending attendance records, which is provided by US-037.'}

## 6.2.0 Technical Dependencies

- Firestore database for storing attendance records.
- Firestore Security Rules for authorization.
- Potentially a Firebase Cloud Function for creating the audit log entry.

## 6.3.0 Data Dependencies

- The `attendance` collection schema must include a `status` field (String) and a `rejectionReason` field (String, nullable).
- The `auditLog` collection schema must be defined.

## 6.4.0 External Dependencies

*No items available*

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The database update operation for rejection should complete in under 500ms on a stable 4G connection.

## 7.2.0 Security

- Firestore Security Rules must enforce that only the designated supervisor for the subordinate (or an Admin) can update the attendance record's status to 'rejected'.
- Any user input (the reason) must be sanitized to prevent injection attacks if it is ever rendered in a web view.

## 7.3.0 Usability

- The process of rejecting a record should be intuitive and require minimal steps.
- Feedback to the user (loading, success, error) must be immediate and clear.

## 7.4.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards.

## 7.5.0 Compatibility

- Functionality must be consistent on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Low

## 8.2.0 Complexity Factors

- Requires UI development for a modal dialog.
- Involves a simple state management flow.
- Requires a single Firestore document update.
- Requires updating Firestore Security Rules.
- May require a simple Cloud Function for auditing.

## 8.3.0 Technical Risks

- Potential for race conditions if the record is modified by another user simultaneously. This should be handled gracefully (see AC-040-06).

## 8.4.0 Integration Points

- Firestore `attendance` collection (write).
- Firestore `auditLog` collection (write).

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Widget
- Integration
- Security Rule

## 9.2.0 Test Scenarios

- Test successful rejection with a valid reason.
- Test rejection attempt with an empty reason.
- Test rejection attempt with a reason that is too short.
- Test the cancellation of the rejection flow.
- Test that an unauthorized user (e.g., another supervisor) cannot reject the record.
- Test the creation of the audit log entry upon successful rejection.

## 9.3.0 Test Data Needs

- A test Supervisor user.
- A test Subordinate user assigned to the Supervisor.
- A 'pending' attendance record created by the Subordinate.

## 9.4.0 Testing Tools

- Flutter Test Framework (`flutter_test`) for unit/widget tests.
- Firebase Local Emulator Suite for integration and security rule testing.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented for the rejection dialog and its logic, achieving >80% coverage
- Integration testing with the Firebase Emulator Suite completed successfully
- Firestore Security Rules for this action are written and tested
- User interface reviewed and approved by the Product Owner/UX designer
- An audit log entry is correctly generated upon rejection
- Story deployed and verified in the staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

2

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This is a core feature of the approval workflow. It should be prioritized alongside other approval actions like 'Approve'.
- Depends on US-037 being completed first.

## 11.4.0 Release Impact

- Completes a critical part of the attendance management loop. The approval workflow is incomplete without the ability to reject records.

