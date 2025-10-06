# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-045 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate requests a correction to an attendance... |
| As A User Story | As a Subordinate, I want to submit a request to co... |
| User Persona | Subordinate - The primary end-user who marks their... |
| Business Value | Ensures data integrity by providing a formal, audi... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Submitting a valid correction request

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a logged-in Subordinate viewing my attendance history, and I have an attendance record with a status of 'approved' or 'rejected'

### 3.1.5 When

I enter a valid new time, provide a justification of at least 20 characters, and tap 'Submit Request'

### 3.1.6 Then

The attendance record's status in Firestore is updated to 'correction_pending'.

### 3.1.7 And

I see a success confirmation message, and I am returned to my attendance history screen where the record's new status is visible.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Submitting a request with no justification

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am on the attendance correction form

### 3.2.5 When

I enter a new check-in time but leave the justification field blank and tap 'Submit Request'

### 3.2.6 Then

The submission is blocked, and an error message 'Justification is required and must be at least 20 characters.' is displayed.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Error Condition: Submitting a request with invalid time logic

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am on the attendance correction form

### 3.3.5 When

I enter a new check-out time that is earlier than the check-in time and tap 'Submit Request'

### 3.3.6 Then

The submission is blocked, and an error message 'Check-out time must be after check-in time.' is displayed.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Edge Case: Attempting to correct a record that is already pending correction

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

I am viewing my attendance history

### 3.4.5 When

I locate a record that already has a status of 'correction_pending'

### 3.4.6 Then

The 'Request Correction' option for that specific record is disabled or hidden.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Alternative Flow: Cancelling a correction request

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

I am on the attendance correction form and have made some changes

### 3.5.5 When

I tap the 'Cancel' or 'Back' button

### 3.5.6 Then

I am returned to the attendance history screen, and no changes are saved or submitted.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Edge Case: Submitting a correction request while offline

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

I am on the attendance correction form and my device is offline

### 3.6.5 When

I submit a valid correction request

### 3.6.6 Then

The request is queued locally, and I see a confirmation that it will be sent when connectivity is restored.

### 3.6.7 And

When my device comes back online, the request is automatically synced to the server.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Request Correction' button/menu item on each eligible attendance record in the history list.
- A dedicated screen or modal for the correction form.
- Standard time-picker controls for check-in and check-out time fields.
- A multi-line text input for the justification.
- A 'Submit Request' button, which is disabled until the form is valid.
- A 'Cancel' button or back navigation.
- Success and error notification messages (e.g., toasts or snackbars).

## 4.2.0 User Interactions

- Tapping 'Request Correction' opens the form.
- The form fields are pre-populated with existing data.
- The system provides real-time validation feedback for invalid time logic or missing justification.
- Upon successful submission, the user is navigated back to the previous screen.

## 4.3.0 Display Requirements

- The attendance history list must clearly display the 'correction_pending' status for relevant records.
- The correction form must clearly label original vs. new times.

## 4.4.0 Accessibility Needs

- All form fields, buttons, and error messages must have proper labels for screen readers (WCAG 2.1 AA).
- Sufficient color contrast must be used for text and UI elements.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-COR-001

### 5.1.2 Rule Description

A justification of at least 20 characters is mandatory for all attendance correction requests.

### 5.1.3 Enforcement Point

Client-side form validation and server-side via Firestore Security Rules.

### 5.1.4 Violation Handling

Prevent form submission and display a user-friendly error message.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-COR-002

### 5.2.2 Rule Description

A correction can only be requested for an attendance record with a terminal status (e.g., 'approved', 'rejected'), not for one that is 'pending' or 'correction_pending'.

### 5.2.3 Enforcement Point

Client-side UI (disabling the button) and server-side via Firestore Security Rules.

### 5.2.4 Violation Handling

The action is not available to the user. Any direct API attempt is rejected by security rules.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-AUD-001

### 5.3.2 Rule Description

Every submitted correction request must generate an immutable record in the `auditLog` collection.

### 5.3.3 Enforcement Point

Server-side, preferably via a Cloud Function triggered on the attendance record update.

### 5.3.4 Violation Handling

The transaction should fail if the audit log cannot be written. Log an error for administrative review.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

Requires the existence of attendance records created by the check-in functionality.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-039

#### 6.1.2.2 Dependency Reason

Requires the supervisor approval flow to be in place so that records can have an 'approved' status, making them eligible for correction.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-051

#### 6.1.3.2 Dependency Reason

Requires the `auditLog` collection schema and write mechanism to be defined to log the correction request action.

## 6.2.0.0 Technical Dependencies

- Firestore database with defined `attendance` and `users` collections.
- Firebase Authentication to identify the user and their `supervisorId`.
- Firestore Security Rules engine for enforcement.

## 6.3.0.0 Data Dependencies

- The user's document must have a valid `supervisorId` to route the request.
- The attendance record to be corrected must exist and belong to the authenticated user.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The correction form must load in under 1 second.
- The submission feedback (success/failure) must be displayed to the user in under 2 seconds on a stable connection.

## 7.2.0.0 Security

- A user must only be able to request corrections for their own attendance records. This must be strictly enforced by Firestore Security Rules.
- The user cannot directly modify the core attendance data; they can only submit a request that changes the record's status and adds proposed data.
- All data must be transmitted over HTTPS.

## 7.3.0.0 Usability

- The process of finding a record and submitting a correction should be intuitive and require minimal steps.
- Error messages must be clear and actionable.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires careful design of Firestore Security Rules to prevent unauthorized direct data modification.
- Involves both client-side state management and server-side logic (via security rules or a Cloud Function for auditing).
- Needs to handle offline submission and synchronization gracefully.

## 8.3.0.0 Technical Risks

- Incorrectly configured security rules could either block legitimate requests or allow users to bypass the approval workflow.
- Failure to correctly handle offline sync could lead to lost correction requests.

## 8.4.0.0 Integration Points

- Firestore `attendance` collection: The primary integration point for reading and updating the record.
- Firestore `auditLog` collection: A new document is created here upon submission.
- Supervisor's Dashboard (US-046): The data structure used for the pending correction must be consumable by the supervisor's review interface.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify all acceptance criteria, including happy path, error conditions, and edge cases.
- Test offline submission: submit a request offline, turn on connectivity, and verify the record is updated on the server.
- Security rule testing: Use the Firebase Emulator Suite to write tests that attempt to violate security rules (e.g., user A tries to correct user B's record) and confirm they fail as expected.

## 9.3.0.0 Test Data Needs

- Test accounts for a Subordinate and their assigned Supervisor.
- A set of pre-existing attendance records with 'approved' and 'rejected' statuses.

## 9.4.0.0 Testing Tools

- Flutter Test framework (`flutter_test`, `integration_test`).
- Firebase Local Emulator Suite for backend and security rules testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new code
- Integration testing for Firestore writes and security rules completed successfully
- User interface reviewed and approved for both iOS and Android
- Security requirements validated via emulator tests
- Documentation for the correction data structure updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a prerequisite for the supervisor-side correction approval stories (US-046, US-047, US-048). It should be planned in the same or an earlier sprint to enable the full workflow.

## 11.4.0.0 Release Impact

This is a core feature for user self-service and data accuracy. It is critical for the initial release of the attendance management module.

