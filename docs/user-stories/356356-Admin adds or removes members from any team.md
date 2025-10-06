# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-014 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin adds or removes members from any team |
| As A User Story | As an Admin, I want to add and remove users from a... |
| User Persona | Admin: A user with full administrative privileges ... |
| Business Value | Ensures data integrity of the organizational struc... |
| Functional Area | User and Team Management |
| Story Theme | Tenant Administration |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully adds a user to a team

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and am viewing the 'Manage Members' page for a specific team

### 3.1.5 When

I initiate the 'Add Member' action, select a valid user who is not currently a member of this team, and confirm the addition

### 3.1.6 Then

The system displays a success notification, the user's name immediately appears in the team's member list on the UI, and the backend data for both the team and the user is updated to reflect the new membership.

### 3.1.7 Validation Notes

Verify the `memberIds` array in the `/teams/{teamId}` document and the `teamIds` array in the `/users/{userId}` document are both updated in Firestore.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin successfully removes a user from a team

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am an Admin viewing the member list for a team that has at least one member

### 3.2.5 When

I click the 'Remove' action next to a member's name and confirm the removal in the confirmation dialog

### 3.2.6 Then

The system displays a success notification, the user's name is immediately removed from the team's member list on the UI, and the backend data for the team and user is updated.

### 3.2.7 Validation Notes

Verify the user's ID is removed from the `memberIds` array in the team document and the team's ID is removed from the `teamIds` array in the user document.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

System prevents adding a user who is already a member of the team

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

I am an Admin on the 'Add Member' interface for a specific team

### 3.3.5 When

I search for users to add to the team

### 3.3.6 Then

The list of available users must not include any users who are already members of that team.

### 3.3.7 Validation Notes

The query to fetch potential members must filter out existing members.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

System prevents adding a deactivated user to a team

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am an Admin on the 'Add Member' interface for a team

### 3.4.5 When

I search for users to add

### 3.4.6 Then

The list of available users must not include any users with a status of 'deactivated'.

### 3.4.7 Validation Notes

The query to fetch potential members must filter for users with an 'active' status.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin must confirm before removing a member

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

I am an Admin viewing the member list for a team

### 3.5.5 When

I click the 'Remove' action for a member

### 3.5.6 Then

A confirmation dialog appears asking 'Are you sure you want to remove [User Name] from this team?', with 'Confirm' and 'Cancel' options.

### 3.5.7 Validation Notes

The removal action should only proceed after the 'Confirm' button is clicked.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Non-Admin user is denied access to manage team members

### 3.6.3 Scenario Type

Security

### 3.6.4 Given

I am logged in as a user with a 'Supervisor' or 'Subordinate' role

### 3.6.5 When

I attempt to access the team membership management functionality via the UI or a direct API call

### 3.6.6 Then

The system must block the action and return a 'Permission Denied' error.

### 3.6.7 Validation Notes

Test Firestore Security Rules to ensure only users with the 'Admin' custom claim can modify the `memberIds` array.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A list of teams in the Admin dashboard.
- A dedicated 'Manage Team' page displaying team details.
- A list of current team members with their name and email.
- An 'Add Member' button.
- A modal or search interface to find and select users to add.
- A 'Remove' icon/button next to each member in the list.
- A confirmation modal for the remove action.
- Success and error notification toasts/snackbars.

## 4.2.0 User Interactions

- Admin navigates from a team list to a specific team's management page.
- Admin searches for users by name or email to add them.
- Admin clicks to select a user from the search results.
- Admin clicks a remove icon and then a confirm button to remove a member.

## 4.3.0 Display Requirements

- The list of users available to be added should be clearly distinguishable from current members.
- The UI must update in real-time after a member is added or removed without requiring a page refresh.

## 4.4.0 Accessibility Needs

- All buttons, lists, and modals must be keyboard navigable and screen-reader friendly.
- Sufficient color contrast must be used for all interactive elements and text, meeting WCAG 2.1 AA standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-014-01

### 5.1.2 Rule Description

Only users with an 'active' status can be added to a team.

### 5.1.3 Enforcement Point

Backend query for fetching addable users; Firestore Security Rules.

### 5.1.4 Violation Handling

Deactivated users are not displayed in the selection list. Any direct API attempt to add them is rejected.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-014-02

### 5.2.2 Rule Description

A user cannot be added to the same team more than once.

### 5.2.3 Enforcement Point

Backend query for fetching addable users; Firestore Security Rules using array checks.

### 5.2.4 Violation Handling

Existing members are not displayed in the selection list. Any direct API attempt is rejected.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant must exist before any teams or users can be created within it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-004

#### 6.1.2.2 Dependency Reason

Users must be invited and activated before they can be managed or added to teams.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-011

#### 6.1.3.2 Dependency Reason

Teams must be created before their membership can be managed.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role-based access control (RBAC) via custom claims.
- Firestore database with defined data models for users and teams.
- Implemented Firestore Security Rules to enforce Admin-only access.
- A functional Admin web dashboard built with Flutter for Web.

## 6.3.0.0 Data Dependencies

- Requires existing user records in the `/users` collection.
- Requires existing team records in the `/teams` collection.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The list of users available to add should load within 2 seconds for a tenant with up to 1,000 users.
- The add/remove operations should reflect on the UI in under 500ms on a stable connection.

## 7.2.0.0 Security

- All write operations (add/remove) must be validated by Firestore Security Rules to ensure the user is an Admin of the correct tenant.
- Client-side checks are for usability; server-side security rules are the source of truth for enforcement.

## 7.3.0.0 Usability

- The process of finding and adding a user should be intuitive, with a prominent search bar.
- Feedback on the success or failure of an operation must be immediate and clear.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard must be fully functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- UI complexity involving modals, search functionality, and real-time list updates.
- Ensuring data consistency between the team document (`memberIds`) and the user document (`teamIds`). A batched write or a Cloud Function trigger is recommended to maintain atomicity.
- Designing an efficient Firestore query to find users who are not yet on a team, which can be challenging at scale.

## 8.3.0.0 Technical Risks

- Potential for data inconsistency if the updates to user and team documents are not handled in a single atomic transaction.
- Performance degradation of the user search feature as the number of users in a tenant grows.

## 8.4.0.0 Integration Points

- Firestore: Reads from and writes to `/users/{userId}` and `/teams/{teamId}` collections.
- Firebase Authentication: Reads custom claims from the user's auth token to verify role.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify an Admin can add a user to a team.
- Verify an Admin can remove a user from a team.
- Verify the UI prevents adding an existing member.
- Verify a Supervisor cannot access this functionality.
- Test the confirmation dialog flow for removing a member.
- Test the search functionality in the 'Add Member' modal.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user.
- Multiple active and at least one deactivated test user.
- At least two test teams, one with members and one without.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and testing of Firestore rules and functions.
- `flutter_test` for unit and widget tests.
- `integration_test` for end-to-end testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new code
- Firestore Security Rules tests implemented and passing
- End-to-end integration testing completed successfully
- User interface reviewed for responsiveness and accessibility (WCAG 2.1 AA)
- Performance requirements verified against benchmarks
- Security requirements validated via rule testing and code review
- Documentation for the feature is updated in the Admin Guide
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a core administrative feature and a blocker for any functionality that relies on team assignments, such as supervisor dashboards (US-015) and team-based event assignment (US-055).

## 11.4.0.0 Release Impact

- This feature is essential for the initial setup and ongoing management of an organization. It must be included in the first release containing team-based features.

