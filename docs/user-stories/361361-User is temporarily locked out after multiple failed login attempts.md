# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-019 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User is temporarily locked out after multiple fail... |
| As A User Story | As a registered user, I want my account to be temp... |
| User Persona | Any registered user of the system (Admin, Supervis... |
| Business Value | Enhances platform security by mitigating brute-for... |
| Functional Area | Authentication and Security |
| Story Theme | User Account Security |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Account is locked after 5 consecutive failed login attempts

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A user with a valid account exists

### 3.1.5 When

The user enters an incorrect password for the 5th consecutive time

### 3.1.6 Then

The system locks the account for 15 minutes AND displays a clear error message stating: 'Your account has been temporarily locked due to too many failed login attempts. Please try again in 15 minutes.'

### 3.1.7 Validation Notes

Verify that the account status is marked as 'locked' in the backend with a 'lockedUntil' timestamp. The UI must show the specified message.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Failed login attempt counter is reset after a successful login

### 3.2.3 Scenario Type

Alternative_Flow

### 3.2.4 Given

A user has 4 consecutive failed login attempts

### 3.2.5 When

The user enters the correct password on the 5th attempt

### 3.2.6 Then

The user is successfully logged in AND the failed login attempt counter for their account is reset to 0.

### 3.2.7 Validation Notes

Check the backend data for the user to confirm the failed attempt counter is reset to zero after a successful authentication.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User is prevented from logging in while their account is locked

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

A user's account is in a locked state

### 3.3.5 When

The user attempts to log in with the correct password during the 15-minute lockout period

### 3.3.6 Then

The login attempt is rejected without validating the password AND the system displays the same lockout error message.

### 3.3.7 Validation Notes

This check should happen before the password validation to prevent unnecessary processing and to consistently show the lockout message.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Account is automatically unlocked after the lockout period expires

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

A user's account has been locked and the 15-minute lockout period has passed

### 3.4.5 When

The user attempts to log in with the correct password

### 3.4.6 Then

The user is successfully logged in AND the failed login attempt counter is reset to 0.

### 3.4.7 Validation Notes

The system must correctly compare the current time with the 'lockedUntil' timestamp. After a successful login, verify the counter is reset.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Failed login attempts are tracked per-user

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

User A has 4 failed login attempts

### 3.5.5 When

User B attempts to log in with an incorrect password

### 3.5.6 Then

User A's failed login attempt counter remains at 4.

### 3.5.7 Validation Notes

Verify that the state for tracking failed attempts is isolated to each individual user account.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Successful password reset unlocks the account immediately

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

A user's account is in a locked state

### 3.6.5 When

The user successfully completes the 'Forgot Password' flow and sets a new password

### 3.6.6 Then

The account lock is immediately removed AND the failed login attempt counter is reset to 0.

### 3.6.7 Validation Notes

This provides a crucial recovery path for legitimate users who are locked out. The password reset function must clear the lockout status.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Error message display area on the login screen.

## 4.2.0 User Interactions

- User enters credentials and submits the login form.
- System displays an error message upon failed login or lockout.

## 4.3.0 Display Requirements

- On the 5th failed attempt, the generic 'Invalid credentials' message must be replaced with the specific lockout message: 'Your account has been temporarily locked due to too many failed login attempts. Please try again in 15 minutes.'
- Any subsequent login attempts during the lockout period must also display this specific message.

## 4.4.0 Accessibility Needs

- The error message must be programmatically associated with the login form fields and announced by screen readers (e.g., using `aria-live` or similar attributes).

# 5.0.0 Business Rules

- {'rule_id': 'BR-SEC-001', 'rule_description': 'An account shall be temporarily locked for 15 minutes after 5 consecutive failed login attempts.', 'enforcement_point': 'Server-side, during the authentication process.', 'violation_handling': 'The account is flagged as locked, and subsequent login attempts are denied until the lockout period expires.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

This story modifies the core login functionality; therefore, the basic email/password login must exist first.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-020

#### 6.1.2.2 Dependency Reason

The acceptance criteria includes unlocking the account upon a successful password reset, which requires the password reset feature to be implemented.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication service.
- Firebase Firestore for tracking failed attempt counts and lockout timestamps if not using a built-in Firebase Identity Platform feature.

## 6.3.0.0 Data Dependencies

- Requires access to user account data to store and retrieve failed attempt counts and lockout status.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The lockout check mechanism should add no more than 50ms of latency to the login API response time.

## 7.2.0.0 Security

- All logic for counting attempts, setting locks, and checking lock status MUST be executed and enforced on the server-side (e.g., Cloud Functions or Firebase Security Rules) to prevent client-side bypass.
- The system should not reveal whether a username is valid or not in its error messages to prevent username enumeration.

## 7.3.0.0 Usability

- The lockout message must be clear and provide a path to resolution ('try again in 15 minutes').
- Allowing password reset to override a lockout is a key usability requirement for legitimate users.

## 7.4.0.0 Accessibility

- The application must meet WCAG 2.1 Level AA standards, ensuring error messages are accessible.

## 7.5.0.0 Compatibility

- This functionality must work consistently across all supported platforms (iOS, Android, Web).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires server-side state management for each user (failed attempts, lockout timestamp).
- Decision required on using Firebase Identity Platform's built-in protection vs. a custom implementation with Firestore and Cloud Functions. The custom route offers more control but is more complex.
- Logic must be atomic to prevent race conditions from rapid, concurrent login attempts.

## 8.3.0.0 Technical Risks

- If implementing a custom solution, ensuring the atomicity of read/update operations on the attempt counter is critical. Firestore transactions should be used.
- Ensuring time-based logic is robust and not susceptible to client-side clock manipulation.

## 8.4.0.0 Integration Points

- Tightly integrated with the Firebase Authentication login process.
- Integrated with the 'Forgot Password' workflow to clear the lockout status.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Simulate 5 incorrect password entries and verify lockout.
- Simulate 4 incorrect entries followed by 1 correct entry and verify successful login.
- Attempt login with correct credentials while account is locked.
- Wait for lockout to expire and verify successful login is possible.
- Trigger a lockout and then complete a password reset to verify the lock is cleared.

## 9.3.0.0 Test Data Needs

- A dedicated test user account whose password is known.
- Ability to reset the failed attempt counter and lockout status for the test user between test runs.

## 9.4.0.0 Testing Tools

- Jest for Cloud Function unit tests.
- Firebase Local Emulator Suite for integration testing.
- Flutter `integration_test` for E2E testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing in a staging environment.
- Code for both client-side messaging and server-side logic is peer-reviewed and merged.
- Unit tests for server-side logic achieve at least 80% coverage.
- Integration tests covering the full login/lockout/unlock flow are implemented and passing.
- UI review confirms the error message is displayed correctly on all supported platforms.
- Security review confirms that the lockout logic cannot be bypassed from the client.
- The feature is documented in the technical specification.
- Story is deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational security feature and should be prioritized early in the development cycle.
- A technical spike may be needed to evaluate Firebase Identity Platform's capabilities vs. the effort of a custom implementation to meet the exact requirements.

## 11.4.0.0 Release Impact

- Improves the security posture of the initial release. It is considered a mandatory feature for a public launch.

