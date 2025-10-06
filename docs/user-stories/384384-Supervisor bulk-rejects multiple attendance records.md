# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-042 |
| Elaboration Date | 2025-01-20 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor bulk-rejects multiple attendance record... |
| As A User Story | As a Supervisor, I want to select multiple pending... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Improves managerial efficiency by reducing the tim... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Supervisor selects multiple records, provides a reason, and successfully rejects them

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Supervisor is viewing their dashboard with a list of 'pending' attendance records from their subordinates

### 3.1.5 When

the Supervisor selects two or more records using checkboxes, clicks the 'Reject Selected' button, enters a valid reason (e.g., 'Incorrect project selected') into the confirmation modal, and confirms the action

### 3.1.6 Then

the system atomically updates the status of all selected records to 'rejected' in the database, the provided reason is stored in the 'rejectionReason' field of each updated record, the rejected records are removed from the 'pending' list in the UI, and a success notification (e.g., '3 records rejected') is displayed.

### 3.1.7 Validation Notes

Verify in Firestore that all selected records have status='rejected' and the correct 'rejectionReason'. The UI must update in real-time.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Supervisor attempts to reject records without providing a reason

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

a Supervisor has selected multiple pending records and opened the rejection confirmation modal

### 3.2.5 When

the Supervisor attempts to confirm the rejection without entering any text in the mandatory reason field

### 3.2.6 Then

the system prevents the action, the confirmation button remains disabled or shows a validation error (e.g., 'A reason is required'), and no records are updated in the database.

### 3.2.7 Validation Notes

The confirmation button in the modal should be disabled until the reason field contains text. Test form validation.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Alternative Flow: Supervisor cancels the bulk rejection action

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

a Supervisor has selected multiple pending records and opened the rejection confirmation modal

### 3.3.5 When

the Supervisor clicks the 'Cancel' button or closes the modal without confirming

### 3.3.6 Then

the modal closes, the record selections are preserved in the list view, and the status of the selected records remains 'pending'.

### 3.3.7 Validation Notes

Verify that no database changes are made and the UI state for selected items is maintained.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

UI Interaction: Bulk action buttons appear upon selection

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

a Supervisor is viewing the list of pending attendance records

### 3.4.5 When

the Supervisor selects the first record via its checkbox

### 3.4.6 Then

a set of bulk action buttons, including 'Approve Selected' and 'Reject Selected', becomes visible and enabled, and a counter indicating the number of selected items (e.g., '1 selected') is displayed.

### 3.4.7 Validation Notes

The bulk action buttons should be hidden or disabled by default and only appear/enable when one or more items are selected.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Edge Case: One of the selected records is actioned by another process

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

a Supervisor has selected three pending records

### 3.5.5 When

before the Supervisor confirms the rejection, an Admin approves one of the three selected records, and the Supervisor then proceeds to confirm the bulk rejection

### 3.5.6 Then

the system processes the rejection only for the remaining two 'pending' records, the already 'approved' record is ignored, and a notification is displayed to the Supervisor indicating a partial success (e.g., '2 of 3 records rejected. 1 was already actioned.').

### 3.5.7 Validation Notes

This requires server-side validation within the Cloud Function to check the current status of each record before attempting to update it.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Checkboxes next to each item in the pending attendance list.
- A 'Select All' checkbox in the list header.
- A contextual action bar or footer that appears upon selection.
- A 'Reject Selected' button within the contextual action bar.
- A counter displaying the number of selected items (e.g., '3 items selected').
- A modal dialog with a multi-line text area for the 'Rejection Reason', a 'Confirm' button, and a 'Cancel' button.
- Loading indicator/spinner during the batch update process.
- Toast/Snackbar notifications for success and error messages.

## 4.2.0 User Interactions

- Tapping a checkbox selects/deselects a record.
- The 'Reject Selected' button is disabled until at least one record is selected.
- The 'Confirm' button in the reason modal is disabled until a reason is entered.
- Closing the modal (e.g., tapping outside or pressing 'Cancel') aborts the action without data changes.

## 4.3.0 Display Requirements

- The list of pending records must be clear and easy to scan.
- The rejection reason modal must clearly state that the reason will be applied to all selected records.

## 4.4.0 Accessibility Needs

