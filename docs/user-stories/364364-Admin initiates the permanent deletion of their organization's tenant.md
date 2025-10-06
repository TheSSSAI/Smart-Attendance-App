# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-022 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin initiates the permanent deletion of their or... |
| As A User Story | As an Admin, I want to initiate the permanent dele... |
| User Persona | Admin: The primary administrator of an organizatio... |
| Business Value | Provides a self-service offboarding capability, en... |
| Functional Area | Tenant Administration |
| Story Theme | Tenant Lifecycle Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Admin successfully initiates tenant deletion

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin is logged into the web dashboard and has navigated to the 'Tenant Settings' page

### 3.1.5 When

the Admin clicks the 'Delete Organization' button, confirms their intent in the warning modal, and successfully re-authenticates by entering their correct password

### 3.1.6 Then

the system updates the tenant's document in Firestore to include a status of 'pending_deletion' and a 'scheduledDeletionTimestamp' set to 30 days in the future, a success message is displayed confirming the action, and an entry is created in the immutable audit log for this action.

### 3.1.7 Validation Notes

Verify the tenant document in Firestore has the new status and timestamp. Check the audit log for a 'TENANT_DELETION_REQUESTED' entry. The UI should show a persistent banner indicating the pending deletion status.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Admin enters incorrect password during re-authentication

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

an Admin has initiated the tenant deletion process and is prompted to re-authenticate

### 3.2.5 When

the Admin enters an incorrect password and confirms

### 3.2.6 Then

the system displays an 'Invalid password' error message, the deletion process is aborted, and the tenant's status remains unchanged.

### 3.2.7 Validation Notes

Verify that no changes are made to the tenant document in Firestore and no audit log entry for deletion is created.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Alternative Flow: Admin cancels the deletion process from the confirmation modal

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

an Admin has clicked the 'Delete Organization' button and the confirmation modal is displayed

### 3.3.5 When

the Admin clicks the 'Cancel' button or closes the modal

### 3.3.6 Then

the modal is dismissed, the deletion process is aborted, and the system returns to the 'Tenant Settings' page with no changes made.

### 3.3.7 Validation Notes

Confirm that the application state is unchanged and no backend calls to modify the tenant status were made.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

UI displays clear warnings about the irreversible action

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

an Admin has clicked the 'Delete Organization' button

### 3.4.5 When

the confirmation modal is displayed

### 3.4.6 Then

the modal must explicitly state that the action is irreversible after the grace period, mention the 30-day grace period, and specify that all data (users, teams, attendance, etc.) will be permanently deleted.

### 3.4.7 Validation Notes

Review the modal's text content for clarity, accuracy, and prominence of the warning.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Delete Organization' button within a 'Danger Zone' or 'Advanced Settings' section of the Admin web dashboard.
- A confirmation modal with a clear title (e.g., 'Permanently Delete Organization?').
- A password input field within the modal for re-authentication.
- A final confirmation button (e.g., 'I understand, delete my organization') that is initially disabled until the password is entered.
- A 'Cancel' button in the modal.

## 4.2.0 User Interactions

- Clicking 'Delete Organization' opens the confirmation modal.
- The final confirmation button requires a valid password to be enabled.
- Successful initiation displays a non-dismissible banner on the dashboard indicating the pending deletion status and the option to cancel.

## 4.3.0 Display Requirements

- The confirmation modal must display the name of the organization to be deleted to prevent errors.
- The success message must clearly state the 30-day grace period duration.

## 4.4.0 Accessibility Needs

- The modal must be keyboard navigable.
- Warning text must have sufficient color contrast.
- All interactive elements must have accessible labels for screen readers.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Tenant deletion must be confirmed by re-authenticating the Admin user.

### 5.1.3 Enforcement Point

Server-side (Cloud Function) before changing the tenant status.

### 5.1.4 Violation Handling

The request is rejected with an authentication error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The tenant deletion process includes a mandatory 30-day grace period during which the action can be reversed.

### 5.2.3 Enforcement Point

The backend logic sets a 'scheduledDeletionTimestamp' 30 days from the request time.

### 5.2.4 Violation Handling

N/A - System rule.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant must exist before it can be deleted.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-017

#### 6.1.2.2 Dependency Reason

Admin must be able to log in to access the dashboard.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-023

#### 6.1.3.2 Dependency Reason

This story implements the re-authentication flow required by this story's acceptance criteria.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-024

#### 6.1.4.2 Dependency Reason

The UI for this story must communicate the 30-day grace period defined in US-024.

### 6.1.5.0 Story Id

#### 6.1.5.1 Story Id

US-025

#### 6.1.5.2 Dependency Reason

The UI after successful initiation should provide a path to cancel the deletion, which is the functionality of US-025.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for re-authentication.
- Firebase Firestore for storing tenant status.
- Firebase Cloud Functions for the secure backend logic.
- Admin Web Dashboard (Flutter for Web) for the user interface.

## 6.3.0.0 Data Dependencies

- Requires access to the current user's authentication token and tenant ID.
- Requires write access to the `/tenants/{tenantId}` document.
- Requires write access to the `/auditLog` collection.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The response time for the re-authentication and status update should be under 2 seconds.

## 7.2.0.0 Security

- The callable Cloud Function handling the request must validate that the caller is an authenticated user with the 'Admin' role for the specified tenant.
- The re-authentication process must be secure against replay attacks.
- The action must be logged in the immutable `auditLog` collection, including the timestamp and the Admin's `userId`.

## 7.3.0.0 Usability

- The language used in the UI must be clear and unambiguous to prevent accidental data loss.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported web browsers for the Admin dashboard (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both frontend (UI modal, state management) and backend (secure Cloud Function) development.
- The security aspect of the re-authentication and authorization logic is critical and requires careful implementation.
- Requires a new state ('pending_deletion') to be handled throughout the application for any user of that tenant (e.g., showing a banner, potentially disabling other features).

## 8.3.0.0 Technical Risks

- Improperly secured Cloud Function could allow an unauthorized user to initiate deletion.
- Failure to correctly handle the tenant's state change could lead to a confusing user experience for other users in the tenant during the grace period.

## 8.4.0.0 Integration Points

- Firebase Authentication (reauthenticateWithCredential).
- Firestore (updating the tenant document).
- Cloud Functions (callable function to orchestrate the logic).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Admin successfully initiates deletion.
- Admin fails re-authentication with an incorrect password.
- Admin cancels the process from the modal.
- Verify that a non-Admin user (e.g., Supervisor) cannot see or access the deletion functionality.
- Verify the audit log entry is created with the correct details.

## 9.3.0.0 Test Data Needs

- A test tenant with a registered Admin user.
- Credentials for the Admin user.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration testing.
- Jest for Cloud Function unit tests.
- flutter_test for widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for UI components and Cloud Function logic, achieving >80% coverage
- Integration testing of the full flow (UI -> Cloud Function -> Firestore) completed successfully in the emulator suite
- User interface reviewed and approved for clarity and usability
- Security requirements validated, including role-based access control on the Cloud Function
- Documentation for the tenant offboarding process is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This story is part of the 'Tenant Offboarding' epic and should be prioritized with US-023, US-024, and US-025 to deliver a complete feature set.
- The backend Cloud Function for the actual data deletion after 30 days can be a separate, subsequent story.

## 11.4.0.0 Release Impact

This feature is crucial for compliance and providing a complete customer lifecycle. It is a requirement for a full public launch.

