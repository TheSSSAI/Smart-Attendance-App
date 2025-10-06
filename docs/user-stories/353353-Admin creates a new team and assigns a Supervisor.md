# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-011 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin creates a new team and assigns a Supervisor |
| As A User Story | As an Admin, I want to create a new team by provid... |
| User Persona | Admin: A user with full administrative privileges ... |
| Business Value | Enables the foundational hierarchical structure of... |
| Functional Area | Tenant Administration |
| Story Theme | User and Team Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-011-01

### 3.1.2 Scenario

Successful creation of a new team

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and I am on the 'Team Management' page

### 3.1.5 When

I click the 'Create Team' button, enter a unique team name, select a valid user with the 'Supervisor' role from the list, and click 'Save'

### 3.1.6 Then

a new team document is created in the Firestore `/tenants/{tenantId}/teams/{teamId}` collection with the specified name and the selected user's ID as `supervisorId`.

### 3.1.7 And

a success notification ('Team created successfully') is displayed.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-011-02

### 3.2.2 Scenario

Attempt to create a team with a duplicate name

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am an Admin on the 'Create Team' form, and a team named 'Field Operations' already exists in my tenant

### 3.2.5 When

I enter 'Field Operations' as the team name and attempt to save

### 3.2.6 Then

the system prevents the creation of the team.

### 3.2.7 And

the form remains open for me to correct the input.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-011-03

### 3.3.2 Scenario

Attempt to create a team with a blank name

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am an Admin on the 'Create Team' form

### 3.3.5 When

I leave the team name field blank and attempt to save

### 3.3.6 Then

the form submission is blocked.

### 3.3.7 And

an inline validation error message is displayed: 'Team name is required.'

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-011-04

### 3.4.2 Scenario

Attempt to create a team without selecting a Supervisor

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am an Admin on the 'Create Team' form

### 3.4.5 When

I enter a valid team name but do not select a Supervisor and attempt to save

### 3.4.6 Then

the form submission is blocked.

### 3.4.7 And

an inline validation error message is displayed: 'A Supervisor must be assigned.'

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-011-05

### 3.5.2 Scenario

Supervisor selection list is correctly populated

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

I am an Admin on the 'Create Team' form

### 3.5.5 When

I click on the 'Select Supervisor' dropdown

### 3.5.6 Then

the list only contains active users from my tenant who have the 'Supervisor' or 'Admin' role.

### 3.5.7 And

deactivated or subordinate-only users are not displayed in the list.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-011-06

### 3.6.2 Scenario

User cancels the team creation process

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

I am an Admin on the 'Create Team' form with data entered

### 3.6.5 When

I click the 'Cancel' button or close the modal

### 3.6.6 Then

the form is closed without creating a new team.

### 3.6.7 And

I am returned to the 'Team Management' page.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Create Team' button on the main team management screen.
- A modal dialog for the team creation form.
- A text input field for 'Team Name'.
- A searchable dropdown/autocomplete component for 'Assign Supervisor'.
- A 'Save' button, which is disabled until all required fields are valid.
- A 'Cancel' button.

## 4.2.0 User Interactions

- Clicking 'Create Team' opens the creation modal.
- Typing in the Supervisor dropdown filters the list of eligible users.
- Selecting a user from the dropdown populates the field.
- Clicking 'Save' with valid data closes the modal and refreshes the team list.
- Clicking 'Cancel' closes the modal with no changes.

## 4.3.0 Display Requirements

- The Supervisor dropdown should display the user's full name and email to avoid ambiguity.
- Real-time inline validation messages for required fields and duplicate names must be shown.

## 4.4.0 Accessibility Needs

- All form fields must have associated labels for screen readers.
- The modal must be keyboard navigable, and focus must be trapped within it.
- Error messages must be associated with their respective form fields using `aria-describedby`.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-TEAM-001

### 5.1.2 Rule Description

A team name must be unique within a single tenant.

### 5.1.3 Enforcement Point

Server-side (Firestore Security Rule/Cloud Function) and client-side validation upon form submission.

### 5.1.4 Violation Handling

Prevent the write operation and return an error message to the client.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-TEAM-002

### 5.2.2 Rule Description

A team must be assigned exactly one Supervisor.

### 5.2.3 Enforcement Point

Client-side form validation and Firestore schema validation.

### 5.2.4 Violation Handling

Prevent form submission if a supervisor is not selected.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant must exist before a team can be created within it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-004

#### 6.1.2.2 Dependency Reason

Users must be created and assigned roles (specifically 'Supervisor') before they can be assigned to lead a team.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for Admin role verification.
- Firestore for storing team data and querying for existing users.
- Flutter for Web framework for the Admin dashboard UI.

## 6.3.0.0 Data Dependencies

- Requires access to the `/tenants/{tenantId}/users` collection to populate the list of potential supervisors.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The list of potential supervisors in the dropdown should load in under 2 seconds for a tenant with up to 1,000 users.

## 7.2.0.0 Security

- Firestore Security Rules must ensure that only an authenticated user with the 'Admin' custom claim for the correct `tenantId` can create documents in the `/teams` subcollection.
- Input validation must be performed on the team name to prevent injection attacks.

## 7.3.0.0 Usability

- The process of creating a team should be intuitive and require minimal steps.
- Error feedback must be clear, immediate, and guide the user to a solution.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard must function correctly on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Implementing the searchable, paginated dropdown for supervisor selection to ensure performance with a large number of users.
- Writing and thoroughly testing the Firestore Security Rules to prevent unauthorized creation.
- Ensuring robust client-side and server-side validation for unique team names to prevent race conditions.

## 8.3.0.0 Technical Risks

- Poor query performance when fetching the list of supervisors if the database is not indexed correctly.
- Potential for a race condition if two admins try to create a team with the same name simultaneously. This should be handled by Firestore's transaction or security rules.

## 8.4.0.0 Integration Points

- Reads from the `/users` collection.
- Writes to the `/teams` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget (Flutter)
- Integration
- Security
- E2E

## 9.2.0.0 Test Scenarios

- Verify successful team creation and its appearance in the UI.
- Test all validation rules: duplicate name, empty name, no supervisor selected.
- Test the supervisor dropdown filtering logic.
- Test the 'Cancel' functionality.
- Write security rule tests to confirm a non-admin user or an admin from another tenant cannot create a team.
- Test the UI's responsiveness on different screen sizes.

## 9.3.0.0 Test Data Needs

- A test tenant with multiple users, including some with 'Supervisor' roles and some without.
- A test tenant with at least one existing team to test the duplicate name validation.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration and security rule testing.
- `flutter_test` for unit and widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >= 80% code coverage for new logic
- Firestore Security Rules written and tested to cover all access scenarios
- Integration testing completed successfully against the Firebase Emulator Suite
- User interface reviewed and approved by the Product Owner/UX designer
- Feature is manually verified and passes QA in the staging environment
- No accessibility violations are introduced
- Relevant documentation (if any) is updated

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story and a blocker for any features related to team management or team-based assignments (e.g., US-014, US-015, US-055). It should be prioritized early in the development cycle.

## 11.4.0.0 Release Impact

- This feature is critical for the initial setup of any new organization. The application is not usable for hierarchical organizations without it.

