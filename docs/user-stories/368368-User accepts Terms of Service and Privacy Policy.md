# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-026 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User accepts Terms of Service and Privacy Policy |
| As A User Story | As a new user completing my registration, I want t... |
| User Persona | A new user who has been invited to the platform an... |
| Business Value | Ensures legal and regulatory compliance (e.g., GDP... |
| Functional Area | User Onboarding and Authentication |
| Story Theme | User Account Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: User reviews and accepts policies

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A new user has successfully set their password and is presented with the 'Terms and Policy Acceptance' screen

### 3.1.5 When

The user checks the box to indicate acceptance of the policies AND clicks the 'Accept & Continue' button

### 3.1.6 Then

The system updates the user's status from 'invited' to 'active' in Firestore, an immutable audit log of the acceptance is created with the user ID, timestamp, and policy versions, AND the user is redirected to their role-specific dashboard.

### 3.1.7 Validation Notes

Verify the user document's 'status' field in Firestore. Verify a new document exists in the 'auditLog' collection for this action. Verify the user lands on the correct dashboard screen.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: User attempts to continue without accepting

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

A new user is on the 'Terms and Policy Acceptance' screen

### 3.2.5 And

The acceptance checkbox is not checked

### 3.2.6 When

The user attempts to click the 'Accept & Continue' button

### 3.2.7 Then

The button must be in a disabled state and no action is performed.

### 3.2.8 Validation Notes

Visually inspect the button's state. Confirm no navigation or database write occurs on tap.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Alternative Flow: User views the policy documents

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

A new user is on the 'Terms and Policy Acceptance' screen

### 3.3.5 When

The user clicks the hyperlink for the 'Terms of Service' or 'Privacy Policy'

### 3.3.6 Then

The corresponding document is displayed in an in-app browser view, allowing the user to read it without leaving the application flow.

### 3.3.7 Validation Notes

Confirm that clicking the link opens a web view and that closing it returns the user to the acceptance screen.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Edge Case: User closes the app before accepting

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

A new user is on the 'Terms and Policy Acceptance' screen and closes the application

### 3.4.5 When

The user re-opens the app and logs in with their newly created credentials

### 3.4.6 Then

The system must redirect them back to the 'Terms and Policy Acceptance' screen because their account status is still 'invited'.

### 3.4.7 Validation Notes

Check the application's routing logic for users with an 'invited' status upon login.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Error Condition: Network failure on submission

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A new user has checked the acceptance box and clicks 'Accept & Continue'

### 3.5.5 When

The application fails to communicate with the backend due to a network error

### 3.5.6 Then

A user-friendly error message is displayed (e.g., 'Failed to save. Please check your connection and try again.'), the user remains on the acceptance screen, AND their account status remains 'invited'.

### 3.5.7 Validation Notes

Simulate a network failure and verify the UI feedback and the unchanged state in Firestore.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A clear screen title (e.g., 'Review and Accept')
- Hyperlinks to 'Terms of Service' and 'Privacy Policy' documents
- A checkbox with a label like 'I have read and agree to the Terms of Service and Privacy Policy.'
- A primary action button labeled 'Accept & Continue'

## 4.2.0 User Interactions

- The 'Accept & Continue' button must be disabled by default.
- The button must become enabled only after the user checks the acceptance box.
- Tapping the policy links must open the documents in an in-app view.

## 4.3.0 Display Requirements

- The screen must be presented as a mandatory step in the registration flow after password creation and before accessing the main app.

## 4.4.0 Accessibility Needs

- The screen must comply with WCAG 2.1 Level AA standards (REQ-INT-001).
- The checkbox must have a proper content description for screen readers.
- Links must be clearly identifiable and navigable using accessibility tools.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A user's account cannot be activated (status changed from 'invited' to 'active') until they have explicitly accepted the current versions of the Terms of Service and Privacy Policy.

### 5.1.3 Enforcement Point

During the final step of the user registration workflow.

### 5.1.4 Violation Handling

The user is prevented from accessing any part of the application beyond the registration/acceptance flow.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Each acceptance event must be recorded immutably in the audit log, capturing the user ID, a server-side timestamp, and the specific versions of the policies that were accepted.

### 5.2.3 Enforcement Point

Server-side (Cloud Function) upon receiving the acceptance request from the client.

### 5.2.4 Violation Handling

If the audit log cannot be written, the entire transaction to activate the user must fail to ensure data integrity.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-006

#### 6.1.1.2 Dependency Reason

This acceptance step occurs immediately after a new user sets their password for the first time.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

This story's successful completion triggers the navigation to the role-specific dashboard defined in US-021.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user session management.
- Firestore database for updating user status and writing to the audit log.
- A content delivery mechanism (e.g., Firebase Hosting) to host the static HTML/text files for the ToS and Privacy Policy.
- An in-app browser package for Flutter (e.g., webview_flutter) to display the policies.

## 6.3.0.0 Data Dependencies

- A user record must exist in Firestore with a status of 'invited'.
- URLs for the current versions of the Terms of Service and Privacy Policy must be available to the application (e.g., from a remote config or hardcoded).

## 6.4.0.0 External Dependencies

- The legal text for the Terms of Service and Privacy Policy must be provided and approved by the legal/business stakeholders.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The transition from the acceptance screen to the main dashboard upon successful submission should complete in under 1 second on a stable connection.

## 7.2.0.0 Security

- The acceptance action must be logged in the immutable `auditLog` collection as per REQ-DAT-001.
- The update to the user's status and the creation of the audit log entry should be performed in a single atomic transaction on the backend to prevent inconsistent states.

## 7.3.0.0 Usability

- The purpose of the screen and the required action must be immediately obvious to the user.
- Users should not be forced to leave the application to view the legal documents.

## 7.4.0.0 Accessibility

- Must meet WCAG 2.1 Level AA standards as defined in REQ-INT-001.

## 7.5.0.0 Compatibility

- The screen must render correctly on all supported iOS and Android versions (REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Standard UI form with simple state management.
- Requires a single, atomic backend write operation.
- Requires configuration of URLs for policy documents.

## 8.3.0.0 Technical Risks

- The legal documents (ToS/PP) may change in the future, requiring a mechanism to re-prompt existing users for acceptance. This story only covers the initial acceptance.

## 8.4.0.0 Integration Points

- Integrates with the application's main navigation/routing logic to act as a gatekeeper for un-activated users.
- Integrates with Firestore to update the `users` collection and write to the `auditLog` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify successful acceptance and redirection.
- Verify button is disabled until checkbox is ticked.
- Verify user is blocked from proceeding without acceptance.
- Verify policy links open correctly.
- Verify login flow for a user who has not yet accepted the terms.
- Verify database state changes correctly after acceptance.

## 9.3.0.0 Test Data Needs

- A test user account in the 'invited' state.
- Dummy URLs for ToS and Privacy Policy documents for testing environments.

## 9.4.0.0 Testing Tools

- flutter_test for unit/widget tests.
- integration_test for E2E testing.
- Firebase Local Emulator Suite to test Firestore rules and function triggers without live data.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for the new code
- Integration testing completed successfully, verifying Firestore updates
- User interface reviewed and approved for UX and accessibility compliance
- Security requirement for atomic, audited writes is validated
- Documentation for the onboarding flow is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a blocking story for any user to be able to use the application. It is a critical part of the initial release.
- The final legal text for the policies is required before this story can be completed and merged.

## 11.4.0.0 Release Impact

This feature is mandatory for the first public release due to legal and compliance requirements.

