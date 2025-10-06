# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-010 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Deactivated user is prevented from logging in |
| As A User Story | As a deactivated user, I want to be prevented from... |
| User Persona | A user whose account status has been set to 'deact... |
| Business Value | Enhances security by ensuring that offboarded user... |
| Functional Area | User Authentication & Security |
| Story Theme | User Management & Access Control |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Deactivated user attempts login with correct credentials

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a user exists with a status of 'deactivated' in the system

### 3.1.5 When

the user attempts to log in using their correct email and password

### 3.1.6 Then

the system must reject the authentication attempt before issuing a session token

### 3.1.7 And

the user remains on the login screen.

### 3.1.8 Validation Notes

Verify via integration test that the Firebase Auth SDK returns an 'auth/user-disabled' error code. Manually verify the UI message.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Deactivated user attempts login with incorrect credentials

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

a user exists with a status of 'deactivated' in the system

### 3.2.5 When

the user attempts to log in using their correct email but an incorrect password

### 3.2.6 Then

the system must reject the authentication attempt

### 3.2.7 And

the system must NOT reveal that the account is deactivated, to prevent account status enumeration.

### 3.2.8 Validation Notes

Verify that the error message is identical to the one shown for an active user with an incorrect password.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Deactivated user attempts login with Phone OTP

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

a user exists with a status of 'deactivated' and has a phone number registered

### 3.3.5 When

the user attempts to log in using the Phone OTP method

### 3.3.6 Then

the system must reject the final authentication step after the correct OTP is entered

### 3.3.7 And

the user is shown the 'Your account is no longer active' message.

### 3.3.8 Validation Notes

Test the full OTP flow and confirm the login is blocked at the final stage.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User with 'invited' status attempts to log in

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

a user exists with a status of 'invited' in the system

### 3.4.5 When

the user attempts to log in directly without using their registration link

### 3.4.6 Then

the system must reject the authentication attempt

### 3.4.7 And

a message is displayed indicating their account is not yet active, such as 'Please use the registration link sent to your email to activate your account.'

### 3.4.8 Validation Notes

This ensures that only users who have completed the invitation workflow can log in.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Active user successfully logs in

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

a user exists with a status of 'active'

### 3.5.5 When

the user attempts to log in with their correct credentials

### 3.5.6 Then

the authentication is successful

### 3.5.7 And

the user is granted a session and redirected to their dashboard.

### 3.5.8 Validation Notes

This is a regression test to ensure the new logic does not block valid users.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Error message display area on the login screen (e.g., a snackbar, toast, or text below the input fields).

## 4.2.0 User Interactions

- On failed login due to inactive status, the system displays the error message without clearing the username/email field.

## 4.3.0 Display Requirements

- The error message for an inactive account must be distinct from the 'invalid credentials' message.
- The message must be clear, user-friendly, and provide guidance (e.g., 'contact your administrator').

## 4.4.0 Accessibility Needs

- The error message must be programmatically associated with the login form and announced by screen readers (e.g., using `aria-live` or an alert role).

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': "Only users with a status of 'active' are permitted to authenticate and gain access to the system.", 'enforcement_point': 'During the authentication process, on the server-side, before a session token is issued.', 'violation_handling': 'The authentication attempt is rejected, and a specific error code/message is returned to the client.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-008

#### 6.1.1.2 Dependency Reason

The ability for an Admin to deactivate a user must exist to create the 'deactivated' state for testing.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-017

#### 6.1.2.2 Dependency Reason

The basic email/password login flow must be implemented before this modification can be added.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication service for handling user sign-in.
- Firebase Firestore for storing user profiles and the 'status' field.

## 6.3.0.0 Data Dependencies

- Requires a user record in Firestore with a 'status' field that can be set to 'deactivated', 'invited', or 'active'.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The status check must add less than 100ms of latency to the overall login process.

## 7.2.0.0 Security

- The account status check MUST be performed on the backend (e.g., via Firebase Auth Blocking Functions or secure Cloud Function) and must not be bypassable by the client.
- Error messages for incorrect passwords must be identical for active and inactive accounts to prevent user enumeration attacks.
- Firestore Security Rules must deny data access to any authenticated user whose status is not 'active'.

## 7.3.0.0 Usability

- The error message should be helpful and guide the user on the next steps, rather than being a generic 'Login Failed' message.

## 7.4.0.0 Accessibility

- WCAG 2.1 Level AA standards must be met for the error message display.

## 7.5.0.0 Compatibility

- This functionality must work consistently across the iOS, Android, and Web clients.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- The logic is straightforward.
- Firebase provides direct mechanisms (like Auth Blocking Functions) to implement this securely.

## 8.3.0.0 Technical Risks

- Risk of implementing the check on the client-side, which would be insecure. The implementation must be server-side.
- Incorrectly configured Firestore security rules could still allow data access even if login is blocked.

## 8.4.0.0 Integration Points

- Firebase Authentication: The primary integration point. The `beforeSignIn` blocking function is the recommended approach.
- Firestore: The function will need to read the user's document from Firestore to check the `status` field.
- Firestore Security Rules: Rules must be updated to check for an `active` status claim on the auth token for all data access.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Attempt login with correct credentials for a deactivated user.
- Attempt login with incorrect credentials for a deactivated user.
- Attempt login with correct credentials for an invited user.
- Attempt login with correct credentials for an active user (regression).
- Verify that Firestore data is inaccessible to a user who manages to get a token before their status is checked (if not using blocking functions).

## 9.3.0.0 Test Data Needs

- Test accounts in Firebase Authentication.
- Corresponding user documents in Firestore with statuses: 'active', 'deactivated', and 'invited'.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration testing.
- Jest for testing Cloud Functions.
- Flutter `integration_test` package for E2E testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for any backend logic are implemented and passing with >80% coverage
- Integration testing confirms that login is blocked server-side for inactive users
- User interface displays the correct, non-revealing error messages as specified
- Security review confirms no information leakage and that Firestore rules are updated
- Documentation for the authentication flow is updated to include the status check
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational security feature and should be prioritized early in the development cycle, alongside other user management stories.

## 11.4.0.0 Release Impact

- This feature is critical for a production release. The application cannot go live without this security control.

