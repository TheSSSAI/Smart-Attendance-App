# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-012 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin edits an existing team's name or assigned Su... |
| As A User Story | As an Admin, I want to edit an existing team's nam... |
| User Persona | Admin: A user with full administrative privileges ... |
| Business Value | Maintains data accuracy of the organizational hier... |
| Functional Area | Tenant and User Management |
| Story Theme | Team Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully edits a team's name

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and viewing the list of teams

### 3.1.5 When

I select a team to edit, change only its name to a new, unique value, and click 'Save'

### 3.1.6 Then

the system updates the team's name in the database, a success notification is displayed, the edit modal closes, and the team list shows the updated name.

### 3.1.7 Validation Notes

Verify the 'name' field for the team document in the Firestore `/tenants/{tenantId}/teams/{teamId}` collection is updated. Verify an audit log entry is created for this change.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin successfully reassigns a team's supervisor

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am an Admin logged into the web dashboard and viewing the list of teams

### 3.2.5 When

I select a team to edit, select a different, eligible user as the new supervisor, and click 'Save'

### 3.2.6 Then

the system updates the team's supervisor in the database, a success notification is displayed, the edit modal closes, and the team list shows the new supervisor.

### 3.2.7 Validation Notes

Verify the 'supervisorId' field for the team document in Firestore is updated. Verify an audit log entry is created.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin attempts to save with an empty team name

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am an Admin editing an existing team

### 3.3.5 When

I delete the content of the team name field and attempt to save

### 3.3.6 Then

the save operation is prevented, a validation error message 'Team name cannot be empty' is displayed next to the field, and the form remains open.

### 3.3.7 Validation Notes

Check for client-side and server-side validation. The database should not be updated.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin attempts to use a duplicate team name

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am an Admin editing an existing team, and another team named 'Field Ops' already exists

### 3.4.5 When

I change the current team's name to 'Field Ops' and attempt to save

### 3.4.6 Then

the save operation is prevented, a validation error message 'Team name must be unique' is displayed, and the form remains open.

### 3.4.7 Validation Notes

This requires a server-side check (in a Cloud Function) to query for existing team names within the tenant.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin cancels the edit operation

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

I am an Admin editing an existing team and have made unsaved changes to the name and/or supervisor

### 3.5.5 When

I click the 'Cancel' button or close the edit modal

### 3.5.6 Then

all changes are discarded, the team's data remains unchanged in the database, and I am returned to the team list view.

### 3.5.7 Validation Notes

Verify that no update operation was sent to the backend and the data in Firestore is unchanged.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Supervisor dropdown only shows eligible users

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

I am an Admin editing an existing team

### 3.6.5 When

I click on the 'Assign Supervisor' dropdown

### 3.6.6 Then

the list of users only contains active users within my tenant who have the 'Supervisor' or 'Admin' role.

### 3.6.7 Validation Notes

Query the `/tenants/{tenantId}/users` collection and filter by `role` in ['Supervisor', 'Admin'] and `status` == 'active'.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Team edit action is logged in the audit trail

### 3.7.3 Scenario Type

Happy_Path

### 3.7.4 Given

I am an Admin editing a team's name from 'Old Name' to 'New Name'

### 3.7.5 When

I successfully save the change

### 3.7.6 Then

a new, immutable document is created in the `/auditLog` collection containing the actor's ID, the action type ('team.update'), the target team's ID, and a details map with `{oldValue: {name: 'Old Name'}, newValue: {name: 'New Name'}}`.

### 3.7.7 Validation Notes

Check the `/tenants/{tenantId}/auditLog` collection for the corresponding entry after a successful edit.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A list of teams with an 'Edit' button/icon for each row.
- An 'Edit Team' modal or dedicated page.
- A text input field for 'Team Name', pre-populated with the current name.
- A searchable dropdown/select component for 'Supervisor', pre-populated with the current supervisor.
- A 'Save' button.
- A 'Cancel' button.

## 4.2.0 User Interactions

- Clicking 'Edit' on a team opens the editing interface.
- The 'Save' button is disabled until a change is made to the form.
- Typing in the name field updates the form state.
- Selecting a new supervisor from the dropdown updates the form state.
- Clicking 'Save' triggers validation and submission.
- Clicking 'Cancel' discards changes and closes the interface.
- Success or error feedback is provided via a non-intrusive toast or snackbar notification.

## 4.3.0 Display Requirements

- The editing form must clearly show the current values of the team being edited.
- Validation error messages must be displayed inline, next to the relevant field.
- The list of potential supervisors should display the user's full name and email for clarity.

## 4.4.0 Accessibility Needs

- All form fields must have associated labels (`<label for>`).
- All buttons must have accessible names.
- The modal must properly trap focus.
- Error messages must be associated with their inputs using `aria-describedby`.
- The interface must be navigable using a keyboard.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-TEAM-001

