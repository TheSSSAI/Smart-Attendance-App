# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-018 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User logs in with Phone OTP |
| As A User Story | As a registered user (Admin, Supervisor, or Subord... |
| User Persona | Any registered and active user (Admin, Supervisor,... |
| Business Value | Improves account security by offering a form of mu... |
| Functional Area | Authentication and User Management |
| Story Theme | User Authentication Enhancements |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful login with a valid phone number and OTP

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am on the login screen and have an active account with a registered and verified phone number

### 3.1.5 When

I select the 'Login with Phone' option, enter my registered phone number, and tap 'Send Code'

### 3.1.6 And

I receive an SMS with a 6-digit OTP and enter the correct OTP on the verification screen before it expires

### 3.1.7 Then

the system validates the OTP, logs me in, and I am redirected to my role-specific dashboard (as defined in REQ-FUN-003).

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Attempting to log in with an unregistered phone number

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am on the login screen

### 3.2.5 When

I enter a phone number that is not associated with any active user account and tap 'Send Code'

### 3.2.6 Then

I see an error message stating 'This phone number is not registered with an active account.' and no OTP is sent.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Entering an incorrect OTP

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I have received an OTP for my registered phone number and am on the OTP verification screen

### 3.3.5 When

I enter an incorrect 6-digit OTP and tap 'Verify'

### 3.3.6 Then

I see an error message stating 'Invalid code. Please try again.' and I remain on the OTP verification screen.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Entering an expired OTP

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

I have received an OTP which has a 2-minute validity period

### 3.4.5 When

I enter the correct OTP after the 2-minute period has elapsed

### 3.4.6 Then

I see an error message stating 'This code has expired. Please request a new one.' and the input field is cleared.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Requesting to resend the OTP

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

I am on the OTP verification screen

### 3.5.5 When

I tap the 'Resend Code' button after the initial 30-second cooldown period

### 3.5.6 Then

a new OTP is sent to my phone number, the expiry timer on the screen resets to 2 minutes, and the 'Resend Code' button is disabled for another 30 seconds.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Attempting to log in with a deactivated account

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

my user account status is 'deactivated' and I have a registered phone number

### 3.6.5 When

I enter my phone number and successfully verify the OTP

### 3.6.6 Then

the system prevents the login and I see a message 'Your account has been deactivated. Please contact your administrator.' (as defined in REQ-FUN-003).

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Exceeding the OTP request rate limit

### 3.7.3 Scenario Type

Error_Condition

### 3.7.4 Given

I am on the login screen

### 3.7.5 When

I request an OTP for the same phone number more than 5 times within an hour

### 3.7.6 Then

the system prevents sending another OTP and displays a message 'You have made too many requests. Please try again later.'

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Login with Phone' button or link on the main login screen.
- An input field for the user's phone number with country code selector.
- A 'Send Code' button.
- An input field for the 6-digit OTP.
- A 'Verify' or 'Login' button on the OTP screen.
- A visible countdown timer indicating OTP validity.
- A 'Resend Code' button/link.

## 4.2.0 User Interactions

- Tapping 'Login with Phone' transitions the user to the phone number entry view.
- After submitting a valid phone number, the view transitions to the OTP entry screen.
- The 'Resend Code' button is disabled for a 30-second cooldown period after an OTP is sent.

## 4.3.0 Display Requirements

- Clear error messages for invalid phone numbers, incorrect OTPs, expired OTPs, and rate limiting.
- Loading indicators while sending the code and verifying the OTP.

## 4.4.0 Accessibility Needs

- All input fields must have clear labels associated with them for screen readers.
- Buttons must have accessible names.
- Sufficient color contrast for all text and UI elements, per WCAG 2.1 AA standards (REQ-INT-001).

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-AUTH-001

### 5.1.2 Rule Description

An OTP is valid for 2 minutes from the time it is sent.

### 5.1.3 Enforcement Point

Server-side during OTP verification.

### 5.1.4 Violation Handling

The verification request is rejected with an 'expired code' error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-AUTH-002

### 5.2.2 Rule Description

A user cannot request more than 5 OTPs for a single phone number within a 60-minute window.

### 5.2.3 Enforcement Point

Server-side before sending an OTP.

### 5.2.4 Violation Handling

The OTP send request is rejected with a 'rate limit exceeded' error.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-AUTH-003

### 5.3.2 Rule Description

A user must wait 30 seconds before requesting a new OTP.

### 5.3.3 Enforcement Point

Client-side UI (disabling the 'Resend Code' button).

### 5.3.4 Violation Handling

The 'Resend Code' button is non-interactive until the cooldown period ends.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-006

#### 6.1.1.2 Dependency Reason

A user must be able to register and have an account. The registration flow must be updated to capture and verify a phone number.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-017

#### 6.1.2.2 Dependency Reason

The primary login screen UI, to which this OTP option will be added, is established in this story.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-021

#### 6.1.3.2 Dependency Reason

Defines the target destination (role-specific dashboard) after a successful login.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication: Phone Number sign-in provider must be enabled and configured for the project.
- Firebase Project Configuration: APNs Auth Key for iOS and SHA-1/SHA-256 fingerprints for Android must be correctly configured to enable phone auth.
- FlutterFire `firebase_auth` package.

## 6.3.0.0 Data Dependencies

- User profiles in Firestore must have a field to store a verified phone number.

## 6.4.0.0 External Dependencies

- Reliable SMS delivery from Firebase's underlying third-party SMS gateway providers.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- OTP SMS delivery should ideally occur within 15 seconds of the user's request.
- The server-side OTP verification response time must be less than 1 second.

## 7.2.0.0 Security

- The OTP must be a cryptographically random 6-digit number.
- All communication with Firebase services must be over TLS (as per REQ-INT-004).
- Rate limiting must be strictly enforced to prevent SMS pumping fraud and abuse.
- The system must use Firebase's built-in reCAPTCHA verification or silent push notifications to verify the request is from a legitimate app instance.

## 7.3.0.0 Usability

- The login flow should be intuitive and require minimal steps.
- Error messages must be user-friendly and actionable.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards (REQ-INT-001).

## 7.5.0.0 Compatibility

- The feature must be fully functional on supported Android (6.0+) and iOS (12.0+) versions (REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires native configuration for both iOS (APNs) and Android (SHA fingerprints) in the Firebase project.
- Building a multi-step UI flow with state management for timers, loading states, and error handling.
- End-to-end testing requires physical devices and real phone numbers.
- Cost implications of SMS messages need to be monitored.

## 8.3.0.0 Technical Risks

- SMS delivery can be unreliable or delayed depending on the carrier and region.
- Incorrect Firebase project configuration for iOS/Android can completely block the feature from working.
- Potential for SMS pumping fraud if rate limiting is not implemented correctly.

## 8.4.0.0 Integration Points

- Firebase Authentication service.
- Firestore database to query user status based on phone number.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- End-to-end login on a physical Android device.
- End-to-end login on a physical iOS device.
- Login attempt with a phone number tied to a deactivated account.
- Triggering and verifying the rate-limiting mechanism.
- Verifying the OTP expiry logic.

## 9.3.0.0 Test Data Needs

- Test accounts with known, verified phone numbers.
- At least one test account with a 'deactivated' status.
- Access to physical devices for receiving SMS.

## 9.4.0.0 Testing Tools

- Flutter Test framework for unit/widget tests.
- Firebase Local Emulator Suite for integration testing (note: phone auth has limited emulator support).
- Manual testing on physical devices is mandatory.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing on both iOS and Android physical devices.
- Code reviewed and approved by at least one other developer.
- Unit and widget tests implemented with >80% coverage for the new logic.
- End-to-end manual testing of the full login flow completed successfully.
- Firebase project configuration for phone auth is documented.
- Security requirements, especially rate limiting, are validated.
- UI/UX reviewed and approved by the Product Owner.
- Story deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- Requires dedicated time for Firebase project setup and configuration for both platforms.
- Availability of physical test devices and phone numbers is a prerequisite for starting development.
- The dependency on having a phone number field in the user profile must be resolved.

## 11.4.0.0 Release Impact

This is a major user-facing feature that enhances security and usability. It should be highlighted in release notes.

