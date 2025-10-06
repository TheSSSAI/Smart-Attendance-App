# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-013 |
| Elaboration Date | 2024-05-22 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin deletes a team |
| As A User Story | As an Admin, I want to permanently delete a team f... |
| User Persona | Admin user, operating via the web-based administra... |
| Business Value | Improves data hygiene and administrative efficienc... |
| Functional Area | Tenant Administration |
| Story Theme | Team Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully deletes a team

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and am viewing the list of teams for my tenant

### 3.1.5 When

I click the 'Delete' action for a specific team and confirm the action in the confirmation dialog

### 3.1.6 Then

The system permanently deletes the team document from the database, a success notification is displayed, and the team is removed from the team list in the UI.

### 3.1.7 Validation Notes

Verify in Firestore that the team document under `/tenants/{tenantId}/teams/{teamId}` is deleted. Verify the UI updates.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Deletion confirmation dialog prevents accidental deletion

### 3.2.3 Scenario Type

Alternative_Flow

### 3.2.4 Given

I am an Admin on the team management page

### 3.2.5 When

I click the 'Delete' action for a team

### 3.2.6 Then

A confirmation modal appears with the text 'Are you sure you want to delete the team "[Team Name]"? This action cannot be undone.' and provides 'Confirm' and 'Cancel' options.

### 3.2.7 Validation Notes

Ensure the modal appears and displays the correct team name.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin cancels the deletion action

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

The team deletion confirmation modal is displayed

### 3.3.5 When

I click the 'Cancel' button or close the modal

### 3.3.6 Then

The modal closes, no deletion action is performed, and the team remains in the team list.

### 3.3.7 Validation Notes

Verify no database changes occurred and the UI remains unchanged.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Team deletion is reflected in associated user profiles

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

A team with several members is being deleted

### 3.4.5 When

The Admin confirms the deletion of the team

### 3.4.6 Then

The `teamId` of the deleted team is removed from the `teamIds` array field for all users who were members of that team.

### 3.4.7 Validation Notes

Query the `/users` collection for former members and verify their `teamIds` array no longer contains the deleted team's ID.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Team deletion is reflected in associated events

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

A team is assigned to one or more events

### 3.5.5 When

The Admin confirms the deletion of the team

### 3.5.6 Then

The `teamId` of the deleted team is removed from the `assignedTeamIds` array field for all events it was assigned to.

### 3.5.7 Validation Notes

Query the `/events` collection for affected events and verify their `assignedTeamIds` array no longer contains the deleted team's ID.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Team deletion is recorded in the audit log

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

An Admin is deleting a team

### 3.6.5 When

The deletion is successfully processed

### 3.6.6 Then

A new document is created in the `/auditLog` collection with `actionType: 'team.delete'`, the Admin's `userId`, the `targetEntityId` of the deleted team, and a snapshot of the team's data before deletion.

### 3.6.7 Validation Notes

Verify the creation and content of the new audit log entry in Firestore.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

System handles deletion failure gracefully

### 3.7.3 Scenario Type

Error_Condition

### 3.7.4 Given

An Admin has confirmed a team deletion

### 3.7.5 When

The backend operation fails due to a network error or server-side issue

### 3.7.6 Then

An error notification is displayed to the Admin (e.g., 'Failed to delete team. Please try again.'), and the team is not removed from the UI or database.

### 3.7.7 Validation Notes

Simulate a server error response and verify the UI shows an error message and the data remains intact.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

Non-Admin user is blocked from deleting a team

### 3.8.3 Scenario Type

Error_Condition

### 3.8.4 Given

A user with a 'Supervisor' or 'Subordinate' role is logged in

### 3.8.5 When

They attempt to trigger the team deletion action (e.g., via a direct API call)

### 3.8.6 Then

The system rejects the request with a 'permission-denied' error, and no data is changed.

### 3.8.7 Validation Notes

Test Firestore Security Rules and/or Cloud Function authentication checks to ensure non-Admins are blocked.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Delete' icon or button next to each team in the team list on the Admin dashboard.
- A confirmation modal/dialog with a clear warning message.
- Buttons within the modal for 'Confirm' and 'Cancel'.
- A toast/snackbar notification for success and error messages.

## 4.2.0 User Interactions

- Clicking the 'Delete' button triggers the confirmation modal.
- The team list should update automatically upon successful deletion to remove the deleted item.
- The UI should show a loading indicator while the deletion is being processed.

## 4.3.0 Display Requirements

