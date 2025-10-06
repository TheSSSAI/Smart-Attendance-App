# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-007 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Invited user is notified when a registration link ... |
| As A User Story | As an invited user who has clicked on an old invit... |
| User Persona | Invited User (A person who has received an email i... |
| Business Value | Improves the user onboarding experience by providi... |
| Functional Area | User Management & Onboarding |
| Story Theme | Tenant and User Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

User clicks on an invitation link that has expired

### 3.1.3 Scenario Type

Error_Condition

### 3.1.4 Given

An Admin has sent a user an invitation link which has a 24-hour validity period (as per REQ-FUN-002)

### 3.1.5 When

The user clicks the invitation link more than 24 hours after it was generated

### 3.1.6 Then

The system must display a dedicated 'Invitation Link Expired' page.

### 3.1.7 Validation Notes

Verify by creating an invitation, waiting for it to expire (or manually setting the expiry timestamp in the database for testing), and accessing the link. The page must show the correct messaging.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Expired link page displays clear and helpful information

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

The user is on the 'Invitation Link Expired' page

### 3.2.5 When

The page loads

### 3.2.6 Then

The page must display a clear heading, such as 'Invitation Expired'.

### 3.2.7 Validation Notes

Check for the presence and content of the heading, explanatory text, and next-step instructions on the rendered page.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Expired link page provides actionable next steps

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

The user is on the 'Invitation Link Expired' page

### 3.3.5 When

The user reads the content

### 3.3.6 Then

The page must include text explaining that links expire for security and instruct the user to contact their administrator to request a new invitation.

### 3.3.7 Validation Notes

Confirm the instructional text is present and unambiguous.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User clicks on an invalid or malformed invitation link

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

A user has a URL with an invitation token that does not exist in the system

### 3.4.5 When

The user attempts to access the URL

### 3.4.6 Then

The system should display a generic 'Invalid Link' page, distinct from the 'Expired Link' page, instructing them to check the link or contact their administrator.

### 3.4.7 Validation Notes

Test by navigating to a registration URL with a fake or deleted token.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

An already active user clicks their old invitation link

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

A user has already completed their registration and their account status is 'active'

### 3.5.5 When

The user clicks on their original (now used) invitation link

### 3.5.6 Then

The system should display a page informing them that their account is already active and provide a link to the main login page.

### 3.5.7 Validation Notes

Test by completing a registration, then re-visiting the invitation link used for that registration.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A dedicated, full-screen page for displaying the expired link message.
- A prominent heading element.
- A paragraph element for the explanatory text.
- An optional link/button to the main login page.

## 4.2.0 User Interactions

- The user's only interaction is to read the information and close the browser tab or navigate to the login page if a link is provided.

## 4.3.0 Display Requirements

- The page must be unauthenticated and publicly accessible.
- The page must be visually consistent with the application's branding (logo, colors, typography).
- The error message must be user-friendly and avoid technical jargon.

## 4.4.0 Accessibility Needs

- The page must comply with WCAG 2.1 Level AA standards.
- Text must have a contrast ratio of at least 4.5:1.
- All content must be readable by screen readers.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'User invitation links expire after 24 hours.', 'enforcement_point': 'Server-side (Cloud Function) when a user accesses the invitation URL.', 'violation_handling': "The user is redirected to the 'Invitation Link Expired' page."}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-004

#### 6.1.1.2 Dependency Reason

The system must be able to generate and store user invitations before it can handle their expiration.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-005

#### 6.1.2.2 Dependency Reason

The system must be able to send an email with a registration link before a user can click on an expired one.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user state management.
- Firestore for storing invitation tokens and their expiry timestamps.
- Firebase Cloud Function to handle the server-side validation of the invitation token.
- Flutter for Web to render the informational pages (Expired, Invalid, Already Active).

## 6.3.0.0 Data Dependencies

- Requires an 'invitations' collection in Firestore containing documents with a unique token, user email, status, and an expiry timestamp.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The token validation and redirection by the Cloud Function should complete in under 500ms (p95).
- The 'Link Expired' page should achieve a Largest Contentful Paint (LCP) of under 2.5 seconds.

## 7.2.0.0 Security

- Token validation must occur exclusively on the server-side to prevent tampering.
- The expired/invalid link page must not expose any personally identifiable information (PII) such as the user's email address.
- Invitation tokens must be cryptographically secure and unique.

## 7.3.0.0 Usability

- The message must be immediately understandable to a non-technical user.
- The next step for the user must be clear and unambiguous.

## 7.4.0.0 Accessibility

- Must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The informational page must render correctly on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a combination of backend (Cloud Function) and frontend (Flutter Web) development.
- Configuration of Firebase Hosting rewrite rules to direct the registration URL path to the Cloud Function for pre-processing is a critical and potentially complex step.
- Requires careful state management for the invitation token (e.g., invited, used, expired).

## 8.3.0.0 Technical Risks

- Incorrect configuration of Firebase Hosting rewrites could lead to the Flutter app loading before the token is validated, causing a poor user experience or errors.
- Timezone issues when comparing the expiry timestamp with the server's current time must be handled carefully.

## 8.4.0.0 Integration Points

- Firebase Hosting -> Firebase Cloud Functions (for URL handling).
- Firebase Cloud Functions -> Firestore (for token validation).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Verify the correct page is shown for an expired token.
- Verify the correct page is shown for a completely invalid token.
- Verify the correct page is shown for a token that has already been used to activate an account.
- Verify a valid, non-expired token correctly proceeds to the registration page (negative test for this story).

## 9.3.0.0 Test Data Needs

- A test user invitation with a future expiry timestamp.
- A test user invitation with a past expiry timestamp.
- An invalid token string that does not exist in the database.
- A test user who is already in an 'active' state.

## 9.4.0.0 Testing Tools

- Jest for Cloud Function unit tests.
- flutter_test for Flutter widget tests.
- Firebase Local Emulator Suite for local integration testing.
- A browser automation tool like `integration_test` for E2E testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for the Cloud Function validation logic are implemented with >80% coverage and passing
- Widget tests for the Flutter informational pages are implemented and passing
- Integration testing between Hosting, Cloud Function, and Firestore is completed successfully
- User interface reviewed and approved for clarity and branding consistency
- Security requirements validated, ensuring no PII is leaked
- Documentation for the invitation flow is updated to include this error state
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a critical part of the user invitation workflow and should be prioritized with the main registration stories (US-004, US-005, US-006) to provide a complete and robust onboarding experience.

## 11.4.0.0 Release Impact

- Essential for the initial public release. Launching without this feature would create a frustrating dead-end for users with expired links, leading to a poor first impression and increased support load.

