# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-004 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin invites a new user to the organization via e... |
| As A User Story | As an Admin, I want to invite new employees to the... |
| User Persona | Admin: A user with full administrative privileges ... |
| Business Value | Enables the onboarding of new employees into the s... |
| Functional Area | User Management |
| Story Theme | Tenant and User Administration |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful invitation of a new user

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and I am on the 'Manage Users' page

### 3.1.5 When

I enter a valid and unique email address 'new.user@example.com', select the role 'Subordinate', and click 'Send Invitation'

### 3.1.6 Then

I see a success notification message: 'Invitation sent successfully to new.user@example.com'.

### 3.1.7 And

A transactional email is triggered via the SendGrid service to 'new.user@example.com' containing a unique, 24-hour time-limited registration link.

### 3.1.8 Validation Notes

Verify the user document creation in Firestore using the emulator or live database. Verify the email sending function was called with the correct parameters. Manual verification of email receipt in a test inbox.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Attempting to invite a user who already exists in the tenant

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am an Admin logged in, and a user with the email 'existing.user@example.com' already exists in my tenant (with status 'active' or 'invited')

### 3.2.5 When

I attempt to invite a new user with the email 'existing.user@example.com'

### 3.2.6 Then

The form submission is blocked and I see an inline error message: 'A user with this email already exists in your organization.'

### 3.2.7 And

No new user document is created and no invitation email is sent.

### 3.2.8 Validation Notes

Requires a pre-existing user in the test database. Verify that no new records are created and no email function is triggered.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Attempting to invite a user with an invalid email format

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am an Admin on the 'Invite User' form

### 3.3.5 When

I enter 'not-an-email' in the email address field and click 'Send Invitation'

### 3.3.6 Then

The form submission is blocked and I see an inline validation error message: 'Please enter a valid email address.'

### 3.3.7 And

No backend request is made.

### 3.3.8 Validation Notes

This is a client-side validation test. Verify the UI displays the error and the network tab shows no API call.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Attempting to send an invitation without selecting a role

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am an Admin on the 'Invite User' form

### 3.4.5 When

I enter a valid email but do not select a role from the dropdown and click 'Send Invitation'

### 3.4.6 Then

The form submission is blocked and I see an inline validation error message: 'Please select a role for the user.'

### 3.4.7 Validation Notes

Client-side validation test. Verify the UI displays the error.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Email sending service fails

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am an Admin on the 'Invite User' form and the external email service (SendGrid) is unavailable

### 3.5.5 When

I submit a valid invitation

### 3.5.6 Then

A user document is still created in Firestore with the status 'invited'.

### 3.5.7 And

The system logs the email service failure for administrative review.

### 3.5.8 Validation Notes

Requires mocking the SendGrid API to return an error. Verify the user record is created and the UI shows the specific error. Check server-side logs for the failure entry.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- An 'Invite User' button on the main user management screen of the Admin web dashboard.
- A modal or dedicated form for the invitation.
- A text input field for 'Email Address' with a placeholder.
- A dropdown/select menu for 'Role' with options 'Supervisor' and 'Subordinate'.
- A 'Send Invitation' primary action button.
- A 'Cancel' secondary action button or close icon for the modal.

## 4.2.0 User Interactions

- The 'Send Invitation' button should be disabled until a validly formatted email is entered and a role is selected.
- The system must provide immediate visual feedback upon form submission (e.g., loading spinner).
- The system must display clear, non-disruptive success (toast/snackbar) or error (inline form message) notifications.

## 4.3.0 Display Requirements

- After a successful invitation, the new user should appear in the user list with a status of 'Invited'.

## 4.4.0 Accessibility Needs

- All form fields must have associated `<label>` tags.
- The form must be navigable and submittable using only a keyboard.
- Error messages must be programmatically associated with their respective form fields for screen reader users.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-INV-001

### 5.1.2 Rule Description

An invitation link must expire 24 hours after it is generated.

### 5.1.3 Enforcement Point

Backend (Cloud Function) during the user registration/activation step (covered in US-006).

### 5.1.4 Violation Handling

The user is shown a message indicating the link has expired and is prompted to request a new one.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-INV-002

### 5.2.2 Rule Description

A user's email address must be globally unique across all tenants.

### 5.2.3 Enforcement Point

Backend (Cloud Function) during the invitation creation process.

### 5.2.4 Violation Handling

The Admin is shown an error message: 'This email address is already registered with another organization.'

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-001', 'dependency_reason': 'An Admin and a tenant must exist before an invitation can be sent.'}

## 6.2.0 Technical Dependencies

- Firebase Authentication for user identity.
- Firestore for storing user records.
- Firebase Cloud Functions for backend logic.
- Configured Firebase Extension for SendGrid for sending transactional emails (as per REQ-FUN-002).

## 6.3.0 Data Dependencies

- The `tenantId` of the currently authenticated Admin user is required to correctly scope the invitation.

## 6.4.0 External Dependencies

- Availability of the SendGrid API for email delivery.

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The API call to create the invitation should have a p95 response time of less than 500ms.

## 7.2.0 Security

- The invitation process must be restricted to users with the 'Admin' role, enforced by Firestore Security Rules and Cloud Function logic.
- The generated invitation link must use a cryptographically secure, unpredictable token.
- All communication between the client and backend must be over HTTPS.

## 7.3.0 Usability

- The invitation process should be intuitive, requiring minimal steps and clear instructions.

## 7.4.0 Accessibility

- The invitation form must comply with WCAG 2.1 Level AA standards.

## 7.5.0 Compatibility

- The Admin web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Medium

## 8.2.0 Complexity Factors

- Requires both frontend (Flutter Web UI) and backend (Cloud Function) development.
- Integration with an external service (SendGrid).
- Implementation of a secure token generation and validation mechanism.
- Requires careful design of Firestore Security Rules to allow Admins to create users within their tenant.

## 8.3.0 Technical Risks

- Potential for email delivery issues (e.g., emails being marked as spam).
- Ensuring the security and uniqueness of invitation tokens.

## 8.4.0 Integration Points

- Firestore: Write a new user document.
- Cloud Functions: A callable function to orchestrate the invitation logic.
- SendGrid API: To dispatch the invitation email.

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0 Test Scenarios

- Verify successful invitation flow.
- Verify error handling for duplicate emails (within tenant and globally).
- Verify client-side validation for invalid email format and missing role.
- Verify system behavior when the email service API fails.
- Verify the created user record in Firestore has the correct data and status.

## 9.3.0 Test Data Needs

- An existing Admin user account for testing.
- A set of new, unused email addresses for testing invitations.
- An email address that is pre-populated in the database to test the duplicate user scenario.

## 9.4.0 Testing Tools

- Flutter Test Framework for widget tests.
- Jest for Cloud Function unit tests.
- Firebase Local Emulator Suite for integration testing of UI, Functions, and Firestore.
- A test email service like MailHog or a dedicated SendGrid test account.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for form validation logic and Cloud Function logic, achieving >80% coverage
- Integration testing completed successfully using the Firebase Emulator Suite
- User interface on the web dashboard is implemented as per requirements and has been reviewed
- Security requirements for role-based access and token generation are validated
- Documentation for the invitation Cloud Function is created
- Story deployed and verified in the staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

5

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This is a foundational feature for user management and a blocker for user activation (US-006). It should be prioritized in an early sprint after Admin registration (US-001) is complete.
- Requires coordination between frontend and backend development efforts.

## 11.4.0 Release Impact

- This feature is critical for the Minimum Viable Product (MVP) as it enables multi-user organizations.

