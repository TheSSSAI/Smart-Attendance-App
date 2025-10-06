# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-009 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin is required to reassign subordinates before ... |
| As A User Story | As an Admin, I want to be prevented from deactivat... |
| User Persona | Admin |
| Business Value | Ensures organizational hierarchy integrity by prev... |
| Functional Area | User Management |
| Story Theme | Tenant Administration & Data Integrity |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Attempt to deactivate a Supervisor with active subordinates

### 3.1.3 Scenario Type

Error_Condition

### 3.1.4 Given

An Admin is logged into the web dashboard and is viewing the user list.

### 3.1.5 When

The Admin attempts to deactivate a user who has the 'Supervisor' role and has one or more active subordinates assigned to them.

### 3.1.6 Then

The deactivation action is blocked by the system.

### 3.1.7 And

The modal provides a clear call-to-action button, such as 'Reassign Subordinates'.

### 3.1.8 Validation Notes

Verify that the user's status in Firestore remains 'active'. Verify the modal appears with the correct subordinate count and list.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Successful deactivation of a Supervisor after reassigning all subordinates

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

An Admin was blocked from deactivating a Supervisor and is now in the reassignment interface.

### 3.2.5 When

The Admin reassigns all of the Supervisor's active subordinates to one or more new, valid Supervisors.

### 3.2.6 And

The former Supervisor's user status is updated to 'deactivated' in the database.

### 3.2.7 Then

The deactivation action is successful.

### 3.2.8 Validation Notes

Verify in Firestore that the `supervisorId` for all former subordinates has been updated. Verify the original supervisor's `status` is now 'deactivated'.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Successful deactivation of a Supervisor with no active subordinates

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

An Admin is logged into the web dashboard.

### 3.3.5 When

The Admin attempts to deactivate a user with the 'Supervisor' role who has zero active subordinates (they may have deactivated subordinates or none at all).

### 3.3.6 Then

The deactivation proceeds successfully without showing the reassignment modal.

### 3.3.7 And

The Supervisor's user status is updated to 'deactivated'.

### 3.3.8 Validation Notes

Verify the deactivation happens immediately and the user's status changes to 'deactivated' in Firestore.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin cancels the reassignment process

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

The reassignment modal is displayed after an Admin attempted to deactivate a Supervisor.

### 3.4.5 When

The Admin closes or cancels the modal without reassigning any subordinates.

### 3.4.6 Then

The original Supervisor's user status remains 'active'.

### 3.4.7 And

No changes are made to the subordinates' assignments.

### 3.4.8 Validation Notes

Verify that the supervisor's and subordinates' records in Firestore are unchanged.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Reassignment list only contains valid new Supervisors

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

An Admin is in the reassignment interface for a subordinate.

### 3.5.5 When

The Admin views the list of available users to select as the new Supervisor.

### 3.5.6 Then

The list only contains active users with the 'Supervisor' or 'Admin' role within the same tenant.

### 3.5.7 And

The list explicitly excludes the Supervisor who is pending deactivation.

### 3.5.8 Validation Notes

Manually inspect the dropdown/selection list in the UI to ensure it is correctly filtered.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Modal dialog for blocking deactivation and initiating reassignment.
- List of subordinates within the modal.
- Dropdown or searchable select input for choosing a new supervisor for each subordinate.
- Confirmation buttons ('Reassign', 'Save', 'Cancel').

## 4.2.0 User Interactions

- Admin clicks 'Deactivate' on a user row.
- System displays a blocking modal if conditions are met.
- Admin clicks 'Reassign Subordinates' to proceed to the reassignment view.
- Admin selects a subordinate and chooses a new supervisor from a filtered list.
- Admin confirms the changes, which triggers the update.

## 4.3.0 Display Requirements

- The blocking modal must clearly state the reason for the block and the number of affected subordinates.
- The reassignment interface must clearly show which subordinate is being reassigned and to whom.

## 4.4.0 Accessibility Needs

- The modal dialog must be keyboard-navigable and properly announced by screen readers.
- All interactive elements must have clear focus states and accessible labels.

# 5.0.0 Business Rules

- {'rule_id': 'BR-009-1', 'rule_description': "A user with the 'Supervisor' role cannot be deactivated if they are the designated `supervisorId` for any user with an 'active' status.", 'enforcement_point': 'Server-side, before executing the user deactivation logic.', 'violation_handling': 'The deactivation request is rejected, and an error message is returned to the client, triggering the reassignment workflow.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-008

#### 6.1.1.2 Dependency Reason

This story modifies the basic user deactivation flow. The core deactivation functionality must exist first.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-002

#### 6.1.2.2 Dependency Reason

The system needs the concept of user roles ('Supervisor', 'Admin') and the `supervisorId` field on user documents, which are established during user creation and management.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user status management.
- Firestore database for storing user roles and relationships (`supervisorId`).
- Firebase Cloud Functions for server-side validation logic.

## 6.3.0.0 Data Dependencies

- Requires access to the `users` collection to query for subordinates based on `supervisorId` and `status`.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The server-side check for subordinates must complete in under 500ms to provide a responsive UI experience for the Admin.

## 7.2.0.0 Security

- The entire deactivation and reassignment process must be protected by Firestore Security Rules or a secured Cloud Function, ensuring only an Admin of the same tenant can perform the action.
- The list of potential new supervisors must be securely filtered to only show eligible users within the Admin's tenant.

## 7.3.0.0 Usability

- The workflow must be intuitive, guiding the Admin clearly from the blocked action to the required resolution (reassignment).

## 7.4.0.0 Accessibility

- The modal and reassignment interface must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported browsers for the web dashboard (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a new UI component (modal/reassignment view) on the frontend.
- Requires server-side logic (preferably a callable Cloud Function) to handle the check, block, and atomic reassignment.
- The reassignment of multiple subordinates must be performed as an atomic batch write in Firestore to ensure data consistency.

## 8.3.0.0 Technical Risks

- Potential for race conditions if the Admin has multiple tabs open. The server-side logic must be the single source of truth.
- Ensuring the query for subordinates is performant at scale requires a composite index on `supervisorId` and `status` in the `users` collection.

## 8.4.0.0 Integration Points

- Integrates with the existing User Management table/list in the Admin web dashboard.
- The backend logic will interact directly with the Firestore `users` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Attempt to deactivate a supervisor with 1, 5, and 0 active subordinates.
- Complete the full reassignment flow and then successfully deactivate.
- Cancel the reassignment flow and verify no data has changed.
- Verify the list of new potential supervisors is correctly filtered.
- Attempt to deactivate a supervisor whose only subordinates are already deactivated.

## 9.3.0.0 Test Data Needs

- A tenant with an Admin user.
- At least two Supervisor users.
- Multiple Subordinate users assigned to one of the supervisors.
- A Supervisor user with no subordinates.
- A Supervisor user with only deactivated subordinates.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for integration testing.
- Jest for Cloud Function unit tests.
- `flutter_test` for frontend widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for the Cloud Function and frontend logic, achieving >80% coverage
- Integration testing of the full Admin workflow completed successfully against the Emulator Suite
- User interface for the reassignment modal reviewed and approved for usability and accessibility
- Performance of the subordinate check is verified to be within the defined limit
- Security rules/function permissions are validated to restrict access to Admins
- Documentation for the user deactivation process is updated to include this workflow
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a dependency for any large-scale user offboarding process. It should be prioritized to ensure data integrity early in the project.
- Requires both frontend (Flutter Web) and backend (TypeScript Cloud Function) development effort.

## 11.4.0.0 Release Impact

- This is a core administrative feature. Its absence would be considered a major flaw in the user management module.

