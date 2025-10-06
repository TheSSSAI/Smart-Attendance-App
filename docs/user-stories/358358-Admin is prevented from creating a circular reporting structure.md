# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-016 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin is prevented from creating a circular report... |
| As A User Story | As an Admin, I want the system to validate and pre... |
| User Persona | Admin user responsible for managing users, teams, ... |
| Business Value | Ensures data integrity of the organizational hiera... |
| Functional Area | User Management |
| Story Theme | Tenant Administration & Data Integrity |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Admin assigns a valid supervisor to a user

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

An Admin is editing the profile of 'User A' who currently reports to 'Supervisor X'

### 3.1.5 When

The Admin changes the supervisor of 'User A' to 'Supervisor Y', where 'Supervisor Y' is not 'User A' and does not report to 'User A' directly or indirectly

### 3.1.6 Then

The system successfully saves the change, and 'User A's profile now reflects 'Supervisor Y' as their supervisor.

### 3.1.7 Validation Notes

Verify in Firestore that the `supervisorId` for 'User A's document is updated to the `userId` of 'Supervisor Y'.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Admin attempts to assign a user as their own supervisor

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

An Admin is editing the profile of 'User A'

### 3.2.5 When

The Admin attempts to select 'User A' from the list of supervisors and save the change

### 3.2.6 Then

The system must prevent the save operation and display a clear error message, such as 'A user cannot be their own supervisor.'

### 3.2.7 Validation Notes

The UI should show the error message, and the 'Save' button should be disabled. Verify no change is written to the database.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Error Condition: Admin attempts to create a direct circular dependency (A -> B, then B -> A)

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

An organizational structure exists where 'User B' reports directly to 'Supervisor A'

### 3.3.5 When

An Admin edits the profile of 'Supervisor A' and attempts to assign 'User B' as their new supervisor

### 3.3.6 Then

The system must prevent the save operation and display a clear error message, such as ''User B' cannot be the supervisor as they are in the reporting line of 'Supervisor A'.'

### 3.3.7 Validation Notes

The validation logic must detect the direct subordinate relationship. Verify no change is written to the database.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Error Condition: Admin attempts to create a multi-level, indirect circular dependency (A -> B -> C, then C -> A)

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

An organizational structure exists where 'User C' reports to 'Supervisor B', and 'Supervisor B' reports to 'Manager A'

### 3.4.5 When

An Admin edits the profile of 'Manager A' and attempts to assign 'User C' as their new supervisor

### 3.4.6 Then

The system must traverse the hierarchy, detect the loop, prevent the save, and display a clear error message, such as ''User C' cannot be the supervisor as they are in the reporting line of 'Manager A'.'

### 3.4.7 Validation Notes

The server-side validation logic must recursively or iteratively check the entire upward reporting chain of the proposed new supervisor.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Alternative Flow: Admin removes a supervisor from a user

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

An Admin is editing the profile of 'User A' who currently reports to 'Supervisor X'

### 3.5.5 When

The Admin removes the supervisor assignment, setting it to null/none

### 3.5.6 Then

The system successfully saves the change, and 'User A' no longer has an assigned supervisor.

### 3.5.7 Validation Notes

This action should always be permitted and should not trigger the circular dependency check. Verify the `supervisorId` field is set to null in Firestore.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Supervisor selection dropdown/search field in the user profile edit form (Admin Web Dashboard).

## 4.2.0 User Interactions

- When an invalid supervisor is selected, an inline error message appears immediately below the selection field.
- The 'Save Changes' button for the user profile form should be disabled as long as an invalid supervisor is selected.

## 4.3.0 Display Requirements

- Error messages must be user-friendly and clearly explain why the assignment is not allowed.

## 4.4.0 Accessibility Needs

- Error messages must be associated with the form field programmatically for screen reader users (e.g., using `aria-describedby`).

# 5.0.0 Business Rules

- {'rule_id': 'BR-HIER-001', 'rule_description': 'A user cannot be their own supervisor, either directly or indirectly through a reporting chain.', 'enforcement_point': "Server-side, via a callable Cloud Function, invoked when an Admin attempts to save a change to a user's `supervisorId`.", 'violation_handling': 'The operation is rejected with a specific error code and message, which is then displayed to the Admin in the UI.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-004

#### 6.1.1.2 Dependency Reason

Requires the ability for Admins to create/invite users whose supervisor relationships can be managed.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-014

#### 6.1.2.2 Dependency Reason

Requires the user management interface where an Admin can edit a user's profile details, including their supervisor.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for Admin role verification.
- Firebase Firestore for storing and querying user and hierarchy data.
- Firebase Cloud Functions for implementing the server-side validation logic.

## 6.3.0.0 Data Dependencies

- The `/users/{userId}` collection must exist with a `supervisorId` field that references another user's ID.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The server-side validation check must complete within 1000ms for hierarchies up to 10 levels deep to ensure a responsive UI experience for the Admin.

## 7.2.0.0 Security

- The circular dependency check MUST be enforced on the server-side (Cloud Function) to prevent circumvention of client-side validation.
- The Cloud Function must validate that the caller has the 'Admin' role before executing the logic.

## 7.3.0.0 Usability

- The error feedback must be immediate and contextually relevant to the Admin's action.

## 7.4.0.0 Accessibility

- WCAG 2.1 Level AA standards must be met for the form fields and error messages.

## 7.5.0.0 Compatibility

- The functionality must work correctly on all supported browsers for the Admin Web Dashboard as per REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires recursive or iterative logic to traverse the reporting hierarchy on the backend.
- The logic must be robust and handle various edge cases, such as users with no supervisor (top of a chain).
- Requires a secure callable Cloud Function rather than relying on Firestore Security Rules, which are not well-suited for this type of multi-document, recursive validation.

## 8.3.0.0 Technical Risks

- A poorly implemented traversal algorithm could be inefficient and lead to slow response times or excessive Firestore read costs for deep hierarchies.
- Risk of infinite loops in the validation function itself if not carefully coded.

## 8.4.0.0 Integration Points

- Admin Web Dashboard's user profile management page.
- Callable Firebase Cloud Function for validation.
- Firestore `users` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Unit test the Cloud Function with mock data for: a valid assignment, a self-assignment, a direct loop, and a 5-level indirect loop.
- Integration test the API call from the web dashboard to the Cloud Function, verifying correct handling of both success and error responses.
- E2E test the full Admin workflow: log in, navigate to user management, attempt to create a circular dependency, verify UI error, then correct to a valid supervisor and verify success.

## 9.3.0.0 Test Data Needs

- A test tenant with a pre-populated organizational hierarchy of at least 5 levels deep.
- Users with and without existing supervisors.

## 9.4.0.0 Testing Tools

- Jest for Cloud Function unit tests.
- Firebase Local Emulator Suite for local integration testing.
- Flutter `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Server-side validation logic is implemented in a Firebase Cloud Function
- Code reviewed and approved by team
- Unit tests for the Cloud Function achieve >90% coverage of the validation logic
- Integration testing between the web client and Cloud Function completed successfully
- User interface on the Admin Web Dashboard correctly displays errors and prevents invalid saves
- E2E tests for happy path and all error conditions are passing
- Performance of the validation check is verified against requirements
- Security requirements validated (Admin role check)
- Documentation for the validation Cloud Function is created
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational data integrity rule. It should be implemented before or alongside the primary user editing features to prevent data corruption early on.
- The backend (Cloud Function) and frontend (UI) work can potentially be parallelized.

## 11.4.0.0 Release Impact

- Critical for the stability of the user management and approval workflow features. A release without this functionality carries a high risk of data integrity issues.

