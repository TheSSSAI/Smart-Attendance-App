# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-023 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin must re-authenticate to confirm tenant delet... |
| As A User Story | As an Admin with the authority to delete my organi... |
| User Persona | Admin: The user role with full permissions over a ... |
| Business Value | Prevents catastrophic, accidental data loss for an... |
| Functional Area | Tenant Management |
| Story Theme | Tenant Offboarding and Data Lifecycle |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Admin successfully re-authenticates to confirm tenant deletion

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin is logged into the web dashboard and has clicked the final 'Delete Tenant' button, triggering the confirmation step

### 3.1.5 When

the re-authentication modal appears, the Admin enters their correct password, and clicks the 'Confirm Deletion' button

### 3.1.6 Then

the system successfully validates the password, the modal closes, and the tenant deletion process is initiated (i.e., the tenant is marked for deletion and the 30-day grace period begins).

### 3.1.7 Validation Notes

Verify that a call to a secure backend function is made. On success, the UI should navigate to a confirmation screen or show a success toast, and the tenant's status in Firestore should be updated to 'pending_deletion'.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Admin enters an incorrect password

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

the re-authentication modal for tenant deletion is displayed

### 3.2.5 When

the Admin enters an incorrect password and clicks 'Confirm Deletion'

### 3.2.6 Then

an inline error message 'Incorrect password. Please try again.' is displayed below the password field, the modal remains open, and the deletion process is not initiated.

### 3.2.7 Validation Notes

The backend function must return a specific error code for invalid credentials, which the frontend uses to display the correct message. No change should occur to the tenant's status in Firestore.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Alternative Flow: Admin cancels the deletion process

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

the re-authentication modal for tenant deletion is displayed

### 3.3.5 When

the Admin clicks the 'Cancel' button or closes the modal (e.g., by pressing the Escape key)

### 3.3.6 Then

the modal is dismissed, the deletion process is aborted, and the Admin is returned to the previous settings page.

### 3.3.7 Validation Notes

Verify that no backend call is made to initiate deletion and the UI state returns to normal.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Edge Case: Admin makes multiple failed re-authentication attempts

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

the re-authentication modal for tenant deletion is displayed

### 3.4.5 When

the Admin enters an incorrect password 5 consecutive times

### 3.4.6 Then

the 'Confirm Deletion' button becomes disabled, and a message like 'Too many failed attempts. Please try again in 1 minute.' is displayed.

### 3.4.7 Validation Notes

This aligns with REQ-FUN-003. The backend function should enforce this lockout and return an appropriate error code (e.g., 'auth/too-many-requests').

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Security: Non-Admin user attempts to access the functionality

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

a user without the 'Admin' role is logged in

### 3.5.5 When

they attempt to call the re-authentication backend function directly (e.g., via developer tools)

### 3.5.6 Then

the function must reject the request with a 'permission-denied' error.

### 3.5.7 Validation Notes

The Cloud Function must validate the caller's custom claims (`role: 'Admin'`) before executing any logic.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Modal Dialog
- Password Input Field (masked)
- Primary Destructive Action Button (e.g., 'Confirm Deletion', styled in red)
- Secondary Cancel Button
- Inline Error Message Area
- Loading Indicator/Spinner

## 4.2.0 User Interactions

- The modal must overlay the current page, focusing user attention.
- The 'Confirm Deletion' button should be disabled until a password is entered.
- Pressing 'Enter' in the password field should trigger the confirm action.
- The modal must be dismissible via the 'Cancel' button or the 'Escape' key.

## 4.3.0 Display Requirements

- The modal title must clearly state the action, e.g., 'Confirm Deletion of [Organization Name]'.
- A prominent warning message must be displayed, explaining that the action will schedule the permanent deletion of all organization data.

## 4.4.0 Accessibility Needs

- The modal must adhere to WCAG 2.1 AA standards.
- Keyboard focus must be trapped within the modal when it is active.
- All interactive elements must have accessible names (aria-labels).
- The destructive action button should have an `aria-describedby` attribute pointing to the warning text.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'Re-authentication is mandatory to confirm a tenant deletion request.', 'enforcement_point': 'Server-side, within the Firebase Cloud Function that processes the deletion request.', 'violation_handling': 'If the re-authentication step is bypassed or fails, the deletion request is rejected with an error.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-022

#### 6.1.1.2 Dependency Reason

This story implements the confirmation step for the deletion process initiated in US-022. The UI to start the deletion must exist first.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-017

#### 6.1.2.2 Dependency Reason

The core email/password authentication system must be functional to allow for re-authentication.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication: For validating user credentials.
- Firebase Cloud Functions: To host the secure, server-side re-authentication logic.
- Frontend State Management (Riverpod): To manage the modal's state (idle, loading, error).

## 6.3.0.0 Data Dependencies

- The user's authentication record in Firebase Auth.
- The user's custom claims, specifically the 'role' and 'tenantId'.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The server-side password validation must respond in under 500ms (p95) as per REQ-NFR-001.

## 7.2.0.0 Security

- The user's password must be sent over HTTPS and handled only by the secure Firebase Cloud Function.
- The Cloud Function must verify the caller is an authenticated Admin for the correct tenant before proceeding.
- The function must use Firebase's built-in re-authentication mechanisms and not implement custom password checking.
- Brute-force protection must be implemented as per REQ-FUN-003.

## 7.3.0.0 Usability

- The purpose of the re-authentication step must be explicitly clear to the user to avoid confusion.

## 7.4.0.0 Accessibility

- The modal dialog must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The modal dialog must function correctly on all supported web browsers (Chrome, Firefox, Safari, Edge) as per REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both frontend (modal UI and state management) and backend (secure Cloud Function) development.
- Implementing the server-side re-authentication logic requires careful handling of security contexts and errors from the Firebase Admin SDK.
- Coordination between frontend and backend on the API contract (request payload, success/error responses) is critical.

## 8.3.0.0 Technical Risks

- Improper implementation of the Cloud Function could create a security vulnerability.
- Incorrect error handling could lead to a confusing user experience or a stuck UI state.

## 8.4.0.0 Integration Points

- Frontend Admin Dashboard (Flutter for Web) -> Firebase Cloud Functions
- Firebase Cloud Functions -> Firebase Authentication Service

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Successful re-authentication.
- Re-authentication with an incorrect password.
- Cancelling the operation from the modal.
- Triggering the brute-force protection after multiple failed attempts.
- Attempting to trigger the action as a non-Admin user.

## 9.3.0.0 Test Data Needs

- A test user account with the 'Admin' role.
- A test user account with a 'Supervisor' or 'Subordinate' role to test security rules.

## 9.4.0.0 Testing Tools

- Flutter's `flutter_test` for widget tests.
- Jest for Cloud Function unit tests.
- Firebase Local Emulator Suite for local integration testing.
- Flutter's `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for the modal UI and Cloud Function implemented with >80% coverage
- Integration testing between the frontend and backend function completed successfully using the Emulator Suite
- User interface reviewed and approved for usability and accessibility
- Security requirements validated, including role-based access control on the Cloud Function
- Documentation for the Cloud Function's purpose and security model is created
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a critical part of the tenant offboarding flow and is a blocker for completing the entire feature.
- Requires a developer comfortable with both frontend Flutter and backend TypeScript/Firebase Functions.

## 11.4.0.0 Release Impact

This is a core security feature for the tenant lifecycle. The offboarding feature cannot be released without it.

