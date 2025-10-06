# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-073 |
| Elaboration Date | 2025-01-20 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures the tenant's password policy |
| As A User Story | As an Admin, I want to configure and enforce a cus... |
| User Persona | Admin: The user responsible for managing an entire... |
| Business Value | Provides organizations with direct control over th... |
| Functional Area | Administration |
| Story Theme | Tenant Configuration Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin views and modifies the password policy

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the Admin is logged into the web dashboard and has navigated to the 'Tenant Settings' page

### 3.1.5 When

the Admin views the 'Password Policy' section

### 3.1.6 Then

the current policy settings are displayed, defaulting to the system's standard policy if never configured before.

### 3.1.7 Validation Notes

Verify the UI correctly fetches and displays the policy from the `/tenants/{tenantId}/config/{singletonDoc}` Firestore document.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin successfully saves a new password policy

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Admin is on the 'Password Policy' settings page

### 3.2.5 When

the Admin changes the minimum length to '12' and requires uppercase, lowercase, number, and special characters, and clicks 'Save'

### 3.2.6 Then

a success notification is displayed, and the new policy is written to the tenant's configuration document in Firestore.

### 3.2.7 Validation Notes

Check the Firestore document to confirm the values have been updated correctly. The UI should reflect the saved state upon page refresh.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

New user registration enforces the custom password policy

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Admin has set a policy requiring a minimum of 10 characters and at least one number

### 3.3.5 And

a new user is completing their registration via an invitation link

### 3.3.6 When

the user enters a compliant password like 'Password123!'

### 3.3.7 Then

the password is accepted, and the user's account is successfully created.

### 3.3.8 Validation Notes

This must be validated by both client-side UI feedback and a server-side Firebase Auth blocking function.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

New user registration is blocked by a non-compliant password

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

the Admin has set a policy requiring a minimum of 10 characters and at least one number

### 3.4.5 And

a new user is completing their registration

### 3.4.6 When

the user enters a non-compliant password like 'Password!'

### 3.4.7 Then

a clear validation error message is displayed (e.g., 'Password must contain at least one number'), and the account creation is blocked.

### 3.4.8 Validation Notes

The error message should be specific to the rule(s) that failed. The server-side function must prevent the user's creation.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Password reset enforces the custom password policy

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

an existing user has requested a password reset and is on the 'Set New Password' screen

### 3.5.5 And

the tenant's policy requires a special character

### 3.5.6 When

the user enters a new password without a special character, like 'NewPassword123'

### 3.5.7 Then

a validation error is shown, and the password change is rejected.

### 3.5.8 Validation Notes

Test the full 'Forgot Password' flow to ensure the policy is fetched and applied correctly at the point of reset.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin attempts to set an invalid policy configuration

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

the Admin is on the 'Password Policy' settings page

### 3.6.5 And

the system-wide minimum password length is 8

### 3.6.6 When

the Admin enters '7' for the minimum length

### 3.6.7 Then

an inline validation error is displayed, and the 'Save' button is disabled until the error is corrected.

### 3.6.8 Validation Notes

Verify that the UI prevents saving configurations that violate system-level constraints.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A dedicated 'Password Policy' card or section within the Admin web dashboard's 'Tenant Settings' page.
- A numeric input field for 'Minimum Length' with clear validation.
- A set of checkboxes for complexity requirements: 'Require uppercase letter (A-Z)', 'Require lowercase letter (a-z)', 'Require number (0-9)', 'Require special character (e.g., !@#$%)'.
- A primary 'Save Changes' button, which is disabled by default.
- A secondary 'Reset to Default' button to revert to the system's standard policy.

## 4.2.0 User Interactions

- The 'Save Changes' button becomes enabled only when a value in the form is modified.
- Upon a successful save, a non-intrusive success message (e.g., a toast notification) should appear.
- If the save fails, an error message should be displayed with information about the failure.
- Help tooltips next to each option explaining the requirement.

## 4.3.0 Display Requirements

- The form must always display the currently active policy for the tenant.
- Validation messages for password creation/reset must clearly state which rules were not met.

## 4.4.0 Accessibility Needs

