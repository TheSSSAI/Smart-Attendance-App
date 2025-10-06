# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-020 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User resets their forgotten password |
| As A User Story | As a registered user, I want to request a password... |
| User Persona | Any registered and active user of the system (Admi... |
| Business Value | Provides a critical self-service mechanism for acc... |
| Functional Area | Authentication and User Management |
| Story Theme | User Account Security |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: User successfully requests a password reset link

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am on the application's login screen

### 3.1.5 When

I click the 'Forgot Password?' link, enter my valid and registered email address, and submit the form

### 3.1.6 Then

I should see a confirmation message stating, 'If an account with that email exists, a password reset link has been sent.'

### 3.1.7 Validation Notes

Verify that the Firebase Authentication `sendPasswordResetEmail` function is called and the UI displays the generic confirmation message.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Happy Path: User successfully resets their password using the link

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I have received a password reset email and clicked the valid, unexpired link

### 3.2.5 When

I enter a new password that meets the organization's complexity policy, confirm it correctly, and submit the form

### 3.2.6 Then

My password should be updated, and I should see a success message confirming the change, with a link to the login page.

### 3.2.7 Validation Notes

Verify the user's password is changed in Firebase Authentication. The old password should no longer work.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Happy Path: User logs in with the new password

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I have successfully reset my password

### 3.3.5 When

I navigate to the login screen and enter my email and my new password

### 3.3.6 Then

I should be successfully authenticated and redirected to my role-specific dashboard.

### 3.3.7 Validation Notes

Perform a full login flow with the newly set credentials.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Error Condition: User enters an unregistered email address

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am on the password reset request screen

### 3.4.5 When

I enter an email address that is not associated with any user in the system and submit

### 3.4.6 Then

I should see the exact same generic confirmation message as the happy path ('If an account with that email exists...') to prevent email enumeration.

### 3.4.7 Validation Notes

Verify that no email is sent and the UI response is indistinguishable from a successful request.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Error Condition: User enters a password that does not meet complexity requirements

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

I am on the password reset page after clicking the link in the email

### 3.5.5 When

I enter a new password that violates the tenant's configured password policy (e.g., too short, missing a number)

### 3.5.6 Then

I should see a clear, inline error message detailing the password requirements, and the form submission should be blocked.

### 3.5.7 Validation Notes

Test against the rules defined in REQ-CON-001 and Business Rule 2.6.3 (min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char).

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Error Condition: User's new password and confirmation do not match

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

I am on the password reset page

### 3.6.5 When

I enter a new password and a different confirmation password

### 3.6.6 Then

I should see a clear, inline error message stating 'Passwords do not match', and the form submission should be blocked.

### 3.6.7 Validation Notes

Check that client-side validation prevents the form from being submitted.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Edge Case: User tries to use an expired password reset link

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

I have a password reset link that is older than the configured expiration time (e.g., 1 hour)

### 3.7.5 When

I click the expired link

### 3.7.6 Then

I should be directed to a page that informs me the link is expired or invalid and provides an option to request a new one.

### 3.7.7 Validation Notes

Firebase Auth links expire by default. This test requires waiting for the expiration period or using emulator tools to simulate it.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

Edge Case: User tries to reuse a password reset link

### 3.8.3 Scenario Type

Edge_Case

### 3.8.4 Given

I have successfully used a password reset link to change my password

### 3.8.5 When

I click the same link again

### 3.8.6 Then

I should be directed to a page that informs me the link is expired or invalid.

### 3.8.7 Validation Notes

Firebase Auth links are single-use. Verify that a second attempt to use the link fails.

## 3.9.0 Criteria Id

### 3.9.1 Criteria Id

AC-009

### 3.9.2 Scenario

Edge Case: A deactivated user attempts to reset their password

### 3.9.3 Scenario Type

Edge_Case

### 3.9.4 Given

My user account status is 'deactivated'

### 3.9.5 When

I enter my email address on the password reset request screen and submit

### 3.9.6 Then

I should see the generic confirmation message, but no email should be sent.

### 3.9.7 Validation Notes

This maintains the anti-enumeration security posture. Verify in the backend or email service logs that no email was triggered for the deactivated user's address.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Forgot Password?' text link on the main login screen.
- A dedicated screen for requesting the reset link with an email input field and a 'Send Link' button.
- A dedicated screen for setting the new password with 'New Password' and 'Confirm New Password' input fields and a 'Reset Password' button.
- Toast/Snackbar or on-page text for confirmation and success messages.
- Inline error message components for form validation.

## 4.2.0 User Interactions

- Clicking 'Forgot Password?' navigates to the request screen.
- Password fields must have a visibility toggle icon.
- The 'Reset Password' button should be disabled until both password fields are populated and meet minimum length.
- After successful reset, the user should be presented with a clear call-to-action button to return to the login screen.

## 4.3.0 Display Requirements

- The password policy requirements must be clearly displayed on the password reset screen.
- Confirmation messages must be non-specific to prevent leaking information about registered emails.

## 4.4.0 Accessibility Needs

- All input fields must have associated labels for screen readers.
- Error messages must be programmatically linked to their corresponding input fields.
- All UI elements must meet WCAG 2.1 AA contrast ratio standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

The new password must comply with the tenant's configured password policy (Ref: Business Rule 2.6.3).

### 5.1.3 Enforcement Point

Client-side validation on the password reset form and server-side by Firebase Authentication.

### 5.1.4 Violation Handling

Display a descriptive error message to the user and block the password change.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Password reset links must be single-use and time-limited.

### 5.2.3 Enforcement Point

Server-side (Firebase Authentication).

### 5.2.4 Violation Handling

User is shown an 'invalid or expired link' error page.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

The system must not confirm or deny the existence of a user account based on an email address during the reset request process.

### 5.3.3 Enforcement Point

Frontend UI and backend logic.

### 5.3.4 Violation Handling

A generic success message is always displayed, regardless of whether the email exists or is active.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

Requires the login screen to exist to place the 'Forgot Password?' link.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-073

#### 6.1.2.2 Dependency Reason

Requires the tenant-specific password policy to be defined and accessible to enforce complexity rules during reset.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication SDK for handling the password reset flow.
- Configured transactional email provider (e.g., SendGrid via Firebase Extension) to send the reset email.

## 6.3.0.0 Data Dependencies

- User records must exist in Firebase Authentication.
- Tenant configuration document in Firestore containing the password policy.

## 6.4.0.0 External Dependencies

- The transactional email service (SendGrid) must be operational.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The password reset email should be delivered to the user's inbox within 30 seconds of the request.
- The password reset page (from the email link) must load in under 3 seconds.

## 7.2.0.0 Security

- The entire flow must be protected against user/email enumeration attacks.
- All communication must occur over HTTPS/TLS.
- The reset token must be securely generated, time-limited, and single-use.
- A successful password reset event should be logged in the system's audit trail for security monitoring.

## 7.3.0.0 Usability

- The process should be intuitive and require minimal steps for the user.
- Error messages must be clear, concise, and helpful.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The password reset page must render correctly on all supported mobile and web browsers (as per REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Leverages standard, out-of-the-box functionality from Firebase Authentication.
- Effort is primarily in creating the frontend UI screens and state management for the flow.
- Requires careful handling of deep links from the email to the application.

## 8.3.0.0 Technical Risks

- Email deliverability issues (e.g., emails being marked as spam) could disrupt the user flow. Requires proper domain/sender configuration in the email service.
- Incorrect configuration of deep linking/dynamic links for mobile could prevent the link from opening the app correctly.

## 8.4.0.0 Integration Points

- Firebase Authentication API (`sendPasswordResetEmail`, `confirmPasswordReset`).
- Flutter frontend UI.
- Firestore for retrieving tenant-specific password policy.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Full happy path from request to successful login with new password.
- Attempting reset with an unregistered email.
- Attempting reset for a deactivated account.
- Submitting a new password that fails policy validation.
- Submitting mismatched passwords.
- Using an expired or already-used link.

## 9.3.0.0 Test Data Needs

- An active test user account with a known email.
- A deactivated test user account.
- A list of email addresses that are not registered in the system.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite to test Auth triggers and inspect emails without actual sending.
- Flutter Driver or `integration_test` package for E2E testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >80% coverage for new logic
- End-to-end integration test for the full flow is implemented and passing
- User interface reviewed and approved by a UX/UI designer
- Security check for email enumeration vulnerability has been performed and passed
- Documentation for the password reset flow is updated in the knowledge base
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational feature required for the first release.
- The email sending service must be configured and tested before this story can be completed.
- Dependent on the completion of the password policy configuration story (US-073).

## 11.4.0.0 Release Impact

Blocks initial user onboarding and launch if not completed. Critical path item.

