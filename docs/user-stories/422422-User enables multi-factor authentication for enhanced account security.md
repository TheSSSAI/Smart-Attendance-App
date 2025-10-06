# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-080 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User enables multi-factor authentication for enhan... |
| As A User Story | As a security-conscious user (Admin, Supervisor, o... |
| User Persona | Any active user of the system (Admin, Supervisor, ... |
| Business Value | Increases the security of user accounts and protec... |
| Functional Area | User Account Management & Security |
| Story Theme | Account Security Enhancements |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

User navigates to the MFA settings screen

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a logged-in user

### 3.1.5 When

I navigate to my profile or account settings screen

### 3.1.6 Then

I can see a 'Security' section with an option to manage 'Multi-Factor Authentication'.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

User successfully enables MFA with a valid phone number and OTP

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am on the security settings screen and MFA is currently disabled

### 3.2.5 When

I tap 'Enable MFA', enter a valid phone number, submit it, receive an OTP via SMS, and enter the correct OTP within the time limit

### 3.2.6 Then

I see a success message, and the security screen updates to show that MFA is 'Enabled', displaying a masked version of my phone number (e.g., **** *** 1234).

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

MFA is enforced during a subsequent login attempt

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I have successfully enabled MFA on my account and logged out

### 3.3.5 When

I enter my correct email and password on the login screen

### 3.3.6 Then

I am redirected to a new screen prompting me to enter a verification code sent to my registered phone number.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User successfully logs in using the second factor (OTP)

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

I have been prompted for an OTP after entering my password

### 3.4.5 When

I enter the correct OTP received via SMS

### 3.4.6 Then

I am successfully authenticated and redirected to my role-specific dashboard.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

User enters an invalid phone number format

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

I am on the screen to add a phone number for MFA

### 3.5.5 When

I enter a phone number with an incorrect format (e.g., contains letters, too few digits) and try to submit

### 3.5.6 Then

I see an inline validation error message stating 'Please enter a valid phone number', and no SMS is sent.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

User enters an incorrect OTP during verification

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

I am on the OTP entry screen for MFA setup or login

### 3.6.5 When

I enter an incorrect verification code

### 3.6.6 Then

I see an error message 'Invalid code. Please try again.' and I remain on the OTP entry screen.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

User requests to resend the OTP

### 3.7.3 Scenario Type

Alternative_Flow

### 3.7.4 Given

I am on the OTP entry screen and have not received the code or it has expired

### 3.7.5 When

I tap the 'Resend Code' link

### 3.7.6 Then

a new OTP is sent to my phone number, the previous code is invalidated, and a timer may appear to prevent immediate subsequent requests.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

User is temporarily locked out after too many incorrect OTP attempts

### 3.8.3 Scenario Type

Edge_Case

### 3.8.4 Given

I am on the OTP entry screen

### 3.8.5 When

I enter an incorrect OTP 5 consecutive times

### 3.8.6 Then

I am prevented from making further attempts for 15 minutes and see a message informing me of the temporary lockout.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Security' or 'MFA' section in the user's profile/settings.
- A toggle switch or button to 'Enable'/'Disable' MFA.
- An input field for the phone number with country code selection.
- An input field for the OTP.
- A 'Resend Code' text button or link.
- A visual indicator (e.g., masked phone number) showing that MFA is active.

## 4.2.0 User Interactions

- User taps to initiate the MFA setup flow.
- System presents a modal or new screen for phone number entry.
- System presents a subsequent screen for OTP entry.
- Clear success, error, and informational toasts or snackbars provide feedback to the user.

## 4.3.0 Display Requirements

- The current status of MFA (Enabled/Disabled) must be clearly visible.
- When enabled, the associated phone number must be displayed in a masked format for security.
- Error messages must be displayed in close proximity to the relevant input field.

## 4.4.0 Accessibility Needs

- All interactive elements (buttons, inputs) must have accessible labels for screen readers.
- Sufficient color contrast must be used for text, icons, and controls as per WCAG 2.1 AA standards.
- Error messages must be programmatically associated with their corresponding input fields.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-SEC-001

### 5.1.2 Rule Description

An OTP is valid for one-time use only and expires 5 minutes after being issued.

### 5.1.3 Enforcement Point

Server-side during OTP validation (Firebase Authentication).

### 5.1.4 Violation Handling

The verification request is rejected with an 'Invalid or expired code' error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-SEC-002

### 5.2.2 Rule Description

A user is allowed a maximum of 5 incorrect OTP entry attempts before a temporary lockout of 15 minutes is enforced.

### 5.2.3 Enforcement Point

Server-side during OTP validation (Firebase Authentication).

### 5.2.4 Violation Handling

Further verification attempts from the user are blocked for the duration of the lockout.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-SEC-003

### 5.3.2 Rule Description

Requests to resend an OTP are rate-limited to one request per 60 seconds to prevent SMS abuse.

### 5.3.3 Enforcement Point

Client-side (disabling the button) and server-side (rejecting frequent requests).

### 5.3.4 Violation Handling

The 'Resend Code' button is disabled on the UI, and server-side requests within the window are ignored or rejected.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

The standard email/password login flow must exist before it can be modified to include a second factor.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

A user profile/settings screen must exist to provide a location for the MFA management UI.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication SDK must be integrated into the Flutter application.
- The Firebase project must be configured to support Phone Number as an authentication method/second factor.

## 6.3.0.0 Data Dependencies

- Requires access to the current user's authentication state to link the phone number.

## 6.4.0.0 External Dependencies

- Reliant on Firebase Authentication's underlying SMS provider for OTP delivery.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- OTP SMS delivery should be completed within 15 seconds under normal network conditions.
- The server-side validation of the OTP should respond in under 500ms.

## 7.2.0.0 Security

- All communication with Firebase services must be over TLS.
- OTPs must be generated using a cryptographically secure random number generator.
- The application must enable SafetyNet/App Check in the Firebase project to protect the phone auth endpoint from abuse.

## 7.3.0.0 Usability

- The MFA setup process should be intuitive and guide the user through each step with clear instructions.
- Error messages should be user-friendly and actionable.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must be fully functional on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Managing the multi-step UI flow and state on the client-side (e.g., waiting for OTP, handling timers, displaying errors).
- Correctly configuring Firebase Authentication, including anti-abuse measures like reCAPTCHA verification or App Check.
- Handling various edge cases such as SMS delivery delays, network issues, and user navigation away from the app during verification.

## 8.3.0.0 Technical Risks

- Potential for SMS Pumping fraud if rate-limiting and anti-abuse features are not implemented correctly. This can lead to unexpected high costs.
- Variability in SMS delivery times and reliability across different carriers and regions.

## 8.4.0.0 Integration Points

- Firebase Authentication for backend logic.
- The existing user login and profile management modules in the Flutter application.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Full happy path: Enable MFA -> Logout -> Login with MFA.
- Failure path: Enter invalid phone number.
- Failure path: Enter incorrect OTP multiple times to trigger lockout.
- Alternative path: Use the 'Resend Code' functionality.
- Verify that the login flow for users *without* MFA enabled remains unchanged.

## 9.3.0.0 Test Data Needs

- Test user accounts within the Firebase Emulator.
- At least one real, physical phone number for final E2E validation in the staging environment.

## 9.4.0.0 Testing Tools

- Flutter's built-in testing framework (`flutter_test`).
- Firebase Local Emulator Suite to test Firebase Auth flows without sending real SMS messages.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >80% coverage for the new logic
- Integration testing against the Firebase Emulator completed successfully
- The UI/UX for the entire flow has been reviewed and approved
- Security requirements, including rate-limiting and anti-abuse, are validated
- E2E test successfully completed on a physical device in the staging environment
- Documentation for the user guide is updated to explain how to enable MFA
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

8

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a critical security feature and should be prioritized accordingly.
- The developer will need permissions to configure the Firebase project.
- Budgetary approval for SMS costs associated with production usage should be confirmed.

## 11.4.0.0 Release Impact

- This feature significantly improves the security posture of the application. Its release should be highlighted to users and customers.