### 5.1.2 Rule Description

A team's name must be unique within a single tenant.

### 5.1.3 Enforcement Point

Server-side (Cloud Function) during the save operation.

### 5.1.4 Violation Handling

The update request is rejected, and an error message is returned to the client.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-TEAM-002

### 5.2.2 Rule Description

A team name cannot be null or empty.

### 5.2.3 Enforcement Point

Client-side (form validation) and Server-side (Cloud Function).

### 5.2.4 Violation Handling

The update request is rejected, and an error message is returned.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-AUDIT-001

### 5.3.2 Rule Description

All updates to a team's name or supervisor must be recorded in the immutable audit log.

### 5.3.3 Enforcement Point

Server-side (Cloud Function) after a successful update.

### 5.3.4 Violation Handling

If the audit log write fails, the entire transaction should ideally be rolled back to maintain consistency.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-011

#### 6.1.1.2 Dependency Reason

The ability to create a team is required before a team can be edited.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-004

#### 6.1.2.2 Dependency Reason

The ability to invite and create users is required to have a pool of potential supervisors to assign.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-051

#### 6.1.3.2 Dependency Reason

The audit log viewing feature relies on this story (and others) to populate the log with data. The logging mechanism itself must be implemented as part of this story.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role-based access control.
- Firestore database for storing team data.
- Firebase Cloud Functions for secure server-side validation and logic.
- Admin Web Dashboard (Flutter for Web) as the platform for the UI.

## 6.3.0.0 Data Dependencies

- Requires existing team data in the `/teams` collection.
- Requires existing user data in the `/users` collection to populate the supervisor list.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The supervisor selection dropdown should load and be interactive within 500ms, even with up to 1,000 eligible users in the tenant.
- The save operation (client click to success feedback) should complete in under 2 seconds on a stable connection.

## 7.2.0.0 Security

- This functionality must be strictly limited to users with the 'Admin' role.
- Firestore Security Rules must prevent any non-Admin user from directly modifying a team document.
- All data transmitted between the client and Firebase services must be encrypted via TLS.

## 7.3.0.0 Usability

- The process of editing a team should be intuitive, requiring no external documentation for an Admin user.
- Feedback (success, error, loading) must be clear and immediate.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a server-side Cloud Function for secure validation (unique name check) and atomic writes (update team + write to audit log).
- Requires careful implementation of Firestore Security Rules to enforce RBAC.
- The query to fetch eligible supervisors may require a composite index in Firestore, which must be managed via IaC.
- State management on the client to handle the form, loading, and error states.

## 8.3.0.0 Technical Risks

- Potential for a race condition if two Admins try to edit the same team simultaneously. Using a Firestore transaction in the Cloud Function can mitigate this.
- Incorrectly configured Firestore indexes could lead to poor performance when fetching the supervisor list for large tenants.

## 8.4.0.0 Integration Points

- Firebase Authentication (to get user role from custom claims).
- Firestore Database (read/write to `teams` and `users` collections, write to `auditLog` collection).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify an Admin can change a team name.
- Verify an Admin can change a team supervisor.
- Verify an Admin cannot save with a blank name.
- Verify an Admin cannot save with a duplicate name.
- Verify a non-Admin user cannot access the edit functionality.
- Verify the audit log is correctly populated after a change.
- Verify canceling an edit discards all changes.

## 9.3.0.0 Test Data Needs

- A test tenant with at least two teams to test duplicate name validation.
- A test tenant with multiple users, including some with 'Supervisor' role, some with 'Admin' role, and some with 'Subordinate' role to test dropdown filtering.
- A user with an 'Admin' role for testing access.
- A user without an 'Admin' role for testing access denial.

## 9.4.0.0 Testing Tools

- Flutter's `flutter_test` for widget tests.
- Flutter's `integration_test` for E2E tests.
- Firebase Local Emulator Suite for local integration testing of UI, Cloud Functions, and Firestore Rules.
- Jest for unit testing the TypeScript Cloud Function.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented for UI logic and state management, achieving >80% coverage
- Unit tests implemented for the Cloud Function, achieving >80% coverage
- Integration tests covering the UI-to-database flow are passing in the emulator environment
- Firestore Security Rules are written and tested to secure the endpoint
- The corresponding audit log entry is created correctly upon successful update
- User interface reviewed for usability and adherence to design specifications
- Accessibility (WCAG 2.1 AA) requirements have been met and verified
- Story deployed and verified in the staging environment by QA

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- Dependent on the completion of the base team creation story (US-011).
- Requires a clear definition of the audit log schema before implementation begins.
- The backend Cloud Function and frontend UI can be developed in parallel if the function's contract (inputs/outputs) is defined upfront.

## 11.4.0.0 Release Impact

This is a core administrative feature necessary for the long-term maintenance of any organization's setup. It is critical for a V1 release.

