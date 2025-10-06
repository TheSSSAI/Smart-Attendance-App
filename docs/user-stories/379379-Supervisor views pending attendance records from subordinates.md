# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-037 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor views pending attendance records from s... |
| As A User Story | As a Supervisor, I want to see a clear and filtera... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Enables the core attendance approval workflow, ens... |
| Functional Area | Attendance Management & Approval Workflows |
| Story Theme | Supervisor Dashboard |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-037-001

### 3.1.2 Scenario

Happy Path: Supervisor views a list of pending records

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Supervisor is logged in and has at least one direct subordinate with an attendance record in 'pending' status

### 3.1.5 When

the Supervisor navigates to their main dashboard or attendance review screen

### 3.1.6 Then

a list of all 'pending' attendance records from their direct subordinates is displayed.

### 3.1.7 Validation Notes

Verify by creating a Supervisor, two subordinates under them, and one subordinate under a different supervisor. Create 'pending' records for all three subordinates. Log in as the first Supervisor and confirm only the two relevant records appear.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-037-002

### 3.2.2 Scenario

Data Filtering: List only shows 'pending' records

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Supervisor's subordinate has multiple attendance records with statuses 'pending', 'approved', and 'rejected'

### 3.2.5 When

the Supervisor views the attendance review screen

### 3.2.6 Then

only the records with the 'pending' status are displayed in the list.

### 3.2.7 Validation Notes

Check the Firestore query to ensure it explicitly filters for `status == 'pending'`.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-037-003

### 3.3.2 Scenario

Data Scoping: List only shows records from direct subordinates

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

a Supervisor is logged in

### 3.3.5 When

the system fetches attendance records for their dashboard

### 3.3.6 Then

the query must filter records where the `supervisorId` field matches the logged-in Supervisor's `userId`.

### 3.3.7 Validation Notes

This must be enforced by both the client-side query and server-side Firestore Security Rules. Test security rules to ensure a Supervisor cannot read records where the `supervisorId` does not match their own ID.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-037-004

### 3.4.2 Scenario

UI Display: Essential information is visible for each record

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the list of pending records is displayed

### 3.4.5 When

the Supervisor reviews a record in the list

### 3.4.6 Then

each list item must clearly display the Subordinate's full name, the date of the attendance record, the check-in time, and the check-out time (or a placeholder like '--:--' if not yet checked out).

### 3.4.7 Validation Notes

Visually inspect the UI to confirm all required data fields are present and correctly formatted.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-037-005

### 3.5.2 Scenario

Edge Case: Supervisor has no pending records to review

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

a Supervisor is logged in and none of their subordinates have any 'pending' attendance records

### 3.5.5 When

the Supervisor navigates to the attendance review screen

### 3.5.6 Then

a user-friendly message is displayed, such as 'No pending records to review.', instead of an empty list.

### 3.5.7 Validation Notes

Ensure the UI handles the empty state gracefully without showing a blank screen or loading spinner indefinitely.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-037-006

### 3.6.2 Scenario

Real-time Updates: List updates when a new record is submitted

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

a Supervisor is viewing their attendance review screen

### 3.6.5 When

one of their direct subordinates submits a new attendance record (checks in)

### 3.6.6 Then

the new 'pending' record automatically appears at the top of the list without requiring a manual refresh.

### 3.6.7 Validation Notes

Test using two devices simultaneously. Have the subordinate check-in and verify the record appears on the supervisor's screen within 2-3 seconds.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-037-007

### 3.7.2 Scenario

Error Condition: Data fetch fails due to network issues

### 3.7.3 Scenario Type

Error_Condition

### 3.7.4 Given

a Supervisor attempts to view the attendance review screen

### 3.7.5 When

the device has no network connectivity

### 3.7.6 Then

a non-intrusive error message is displayed (e.g., a snackbar or inline message) indicating a connection issue and providing an option to retry.

### 3.7.7 Validation Notes

Use device settings to disable network connectivity and verify the app's behavior.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A list view to display attendance records.
- List items with dedicated space for Subordinate Name, Date, Check-In Time, and Check-Out Time.
- A message area for displaying the 'No pending records' text.
- A loading indicator to show while data is being fetched initially.

## 4.2.0 User Interactions

- The list must be vertically scrollable.
- Tapping on a list item will navigate to the detail view for that record (functionality for the detail view is covered in another story).
- The list should be sorted by record date in descending order (newest first).

