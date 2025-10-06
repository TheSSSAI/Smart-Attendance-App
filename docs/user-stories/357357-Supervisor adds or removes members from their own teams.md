# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-015 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor adds or removes members from their own ... |
| As A User Story | As a Supervisor, I want to add and remove members ... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Empowers team leaders to manage their own rosters,... |
| Functional Area | Team Management |
| Story Theme | User and Team Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Supervisor successfully adds an eligible user to a team they manage

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a logged-in Supervisor and I am viewing the details of a team I am assigned to supervise

### 3.1.5 When

I select the 'Add Member' option, search for and select an active user with the 'Subordinate' role who is not already on the team

### 3.1.6 Then

the user is added to the team's member list, their user profile is updated with the new team ID, and the team member list in my UI refreshes to show the new member.

### 3.1.7 Validation Notes

Verify the `memberIds` array in the `/teams/{teamId}` document and the `teamIds` array in the `/users/{userId}` document are both updated correctly within a single atomic transaction.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Supervisor successfully removes a member from a team they manage

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am a logged-in Supervisor and I am viewing the member list for a team I supervise

### 3.2.5 When

I select the 'Remove' option for a specific member and confirm the action in a confirmation dialog

### 3.2.6 Then

the user is removed from the team's member list, their user profile is updated to remove the team ID, and the team member list in my UI refreshes to show the member has been removed.

### 3.2.7 Validation Notes

Verify the `memberIds` array in the `/teams/{teamId}` document and the `teamIds` array in the `/users/{userId}` document are both updated correctly within a single atomic transaction.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Supervisor is prevented from managing a team they do not supervise

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am a logged-in Supervisor

### 3.3.5 When

I attempt to modify the member list of a team for which I am not the designated supervisor (e.g., via a direct API call or manipulated client state)

### 3.3.6 Then

the system must reject the request with a 'permission-denied' error, and no changes are made to the database.

### 3.3.7 Validation Notes

This must be enforced by Firestore Security Rules. Test this using the Firebase Emulator Suite by authenticating as a Supervisor and attempting to write to a team document where `supervisorId` does not match the user's UID.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

The list of users to add excludes existing team members

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

I am a logged-in Supervisor and I am viewing the 'Add Member' interface for a team

### 3.4.5 When

I view the list of available users to add

### 3.4.6 Then

the list must not contain any users who are already members of the current team.

### 3.4.7 Validation Notes

The query or Cloud Function that fetches potential members must filter out users whose `userId` is already in the team's `memberIds` array.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

The list of users to add excludes non-subordinate roles

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am a logged-in Supervisor and I am viewing the 'Add Member' interface

### 3.5.5 When

I view the list of available users to add

### 3.5.6 Then

the list must only contain users with the 'Subordinate' role. Users with 'Admin' or 'Supervisor' roles must be excluded.

### 3.5.7 Validation Notes

The query or Cloud Function fetching users must filter by `role == 'Subordinate'`.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Supervisor receives a confirmation prompt before removing a member

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

I am a logged-in Supervisor viewing a team's member list

### 3.6.5 When

I click the 'Remove' button for a member

### 3.6.6 Then

a confirmation dialog appears with the text 'Are you sure you want to remove [User Name] from [Team Name]?' and 'Confirm' and 'Cancel' buttons.

### 3.6.7 Validation Notes

The removal action should only proceed after the 'Confirm' button is clicked.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A list of teams managed by the Supervisor.
- A detailed view for a selected team, showing a list of current members.
- An 'Add Member' button or icon on the team detail view.
- A 'Remove' button or icon next to each member in the list.
- A modal or separate screen for searching and selecting users to add.
- A confirmation dialog for the remove action.

## 4.2.0 User Interactions

- Supervisor taps on a team to see its members.
- Supervisor taps 'Add Member' to open a user selection interface.
- Supervisor can search/filter the list of eligible users.
- Supervisor taps on a user to select them for addition.
- Supervisor taps 'Remove' on a member, then 'Confirm' in the dialog to complete the removal.

## 4.3.0 Display Requirements