- The confirmation modal must display the name of the team being deleted to ensure the user is certain about their action.

## 4.4.0 Accessibility Needs

- The delete button and confirmation modal must be keyboard accessible and screen-reader compatible.
- Confirmation and notification text must have sufficient color contrast.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Only users with the 'Admin' role can delete a team.

### 5.1.3 Enforcement Point

Backend (Cloud Function and/or Firestore Security Rules).

### 5.1.4 Violation Handling

The request is rejected with a 'permission-denied' error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Deleting a team does not delete the user accounts of its members.

### 5.2.3 Enforcement Point

Backend logic in the deletion Cloud Function.

### 5.2.4 Violation Handling

The logic is designed to only modify the `teamIds` array on user documents, not delete the documents themselves.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

All team deletion actions must be logged in the immutable audit log.

### 5.3.3 Enforcement Point

Backend logic in the deletion Cloud Function.

### 5.3.4 Violation Handling

The deletion operation should fail if the audit log entry cannot be created, ensuring atomicity.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-011

#### 6.1.1.2 Dependency Reason

A UI for listing teams and a mechanism for creating them must exist before a delete function can be added.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-014

#### 6.1.2.2 Dependency Reason

The concept of team membership (`teamIds` on user documents) must be implemented to handle un-assigning members.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-055

#### 6.1.3.2 Dependency Reason

The feature for assigning teams to events must exist to handle un-assigning teams from events upon deletion.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-051

#### 6.1.4.2 Dependency Reason

The audit log system must be in place to record the deletion event.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role verification.
- Firebase Firestore for data storage and retrieval.
- Firebase Cloud Functions to orchestrate the multi-collection update logic.

## 6.3.0.0 Data Dependencies

- Requires existing team, user, and event data structures as defined in the SRS (REQ-DAT-001).

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The entire deletion process, including all database updates, should complete within 2 seconds for a team with up to 100 members and 20 event assignments.

## 7.2.0.0 Security

- The deletion endpoint/function must be protected by RBAC, verifying the user's custom claims (`role: 'Admin'`, `tenantId`) before execution.
- All database operations must occur within the user's tenant scope.

## 7.3.0.0 Usability

- The confirmation step is mandatory to prevent accidental data loss.
- Clear feedback (success/error) must be provided to the user after the action is attempted.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported web browsers for the Admin dashboard (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The need for a server-side Cloud Function to handle data consistency.
- The fan-out write operation required to update all associated user and event documents.
- Ensuring the entire operation is atomic (all or nothing) using Firestore Batched Writes.
- Querying multiple collections to find all related documents before deletion.

## 8.3.0.0 Technical Risks

- Potential for partial failure if the batch write exceeds Firestore's limits (500 operations). The function must handle this by chunking operations if necessary.
- Performance degradation if a team has thousands of members or is assigned to thousands of events, requiring optimized queries.

## 8.4.0.0 Integration Points

- Firestore `/teams` collection (delete).
- Firestore `/users` collection (update).
- Firestore `/events` collection (update).
- Firestore `/auditLog` collection (create).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Delete a team with no members or event assignments.
- Delete a team with multiple members and event assignments.
- Attempt to delete a team as a non-Admin user.
- Cancel the deletion from the confirmation modal.
- Simulate a network failure during the deletion process.

## 9.3.0.0 Test Data Needs

- An Admin user account.
- A non-Admin user account (e.g., Supervisor).
- A test tenant with multiple teams, users, and events.
- A team specifically created with members and assigned to events for the deletion test.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for integration testing.
- Jest for unit testing the Cloud Function.
- Flutter's `integration_test` package for E2E testing the web dashboard flow.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Cloud Function code reviewed and approved by a backend developer
- Frontend (Flutter Web) code reviewed and approved by a frontend developer
- Unit tests for the Cloud Function achieve >80% code coverage
- Integration tests covering the full data modification flow are implemented and passing in the Emulator Suite
- E2E test scenario for the happy path is automated and passing
- Security rules and function authentication logic are tested and verified
- User interface reviewed for usability and accessibility compliance
- Documentation for the Cloud Function's purpose and logic is created
- Story deployed and verified in the staging environment by a QA engineer

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- Requires both frontend (UI elements) and backend (Cloud Function) development.
- The backend logic is the most complex part and should be tackled first or in parallel with UI scaffolding.

## 11.4.0.0 Release Impact

- This is a core administrative feature. Its absence would be a notable gap in tenant management capabilities.