## 4.3.0 Display Requirements

- Timestamps should be displayed in a human-readable format (e.g., 'hh:mm AM/PM') according to the tenant's timezone.
- Dates should be clearly formatted (e.g., 'MMM DD, YYYY').

## 4.4.0 Accessibility Needs

- List items must be focusable and navigable using accessibility services (e.g., TalkBack, VoiceOver).
- Screen readers should announce the full details of each record, e.g., 'Pending attendance for John Doe on January 15, 2025. Check-in at 9:01 AM.'

# 5.0.0 Business Rules

- {'rule_id': 'BR-SUP-001', 'rule_description': 'A Supervisor can only view attendance records for users who are their direct subordinates.', 'enforcement_point': 'Firestore Security Rules on read operations for the `/attendance` collection.', 'violation_handling': 'The read request is denied by the database, and no data is returned to the client.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

Supervisor must be able to log in to access their dashboard.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-011

#### 6.1.2.2 Dependency Reason

The concept of a Supervisor assigned to a team must exist.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-015

#### 6.1.3.2 Dependency Reason

Subordinates must be assigned to a Supervisor for the relationship to be established.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-028

#### 6.1.4.2 Dependency Reason

Subordinates must be able to create attendance records for them to be reviewed.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user roles and identity.
- Firebase Firestore as the data source.
- A finalized data model for the `attendance` collection, including `supervisorId`, `userId`, and `status` fields.

## 6.3.0.0 Data Dependencies

- Existence of user profiles with 'Supervisor' and 'Subordinate' roles.
- Existence of attendance records with a 'pending' status.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The list of pending records must load in under 2 seconds on a stable 4G connection.
- The Firestore query must be backed by a composite index (`supervisorId`, `status`) to ensure efficient reads at scale.

## 7.2.0.0 Security

- Access to attendance data must be strictly controlled by Firestore Security Rules based on the user's role and their `supervisorId` relationship to the data's owner.
- A Supervisor must be prevented from accessing any attendance data that does not belong to one of their direct subordinates.

## 7.3.0.0 Usability

- The dashboard should be the default or an easily accessible screen for the Supervisor upon login.
- The information presented should be clear and scannable to allow for quick review.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a performant, real-time Firestore query with a composite index.
- Requires robust Firestore Security Rules to enforce data access boundaries.
- State management for the real-time list needs to be handled correctly to avoid memory leaks or unnecessary rebuilds.
- May require denormalizing the subordinate's name onto the attendance record to avoid N+1 query problems when fetching the list.

## 8.3.0.0 Technical Risks

- An incorrectly configured Firestore index could lead to poor performance or high query costs with a large number of records.
- Insecure or overly permissive security rules could lead to data leakage between teams.

## 8.4.0.0 Integration Points

- Firebase Authentication (to get the current user's ID).
- Firestore Database (to query the `/attendance` collection).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Security

## 9.2.0.0 Test Scenarios

- Verify list displays correct records for a supervisor with multiple subordinates.
- Verify list is empty and shows the correct message when there are no pending records.
- Verify records from other teams do not appear.
- Verify records with 'approved' or 'rejected' status do not appear.
- Verify real-time addition of a new record.
- Test Firestore security rules to ensure a supervisor cannot read another team's data.

## 9.3.0.0 Test Data Needs

- At least two Supervisors.
- At least three Subordinates, with two assigned to the first Supervisor and one to the second.
- Attendance records for all subordinates with a mix of 'pending', 'approved', and 'rejected' statuses.

## 9.4.0.0 Testing Tools

- Flutter Test Framework (`flutter_test`) for unit and widget tests.
- Firebase Local Emulator Suite for integration and security rule testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for the new logic
- Integration testing with the Firebase Emulator completed successfully
- Firestore Security Rules for this feature are written and tested
- Required Firestore composite index is defined in `firestore.indexes.json`
- User interface reviewed and approved by the PO/designer
- Performance requirements (load time) verified
- Accessibility requirements (screen reader support) validated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story for the Supervisor role and blocks subsequent approval/rejection stories (US-039, US-040). It should be prioritized early in the development cycle.
- Requires coordination on the data model to ensure the `supervisorId` is correctly populated on attendance records.

## 11.4.0.0 Release Impact

This feature is critical for the Minimum Viable Product (MVP) for the Supervisor user role.

