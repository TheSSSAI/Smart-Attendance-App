# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-017 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User logs in with email and password |
| As A User Story | As a registered user (Admin, Supervisor, or Subord... |
| User Persona | Any registered and active user of the system (Admi... |
| Business Value | Provides the fundamental security mechanism to aut... |
| Functional Area | Authentication and User Management |
| Story Theme | User Authentication |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful login with valid credentials

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A registered user with an 'active' status is on the login screen

### 3.1.5 When

The user enters their correct email and password and taps the 'Log In' button

### 3.1.6 Then

The system successfully authenticates the user, a session is created, and the user is redirected to their role-specific dashboard (Admin, Supervisor, or Subordinate).

### 3.1.7 Validation Notes

Verify redirection to the correct dashboard based on the user's role defined in Firestore or custom claims.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Login attempt with an incorrect password

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

A registered user is on the login screen

### 3.2.5 When

The user enters their correct email but an incorrect password and taps 'Log In'

### 3.2.6 Then

A clear, non-specific error message such as 'Invalid email or password. Please try again.' is displayed, and the user remains on the login screen.

### 3.2.7 Validation Notes

The error message should be generic to prevent account enumeration attacks.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Login attempt with a non-existent email

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

A user is on the login screen

### 3.3.5 When

The user enters an email address that is not registered in the system and taps 'Log In'

### 3.3.6 Then

The same generic error message 'Invalid email or password. Please try again.' is displayed.

### 3.3.7 Validation Notes

This ensures the system does not reveal which email addresses are registered.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Login attempt by a deactivated user

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

A user whose account status is 'deactivated' is on the login screen

### 3.4.5 When

The user enters their correct email and password and taps 'Log In'

### 3.4.6 Then

A specific error message is displayed, such as 'Your account has been deactivated. Please contact your administrator.', and access is denied.

### 3.4.7 Validation Notes

This check should occur after credential validation to prevent leaking account status information.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Account is temporarily locked after multiple failed attempts

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A user has made 5 consecutive failed login attempts for a single account

### 3.5.5 When

The user makes a 6th login attempt for the same account

### 3.5.6 Then

An error message is displayed indicating the account is temporarily locked (e.g., 'Too many failed attempts. Your account is locked for 15 minutes.') and the login attempt is blocked.

### 3.5.7 Validation Notes

This relies on Firebase Authentication's built-in brute-force protection. Verify this behavior is active.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Client-side validation for email format

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

A user is on the login screen

### 3.6.5 When

The user enters text that is not a valid email format (e.g., 'testuser') into the email field and attempts to log in

### 3.6.6 Then

A validation message appears next to the email field (e.g., 'Please enter a valid email address'), and no request is sent to the server.

### 3.6.7 Validation Notes

Test with various invalid email formats.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Visual feedback during authentication process

### 3.7.3 Scenario Type

Happy_Path

### 3.7.4 Given

A user is on the login screen and has entered their credentials

### 3.7.5 When

The user taps the 'Log In' button

### 3.7.6 Then

The 'Log In' button becomes disabled and a loading indicator is displayed until the authentication process completes with either success or failure.

### 3.7.7 Validation Notes

Verify the UI state changes to prevent multiple submissions.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Email address input field with appropriate keyboard type (email).
- Password input field with text masking enabled.
- A primary 'Log In' button.
- A 'Forgot Password?' link/button (leading to US-020 functionality).

## 4.2.0 User Interactions

- Tapping into a field should show the keyboard.
- Password field should have an optional icon to toggle password visibility.
- Tapping 'Log In' submits the form for authentication.

## 4.3.0 Display Requirements

- Clear labels for 'Email' and 'Password' fields.
- Error messages must be displayed in a prominent, non-disruptive location (e.g., below the input fields or in a snackbar).
- A loading indicator (e.g., a spinner) must be shown during the authentication request.

## 4.4.0 Accessibility Needs

- All input fields must have proper labels for screen readers (WCAG 2.1 AA).
- Sufficient color contrast for text, buttons, and error messages.
- The login form should be navigable using only a keyboard or assistive technology.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-AUTH-001

### 5.1.2 Rule Description

A user account must have a status of 'active' to be granted access.

### 5.1.3 Enforcement Point

Server-side, after successful credential validation but before session creation.

### 5.1.4 Violation Handling

Authentication is rejected, and a specific 'deactivated account' error message is returned to the client.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-AUTH-002

### 5.2.2 Rule Description

An account shall be temporarily locked for 15 minutes after 5 consecutive failed login attempts.

### 5.2.3 Enforcement Point

Firebase Authentication service.

### 5.2.4 Violation Handling

Subsequent login attempts for the locked account are blocked for the duration, and a 'too many requests' error is returned.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-006

#### 6.1.1.2 Dependency Reason

A user must have completed the registration and password creation process before they can log in.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

A role-specific dashboard must exist as a destination for the user after a successful login.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication SDK for Flutter.
- Firebase project with Email/Password authentication provider enabled.
- Firestore database for retrieving user role and status after authentication.

## 6.3.0.0 Data Dependencies

- Requires existing user records in Firebase Authentication and corresponding user profile documents in Firestore with 'role' and 'status' fields.

## 6.4.0.0 External Dependencies

- Availability of the Firebase Authentication service.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The end-to-end login process (from button tap to redirect or error) should complete in < 2 seconds on a 4G connection.

## 7.2.0.0 Security

- All communication with the backend must be over HTTPS/TLS.
- The client application must not store the user's password locally.
- The system must use the official Firebase Authentication SDK to handle credential verification and token management securely.

## 7.3.0.0 Usability

- Error messages must be clear, concise, and user-friendly.
- The login process should be intuitive and require minimal steps.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The login screen must render correctly on all supported iOS and Android versions (as per REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Leverages Firebase Auth SDK, which abstracts most of the complexity.
- Requires careful state management on the client to handle loading, success, and multiple error states.
- Requires a mechanism (e.g., custom claims or a Firestore read) to fetch the user's role immediately after login to determine the correct redirection path.

## 8.3.0.0 Technical Risks

- Mismanagement of Firebase Auth error codes could lead to poor user feedback.
- Improper handling of the user's auth state could lead to security vulnerabilities (e.g., accessing protected routes without being logged in).

## 8.4.0.0 Integration Points

- Firebase Authentication for credential verification.
- Firestore for fetching user profile data (role, status) post-login.
- Application's routing/navigation system for redirection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Successful login for each user role (Admin, Supervisor, Subordinate).
- Login with incorrect password.
- Login with non-existent email.
- Login attempt for a deactivated account.
- Verify UI state changes (loading indicator, error messages).
- Verify brute-force protection after multiple failed attempts.

## 9.3.0.0 Test Data Needs

- Test accounts for each user role with 'active' status.
- A test account with 'deactivated' status.
- Credentials for non-existent accounts.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration and E2E testing without hitting live services.
- Flutter's `flutter_test` and `integration_test` packages.

# 10.0.0.0 Definition Of Done

- All acceptance criteria are met and have been validated by QA.
- Code has been peer-reviewed and merged into the main branch.
- Unit and widget tests are written and achieve required code coverage.
- End-to-end integration tests for all major scenarios are passing in the CI/CD pipeline.
- UI conforms to the design specifications and accessibility standards.
- Performance on target devices meets the specified requirements.
- Security review confirms that credentials are handled securely and no sensitive data is leaked.
- The feature is deployed and verified on the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story and a blocker for almost all other user-facing features. It should be prioritized in an early sprint.
- Requires the Firebase project and authentication to be configured beforehand.

## 11.4.0.0 Release Impact

This feature is critical for the initial application release (MVP).