- All form inputs must have associated labels for screen readers (WCAG 2.1 AA).
- All interactive elements (buttons, inputs, checkboxes) must be keyboard accessible and have visible focus states.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A system-wide minimum password length of 8 characters must be enforced. Admins can set a higher minimum but not a lower one.

### 5.1.3 Enforcement Point

UI validation on the Admin dashboard and server-side validation when saving the configuration.

### 5.1.4 Violation Handling

The UI will display a validation error and prevent the form from being saved.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Password policies are not applied retroactively. Existing users are not forced to change their passwords when a policy is updated.

### 5.2.3 Enforcement Point

The policy is only checked during new user creation and password reset events.

### 5.2.4 Violation Handling

N/A - This is a rule of non-action.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant must exist to have a configuration associated with it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

The Admin must be able to log in and access a role-specific dashboard where the settings page will reside.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-069

#### 6.1.3.2 Dependency Reason

This story likely establishes the 'Tenant Settings' page in the Admin dashboard, which will host the password policy UI.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication: Requires implementation of a `beforeCreate` Auth blocking Cloud Function to enforce the policy server-side.
- Firestore: Requires the data model for storing tenant configuration (`/tenants/{tenantId}/config/{singletonDoc}`).
- Flutter for Web: The UI will be built using this framework for the Admin dashboard.

## 6.3.0.0 Data Dependencies

- The client application (during registration/password reset) needs to fetch the specific password policy for the user's tenant.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The tenant's password policy must be fetched by the client in under 500ms.
- The server-side validation in the Auth blocking function must add no more than 200ms of latency to the user creation process.

## 7.2.0.0 Security

- The tenant configuration document in Firestore must be protected by security rules, allowing write access only to users with the 'Admin' role for that tenant.
- Password policy validation MUST be performed server-side (e.g., Auth blocking function) in addition to client-side to prevent circumvention.

## 7.3.0.0 Usability

- Error messages for non-compliant passwords must be clear, specific, and user-friendly.
- The configuration interface for the Admin must be intuitive and unambiguous.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin dashboard UI must function correctly on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The primary complexity is implementing the server-side enforcement logic, as Firebase Authentication does not support per-tenant password policies natively. This requires a custom Cloud Function (Auth blocking function).
- Coordinating client-side validation logic in the Flutter app with the server-side enforcement to provide a seamless user experience.
- Ensuring the client app correctly fetches the appropriate tenant policy during the registration flow for an invited user.

## 8.3.0.0 Technical Risks

- Misconfiguration of the Auth blocking function could potentially block all new user registrations. Thorough testing in a staging environment is critical.
- Latency added by the blocking function could impact the user registration experience if the Firestore read is slow.

## 8.4.0.0 Integration Points

- Firebase Authentication (User creation and password reset triggers).
- Firestore (Reading the tenant's policy configuration).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Admin sets and saves a new policy.
- Admin resets the policy to default.
- New user registration with a compliant password.
- New user registration with a non-compliant password (test each rule individually).
- Existing user password reset with a compliant password.
- Existing user password reset with a non-compliant password.
- Attempt to save an invalid policy (e.g., length < 8).
- Verify a non-Admin user cannot access the policy settings page.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user.
- Test user accounts for registration and password reset flows.
- A set of passwords that test the boundaries of each complexity rule.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local testing of Firestore and Auth Functions.
- `flutter_test` for widget tests.
- `integration_test` for E2E tests.
- `Jest` for testing the TypeScript Cloud Function.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for both UI logic and the password validation function, with >80% coverage
- Integration testing completed for the Admin UI -> Firestore -> Auth Function flow
- User interface reviewed and approved by the Product Owner
- Security requirements validated, including Firestore rules and server-side enforcement
- Documentation for the feature is created in the Admin user guide
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

8

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story requires both frontend (Flutter Web) and backend (TypeScript Cloud Function) development, which may require pairing or careful task breakdown.
- The Firebase Auth blocking function is a critical piece of infrastructure; its implementation should be prioritized early in the sprint.

## 11.4.0.0 Release Impact

This is a significant security feature, highly desirable for enterprise customers and for achieving compliance certifications. It should be included in a major feature release.

