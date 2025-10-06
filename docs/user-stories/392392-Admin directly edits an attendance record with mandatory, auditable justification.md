# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-050 |
| Elaboration Date | 2025-01-20 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin directly edits an attendance record with man... |
| As A User Story | As an Admin, I want to directly edit any employee'... |
| User Persona | Admin: A user with full access and control over th... |
| Business Value | Ensures data accuracy for reporting and record-kee... |
| Functional Area | Administration |
| Story Theme | Attendance Management & Auditing |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Admin successfully edits an attendance record

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin is logged into the web dashboard and is viewing an attendance report containing a subordinate's record

### 3.1.5 When

the Admin clicks 'Edit' on the record, modifies the check-out time, provides a valid justification (20+ characters), and clicks 'Save'

### 3.1.6 Then

the system updates the attendance record in Firestore with the new check-out time and adds a 'manually-corrected' flag to the record's 'flags' array

### 3.1.7 And

the UI refreshes to show the updated attendance data, and a success notification is displayed.

### 3.1.8 Validation Notes

Verify the attendance record in Firestore has the new timestamp and flag. Verify the new document exists in the auditLog collection with all required fields.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Admin attempts to save an edit without providing a justification

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

an Admin has opened the edit attendance modal and made a change

### 3.2.5 When

the Admin attempts to save the changes with the justification field left empty

### 3.2.6 Then

the save operation is prevented

### 3.2.7 And

a clear error message is displayed in the UI indicating that justification is mandatory.

### 3.2.8 Validation Notes

Check that the 'Save' button is disabled or that clicking it shows an error and does not trigger a backend call. No changes should be written to Firestore.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Error Condition: Admin provides a justification that is too short

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

an Admin has opened the edit attendance modal and made a change

### 3.3.5 When

the Admin enters a justification shorter than the required 20 characters and attempts to save

### 3.3.6 Then

the save operation is prevented

### 3.3.7 And

an error message is displayed indicating the minimum character requirement for the justification.

### 3.3.8 Validation Notes

Verify the UI enforces the 20-character minimum rule (REQ-CON-001, Organizational Policies) before enabling the save button or upon a save attempt.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Error Condition: Admin enters an invalid time range

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

an Admin has opened the edit attendance modal

### 3.4.5 When

the Admin sets the check-out time to be earlier than the check-in time and attempts to save

### 3.4.6 Then

the save operation is prevented

### 3.4.7 And

an error message is displayed indicating that the check-out time must be after the check-in time.

### 3.4.8 Validation Notes

This validation should occur on the client-side before submission and be re-validated on the server-side (Cloud Function).

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Audit Log Immutability

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

an Admin has successfully performed a direct edit, creating an audit log entry

### 3.5.5 When

any user, including an Admin, attempts to modify or delete that audit log entry via the application or API

### 3.5.6 Then

the operation is denied by Firestore Security Rules.

### 3.5.7 Validation Notes

Test Firestore Security Rules to ensure that documents in the `/auditLog` collection cannot be updated or deleted.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Edge Case: Admin edits a record that is pending correction by a user

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

an attendance record has a status of 'correction_pending'

### 3.6.5 When

an Admin performs a direct edit on that record

### 3.6.6 Then

the Admin's edit overrides the pending correction, the record's data is updated, and its status is changed to 'approved' (or as set by the Admin)

### 3.6.7 And

an audit log is created for the Admin's direct edit.

### 3.6.8 Validation Notes

Verify the final state of the record reflects the Admin's changes, not the user's pending correction request.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- An 'Edit' icon/button next to each attendance record in the Admin web dashboard report view.
- A modal dialog for editing a record.
- Pre-populated, editable fields for check-in time, check-out time, and status.
- A mandatory, multi-line text area for 'Justification' with a character counter.
- 'Save Changes' and 'Cancel' buttons within the modal.

## 4.2.0 User Interactions

- Clicking 'Edit' opens the modal.
- The 'Save Changes' button is disabled until a valid justification (20+ characters) is entered.
- Upon successful save, the modal closes, the underlying report data refreshes, and a success toast/notification appears.
- Upon cancellation, the modal closes with no changes made.
- Validation errors are displayed inline within the modal, near the relevant field.

## 4.3.0 Display Requirements