- All interactive elements (checkboxes, buttons) must have proper touch targets and screen reader labels.
- The selection state of each record must be clearly conveyed to assistive technologies.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A reason is mandatory for all rejection actions, single or bulk.

### 5.1.3 Enforcement Point

Client-side form validation and server-side in the Cloud Function.

### 5.1.4 Violation Handling

The action is blocked, and a user-facing error message is displayed.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

A Supervisor can only reject attendance records of their direct subordinates.

### 5.2.3 Enforcement Point

Server-side via Firestore Security Rules and/or Cloud Function logic.

### 5.2.4 Violation Handling

The request is denied with a 'permission-denied' error. The UI should show a generic failure message.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

Only records with a status of 'pending' or 'correction_pending' can be rejected.

### 5.3.3 Enforcement Point

Server-side in the Cloud Function before performing the update.

### 5.3.4 Violation Handling

The specific record is skipped from the batch operation. The user is notified of the partial success as per AC-005.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-037

#### 6.1.1.2 Dependency Reason

This story requires the UI and data fetching logic for a Supervisor to view the list of pending attendance records, which is the foundation for this feature.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-040

#### 6.1.2.2 Dependency Reason

The core logic for updating a single record's status to 'rejected' and storing a reason is defined in this story. This story extends that logic to a batch operation.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user identity.
- Firestore database for storing attendance records.
- A callable Firebase Cloud Function is recommended for secure, atomic batch processing.

## 6.3.0.0 Data Dependencies

- Requires access to the `attendance` collection.
- The `attendance` documents must have `status`, `supervisorId`, and `rejectionReason` fields.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The batch update of up to 50 records should complete within 3 seconds on a stable 4G connection.
- UI interactions, such as selecting records, should provide immediate feedback (<200ms).

## 7.2.0.0 Security

- The bulk rejection must be performed via a secure server-side mechanism (e.g., Cloud Function) that validates the Supervisor's authority over every single record in the batch before execution.
- Firestore Security Rules must prevent a user from directly manipulating the status of records that do not belong to their subordinates.

## 7.3.0.0 Usability

- The process of selecting and rejecting multiple items should be intuitive and require minimal steps.
- Feedback to the user (loading, success, failure) must be clear and immediate.

## 7.4.0.0 Accessibility

- The application must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- Functionality must be consistent across supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Implementing the client-side state management for multi-select functionality.
- Creating a robust, secure, and atomic server-side batch update mechanism using a Cloud Function and Firestore WriteBatch.
- Handling partial success/failure scenarios gracefully (e.g., one record was already actioned).
- Designing and implementing the contextual UI for bulk actions.

## 8.3.0.0 Technical Risks

- Risk of partial failure if not implemented as an atomic transaction, leading to data inconsistency. A Firestore WriteBatch mitigates this.
- Potential for race conditions if multiple users (e.g., Supervisor and Admin) act on the same record simultaneously. The Cloud Function must handle this by checking the record's state within the transaction.

## 8.4.0.0 Integration Points

- The client UI must call a backend endpoint (callable Cloud Function).
- The Cloud Function will interact with the Firestore `attendance` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify successful rejection of 2, 10, and 50 records.
- Test rejection attempt with an empty reason.
- Test cancellation of the rejection flow.
- Test the flow where one of the selected records is already approved/rejected.
- Verify that a Supervisor cannot reject records of another Supervisor's team (security test).

## 9.3.0.0 Test Data Needs

- A test Supervisor account with multiple subordinate users.
- A set of at least 20 'pending' attendance records under the test Supervisor.
- At least one 'approved' record to test the edge case scenario.

## 9.4.0.0 Testing Tools

- Flutter Test framework for unit and widget tests.
- Firebase Local Emulator Suite for integration testing of the Cloud Function and Firestore rules.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- Integration testing with the Firebase Emulator completed successfully
- User interface reviewed and approved by the Product Owner/UX designer
- Performance requirements for the batch update are verified
- Security requirements validated, including Firestore rules and Cloud Function authorization
- Documentation for the Cloud Function is created
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story provides significant efficiency gains for Supervisors and should be prioritized early in the development of the approval workflow.
- Ensure prerequisite stories US-037 and US-040 are completed in a prior or the same sprint.

## 11.4.0.0 Release Impact

- This is a key feature for the Supervisor role and a major component of the attendance approval module.

