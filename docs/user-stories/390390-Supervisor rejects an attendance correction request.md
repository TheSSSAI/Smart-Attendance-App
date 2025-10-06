# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-048 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor rejects an attendance correction reques... |
| As A User Story | As a Supervisor, I want to reject an invalid atten... |
| User Persona | Supervisor |
| Business Value | Ensures the integrity and accuracy of attendance d... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Supervisor successfully rejects a correction request with a reason

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a Supervisor logged in and viewing an attendance record with a status of 'correction_pending' from my direct subordinate

### 3.1.5 When

I tap the 'Reject' button, enter a valid reason for rejection in the provided input field, and confirm the action

### 3.1.6 Then

The attendance record's status reverts to its state before the correction was requested (e.g., 'approved' or 'pending')

### 3.1.7 And

An entry is created in the immutable audit log detailing the rejection action, including the actor (my user ID), the target record, the action type ('CORRECTION_REJECTED'), and the reason provided

### 3.1.8 Validation Notes

Verify the record's status in Firestore has reverted. Check the subordinate's device for the push notification. Query the auditLog collection for the new entry.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Supervisor attempts to reject a request without providing a reason

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am a Supervisor viewing the rejection confirmation dialog for a correction request

### 3.2.5 When

I attempt to confirm the rejection without entering any text in the mandatory reason field

### 3.2.6 Then

The confirmation button should be disabled or an error message should be displayed indicating that a reason is required

### 3.2.7 And

The rejection action is not processed, and the record remains in the 'correction_pending' state

### 3.2.8 Validation Notes

Test the UI to ensure the confirmation button is disabled when the reason field is empty. Verify no changes are made to the record in Firestore.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Alternative Flow: Supervisor cancels the rejection action

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

I am a Supervisor viewing the rejection confirmation dialog for a correction request

### 3.3.5 When

I tap the 'Cancel' button or dismiss the dialog

### 3.3.6 Then

The dialog closes, and no changes are made to the attendance record

### 3.3.7 And

The record remains in the 'correction_pending' state in my approval queue

### 3.3.8 Validation Notes

Confirm that after canceling, the record is still visible in the pending list and its status in Firestore is unchanged.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Error Condition: Network failure during rejection submission

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am a Supervisor and I have confirmed the rejection of a correction request

### 3.4.5 When

The application fails to communicate with the server due to a network error

### 3.4.6 Then

A user-friendly error message (e.g., 'Failed to reject request. Please check your connection and try again.') is displayed

### 3.4.7 And

The attendance record remains in the 'correction_pending' state on both the client and server

### 3.4.8 Validation Notes

Use a network proxy or device settings to simulate network failure and verify the app's response and data consistency.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A clearly labeled 'Reject' button on the correction request detail view.
- A modal/dialog that appears upon tapping 'Reject'.
- A multi-line text input field within the modal for the rejection reason, with a placeholder like 'Please provide a reason for rejection...'.
- A character counter for the reason field.
- A 'Confirm Rejection' button and a 'Cancel' button within the modal.

## 4.2.0 User Interactions

- The 'Confirm Rejection' button in the modal should be disabled until a minimum number of characters (e.g., 10) is entered in the reason field.
- Upon successful rejection, a toast or snackbar notification should appear confirming the action (e.g., 'Correction request rejected.').
- The rejected item should be removed from the list of pending items in the UI without requiring a manual refresh.

## 4.3.0 Display Requirements

- The subordinate should be able to view the rejection reason provided by the supervisor when viewing their rejected attendance record.

## 4.4.0 Accessibility Needs

- All buttons and input fields must have proper labels for screen readers (e.g., `aria-label`).
- The modal dialog must be focus-trapped, so keyboard navigation is contained within it until dismissed.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-COR-001

### 5.1.2 Rule Description

A reason is mandatory for rejecting an attendance correction request.

### 5.1.3 Enforcement Point

Client-side validation in the UI and server-side validation in the Cloud Function.

### 5.1.4 Violation Handling

The rejection request is blocked, and the user is prompted to provide a reason.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-AUD-001

