# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-008 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin deactivates a user's account |
| As A User Story | As an Admin, I want to deactivate a user's account... |
| User Persona | Admin |
| Business Value | Enhances organizational security by preventing una... |
| Functional Area | User Management |
| Story Theme | Tenant Administration |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully deactivates a user who is not a supervisor

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am logged in as an Admin on the user management dashboard

### 3.1.5 When

I select a user with the 'Subordinate' role, click 'Deactivate', and confirm the action in the confirmation dialog

### 3.1.6 Then

The system updates the user's status to 'deactivated' in the Firestore database, a success message is displayed, and the user's status is visually updated in the user list.

### 3.1.7 Validation Notes

Verify the 'status' field in the user's document in Firestore is 'deactivated'. The UI should reflect this change without a page reload.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Deactivated user is prevented from logging in

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

A user's account has been successfully deactivated

### 3.2.5 When

That user attempts to log in with their correct credentials

### 3.2.6 Then

The system denies access and displays a clear message, such as 'Your account has been deactivated. Please contact your administrator.'

### 3.2.7 Validation Notes

This requires the login logic (from US-017) to check the user's status before authenticating.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin is blocked from deactivating a Supervisor with active subordinates

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

I am logged in as an Admin and select a 'Supervisor' user who has one or more active subordinates assigned to them

### 3.3.5 When

I attempt to deactivate this Supervisor

### 3.3.6 Then

The system prevents the deactivation and displays a modal or notification explaining that all subordinates must be reassigned to a new supervisor first.

### 3.3.7 Validation Notes

The system must perform a check against the 'users' collection for any users whose 'supervisorId' matches the ID of the user being deactivated. The UI message should be clear and actionable.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin cannot deactivate their own account

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am logged in as an Admin on the user management dashboard

### 3.4.5 When

I locate my own user account in the list

### 3.4.6 Then

The 'Deactivate' action or button is disabled or hidden for my own account.

### 3.4.7 Validation Notes

The UI should conditionally render the deactivation control based on whether the user ID in the list matches the currently authenticated Admin's user ID.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Deactivation action is recorded in the audit log

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

An Admin is deactivating a user's account

### 3.5.5 When

The deactivation is successfully confirmed and processed

### 3.5.6 Then

A new entry is created in the immutable 'auditLog' collection with details including the Admin's ID ('actorUserId'), the deactivated user's ID ('targetEntityId'), the action type ('user.deactivate'), and a timestamp.

### 3.5.7 Validation Notes

Check the '/tenants/{tenantId}/auditLog' collection for a new document corresponding to this action.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Deactivated user's active session is invalidated

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

A user is currently logged in and has an active session

### 3.6.5 When

An Admin deactivates that user's account

### 3.6.6 Then

The user's authentication token is revoked, and they are automatically logged out or their next API call fails with an authentication error.

### 3.6.7 Validation Notes

This can be tested by having two sessions open (Admin and User). When the Admin deactivates the user, the user's session should become invalid. This likely requires a Cloud Function using the Firebase Admin SDK to revoke refresh tokens.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Deactivate' button or menu item next to each user in the user list (except for the Admin's own account).
- A confirmation modal dialog to prevent accidental deactivation.
- A blocking modal/notification for when a Supervisor with subordinates cannot be deactivated.
- Success and error toast notifications.

## 4.2.0 User Interactions

- Admin clicks 'Deactivate'.
- Admin confirms the action in a modal.
- The user list UI updates in real-time to reflect the new 'deactivated' status.

## 4.3.0 Display Requirements

- The user list must clearly display the status of each user ('active', 'deactivated', 'invited').
- The confirmation dialog must clearly state the consequences of deactivation (e.g., 'This will immediately revoke all access for the user.').

## 4.4.0 Accessibility Needs

- All buttons and modals must be keyboard accessible and have appropriate ARIA labels.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A Supervisor with active subordinates cannot be deactivated.

### 5.1.3 Enforcement Point

Server-side (Cloud Function or Firestore Security Rule) before processing the deactivation request.

### 5.1.4 Violation Handling

The request is rejected, and an error message is returned to the client explaining the reason.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

An Admin cannot deactivate their own account.

### 5.2.3 Enforcement Point

Client-side (UI should prevent the action) and server-side (as a security backup).

### 5.2.4 Violation Handling

The action is blocked.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

Requires an Admin account and tenant to exist.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-004

#### 6.1.2.2 Dependency Reason

Requires the ability to create users that can then be deactivated.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-017

#### 6.1.3.2 Dependency Reason

The login flow must be implemented to test the effect of deactivation (preventing login).

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-051

#### 6.1.4.2 Dependency Reason

Requires the audit log system to be in place to record the deactivation event.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user identity and session management.
- Firestore database for storing user status.
- Cloud Function for server-side logic (supervisor check, session invalidation, audit logging).

## 6.3.0.0 Data Dependencies

- Requires a populated list of users with different roles (Subordinate, Supervisor) for testing.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The deactivation process, including database updates and session invalidation, should complete within 2 seconds.

## 7.2.0.0 Security

- The system must immediately invalidate the deactivated user's session/refresh tokens to prevent further access.
- The action must only be performable by a user with the 'Admin' role, enforced by Firestore Security Rules and/or Cloud Function checks.

## 7.3.0.0 Usability

- The process for deactivating a user should be intuitive and provide clear feedback and warnings to the Admin.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must work correctly on all supported web browsers for the Admin dashboard.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a server-side check to validate if a user is a supervisor before deactivation.
- Implementing immediate session invalidation requires using the Firebase Admin SDK in a Cloud Function to revoke refresh tokens, which is more complex than a simple database write.
- The transaction must atomically update the user document and create an audit log entry.

## 8.3.0.0 Technical Risks

- Potential race condition if a supervisor's last subordinate is reassigned at the same time the admin tries to deactivate them. The deactivation logic must be transactional.
- Ensuring session invalidation is truly immediate and effective across all client states.

## 8.4.0.0 Integration Points

- Firebase Authentication: To revoke user tokens.
- Firestore: To update the user's status field.
- Audit Log System: To record the action.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Deactivate a standard user.
- Attempt to deactivate a supervisor with subordinates; verify it's blocked.
- Reassign subordinates from a supervisor, then successfully deactivate that supervisor.
- Verify an admin cannot see a 'Deactivate' option for themselves.
- Verify a deactivated user cannot log in.
- Verify an active session is terminated upon deactivation.

## 9.3.0.0 Test Data Needs

- An Admin user.
- A Subordinate user.
- A Supervisor user with no subordinates.
- A Supervisor user with at least two active subordinates.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and testing.
- Jest for Cloud Function unit tests.
- Flutter integration_test framework for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for Cloud Function logic implemented with >80% coverage
- Integration testing for the full deactivation flow completed successfully
- User interface reviewed and approved by UX/Product Owner
- Security requirement for session invalidation is manually verified and confirmed working
- Audit log entry is correctly generated and formatted
- Documentation for the user deactivation process is updated
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is tightly coupled with US-009 (Reassigning subordinates). It is highly recommended to plan them for the same sprint to ensure a cohesive user flow.
- Requires backend (Cloud Function) and frontend (Admin Dashboard UI) development.

## 11.4.0.0 Release Impact

This is a critical security and user lifecycle management feature required for the initial release.