- The modal must clearly display the name of the employee whose record is being edited.
- The character count for the justification field should update in real-time.

## 4.4.0 Accessibility Needs

- The modal must be fully keyboard-navigable (e.g., using Tab, Enter, Esc).
- All form fields must have associated labels for screen readers.
- Focus should be trapped within the modal when it is open.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

All direct data edits performed by an Admin must include a justification of at least 20 characters.

### 5.1.3 Enforcement Point

Client-side (UI validation) and Server-side (Cloud Function).

### 5.1.4 Violation Handling

The edit operation is rejected, and an error message is returned to the user.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

All direct edits by an Admin must be logged immutably in the `auditLog` collection.

### 5.2.3 Enforcement Point

Server-side (Cloud Function transaction).

### 5.2.4 Violation Handling

If the audit log cannot be created, the entire edit transaction is rolled back, and no changes are saved to the attendance record.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-059

#### 6.1.1.2 Dependency Reason

Requires the Admin's attendance report view to exist, which is where the 'Edit' action will be initiated.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-051

#### 6.1.2.2 Dependency Reason

This story creates the data that US-051 (View Audit Log) will display. While not a strict blocker for implementation, they are functionally coupled.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication with Admin role custom claims.
- Defined Firestore schema for `/attendance` and `/auditLog` collections.
- A callable Firebase Cloud Function environment.

## 6.3.0.0 Data Dependencies

- Requires existing attendance records to be present in the database for testing.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The server-side transaction (update attendance + create audit log) must complete within 500ms (p95).

## 7.2.0.0 Security

- The action must be protected by a callable Cloud Function that verifies the caller has an 'Admin' role via their auth token's custom claims.
- Firestore Security Rules must prevent direct client-side modification of attendance records by Admins, forcing the use of the secure Cloud Function.
- Firestore Security Rules must enforce the immutability of the `/auditLog` collection (allow create, deny update/delete).

## 7.3.0.0 Usability

- The process of editing a record should be intuitive, with clear feedback on success or failure.

## 7.4.0.0 Accessibility

- The edit modal must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported browsers for the web dashboard (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a transactional Firebase Cloud Function to ensure atomicity between updating the attendance record and creating the audit log entry.
- Requires careful implementation of Firestore Security Rules to enforce the correct authorization flow.
- Frontend state management for the modal, including real-time validation, adds complexity.

## 8.3.0.0 Technical Risks

- Potential for race conditions if the record is modified by another process (e.g., auto-checkout) simultaneously. A Firestore transaction mitigates this risk.
- Incorrectly configured security rules could either block legitimate edits or allow unauthorized ones.

## 8.4.0.0 Integration Points

- Firebase Authentication (for role verification).
- Firestore Database (for reading/writing attendance and audit log data).
- Firebase Cloud Functions (for secure, transactional business logic).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Admin successfully edits a record.
- Admin attempts to edit with invalid justification (empty, too short).
- Admin attempts to edit with invalid time logic (check-out before check-in).
- Verify that a non-Admin user cannot trigger the edit function.
- Verify the atomicity of the transaction: if audit log creation fails, the attendance record is not updated.
- Verify the immutability of created audit logs against update/delete attempts.

## 9.3.0.0 Test Data Needs

- A test user with 'Admin' role.
- A test user with 'Supervisor' or 'Subordinate' role (for negative testing).
- Several sample attendance records with different statuses.

## 9.4.0.0 Testing Tools

- Flutter's `flutter_test` for unit/widget tests.
- Firebase Local Emulator Suite for local integration testing of the Cloud Function and Firestore rules.
- Jest for Cloud Function unit tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for UI logic and Cloud Function, achieving >80% coverage
- Integration testing completed successfully using the Firebase Emulator Suite
- User interface reviewed and approved for usability and accessibility
- Security requirements validated, including Firestore rules and function authentication
- Documentation for the Cloud Function's purpose and inputs is created
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- Requires both frontend (Flutter Web) and backend (Cloud Functions/TypeScript) development effort.
- Should be prioritized after the core attendance reporting view (US-059) is available in the sprint or a previous one.

## 11.4.0.0 Release Impact

This is a critical administrative feature required for maintaining data integrity. It is essential for a V1.0 release to enterprise clients.