- The team member list should display at least the member's full name and email.
- The user selection list should display the user's full name and email.
- The UI must provide immediate feedback (e.g., loading indicator, success/error message) for add/remove actions.

## 4.4.0 Accessibility Needs

- All buttons ('Add Member', 'Remove') must have accessible labels for screen readers.
- The user lists must be navigable via keyboard or assistive technologies.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A Supervisor can only manage the membership of teams to which they are explicitly assigned as the supervisor.

### 5.1.3 Enforcement Point

Backend (Firestore Security Rules) on all write operations to the `/teams/{teamId}` document.

### 5.1.4 Violation Handling

The operation is denied with a 'permission-denied' error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Only users with the 'Subordinate' role can be added as members to a team.

### 5.2.3 Enforcement Point

Backend (Firestore Security Rules or Cloud Function validation) and Frontend (filtering the list of addable users).

### 5.2.4 Violation Handling

The operation is denied. The UI should prevent the selection of ineligible users.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-011

#### 6.1.1.2 Dependency Reason

A team must be created and a Supervisor assigned to it before that Supervisor can manage its members.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-004

#### 6.1.2.2 Dependency Reason

Users (both Supervisors and Subordinates) must be invited and activated in the system before they can be assigned to or managed within teams.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user roles and identity.
- Firestore database for storing team and user data.
- Firestore Security Rules for enforcing role-based access control.

## 6.3.0.0 Data Dependencies

- Existence of user documents with a `role` field ('Supervisor', 'Subordinate').
- Existence of team documents with a `supervisorId` field and a `memberIds` array.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Loading the list of team members should take less than 2 seconds on a stable connection.
- The add/remove operation, including UI refresh, should complete in under 1.5 seconds.

## 7.2.0.0 Security

- All membership modification requests must be authenticated and authorized via Firestore Security Rules based on the Supervisor's role and their assignment to the specific team.
- The client should never fetch a list of all users in the tenant. A secure Cloud Function should be used to provide a filtered list of eligible users to add.

## 7.3.0.0 Usability

- The process of adding or removing a member should be intuitive and require minimal steps.
- Clear feedback must be provided to the user upon success or failure of an operation.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires robust Firestore Security Rules to prevent unauthorized access.
- Requires careful state management on the client to ensure the UI reflects database changes accurately.
- The need for a secure and efficient way to search/filter eligible users to add, likely requiring a callable Cloud Function.
- Ensuring data consistency between the team's `memberIds` array and the user's `teamIds` array requires using atomic transactions (Firestore WriteBatch).

## 8.3.0.0 Technical Risks

- Incorrectly configured security rules could lead to data corruption or unauthorized access.
- Inefficient user search query could lead to poor performance for tenants with a large number of users.

## 8.4.0.0 Integration Points

- Firestore: Reading and writing to `/teams` and `/users` collections.
- Firebase Cloud Functions: Potentially for providing a secure search of eligible users.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Security

## 9.2.0.0 Test Scenarios

- Verify a Supervisor can add/remove a member from their assigned team.
- Verify a Supervisor CANNOT add/remove a member from another Supervisor's team.
- Verify the user search list correctly filters out existing members and non-subordinate users.
- Verify that removing the last member from a team results in an empty team, not a deleted team.
- Verify all database updates for a single operation occur atomically.

## 9.3.0.0 Test Data Needs

- A tenant with at least two Supervisors, multiple teams, and multiple Subordinates.
- One team assigned to Supervisor A, another to Supervisor B.
- Subordinates who are on a team, and some who are not on any team.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for testing Firestore Security Rules and Cloud Functions locally.
- Flutter's `flutter_test` and `integration_test` packages.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new code
- Integration testing for both happy paths and security rule enforcement completed successfully in the emulator
- User interface reviewed and approved for usability and adherence to design guidelines
- Security requirements validated, especially Firestore rules
- Documentation for the team management feature updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational feature for the Supervisor role and a blocker for other Supervisor-led activities like team-based event assignment (US-055). It should be prioritized early in the development of Supervisor features.

## 11.4.0.0 Release Impact

- Enables a key piece of functionality for the Supervisor persona, making the application significantly more useful for team management.