### 5.2.2 Rule Description

All correction request rejections must be logged in the immutable audit log.

### 5.2.3 Enforcement Point

Server-side Cloud Function responsible for processing the rejection.

### 5.2.4 Violation Handling

If the audit log write fails, the entire transaction should be rolled back to ensure data consistency.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-045

#### 6.1.1.2 Dependency Reason

A correction request must be able to be created and submitted by a subordinate before it can be rejected.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-046

#### 6.1.2.2 Dependency Reason

The Supervisor's UI for viewing and reviewing pending correction requests is required to host the 'Reject' action.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-049

#### 6.1.3.2 Dependency Reason

The push notification system for informing subordinates of outcomes must be implemented.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-051

#### 6.1.4.2 Dependency Reason

The immutable audit log system must be in place to record the rejection action.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Function for backend processing.
- Firebase Cloud Messaging (FCM) for push notifications.
- Firestore database with a defined schema for attendance records that includes fields for status, previous status, and rejection reasons.

## 6.3.0.0 Data Dependencies

- An existing attendance record in a 'correction_pending' state.
- The attendance record must store its previous status (e.g., in a `statusBeforeCorrection` field) to enable the revert functionality.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The server-side processing of the rejection (database update, audit log entry, notification trigger) should complete in under 500ms (p95).

## 7.2.0.0 Security

- The Cloud Function must validate that the authenticated user making the request is the designated supervisor for the subordinate who owns the attendance record.
- Firestore Security Rules must prevent any user other than the assigned supervisor or an Admin from modifying the record's status.

## 7.3.0.0 Usability

- The process of rejecting a request should be intuitive and require minimal steps.
- Feedback to the user (both Supervisor and Subordinate) must be clear and immediate.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a transactional, server-side Cloud Function to ensure atomicity of the database update, audit log entry, and notification trigger.
- The logic to revert to a 'previous state' depends on that state being correctly stored when the correction was initiated (dependency on US-045).
- Integration with the push notification service (FCM) adds a layer of complexity.

## 8.3.0.0 Technical Risks

- Potential for race conditions if the record is modified by another process (e.g., an Admin edit) simultaneously. This should be mitigated by using Firestore transactions.
- Failure in the notification service should not cause the entire rejection to fail. The logic should be decoupled.

## 8.4.0.0 Integration Points

- Firestore: Reading and writing to the 'attendance' collection.
- Firestore: Writing to the 'auditLog' collection.
- Firebase Cloud Messaging: Triggering a push notification to a specific user device.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify successful rejection and data reversion.
- Verify rejection is blocked without a reason.
- Verify the subordinate receives a push notification.
- Verify the audit log entry is correct.
- Verify a non-supervisor user cannot reject the request (API security test).
- Verify the UI updates correctly after rejection.

## 9.3.0.0 Test Data Needs

- Test accounts for a Supervisor and a direct Subordinate.
- An attendance record created by the Subordinate with status 'correction_pending'.
- The record should have a `statusBeforeCorrection` field set to 'approved' to test the revert logic.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration testing of Flutter app and Cloud Functions.
- Jest for Cloud Function unit tests.
- Flutter Driver or `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing.
- Code for both the Flutter client and the Cloud Function has been peer-reviewed and merged.
- Unit tests for the Cloud Function logic achieve >80% coverage.
- Widget tests for the rejection modal UI are implemented and passing.
- Integration tests confirming the end-to-end flow (UI -> Function -> Firestore -> Notification) are passing in the emulator environment.
- Security rules have been written and tested to protect the action.
- The push notification content and delivery have been verified.
- The audit log entry is created with the correct format and data.
- Story deployed and successfully verified in the staging environment by a QA engineer.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story should be planned in the same sprint as US-047 (Approve Correction) as they are two sides of the same workflow and can share backend logic.
- Confirm that the prerequisite stories, especially the data model changes in US-045, are completed before starting this story.

## 11.4.0.0 Release Impact

This is a core feature of the supervisor approval workflow. The workflow is incomplete without the ability to both approve and reject requests.

