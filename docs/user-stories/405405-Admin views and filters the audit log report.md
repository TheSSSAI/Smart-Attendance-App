# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-063 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views and filters the audit log report |
| As A User Story | As an Admin, I want to access a detailed and filte... |
| User Persona | The 'Admin' user role, responsible for tenant-wide... |
| Business Value | Provides a tamper-proof record of critical activit... |
| Functional Area | Reporting and Administration |
| Story Theme | Tenant Security and Compliance |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin accesses the audit log report and views records

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the Admin is logged in and is on the web dashboard

### 3.1.5 When

the Admin navigates to the 'Audit Log Report' section

### 3.1.6 Then

the system displays a list of audit log entries in reverse chronological order (newest first)

### 3.1.7 Validation Notes

Verify that the report page loads and displays data from the `/auditLog` collection. Each row must show at least Timestamp, Actor (User Name/Email), and Action Type.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin filters the audit log by date range

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Admin is viewing the audit log report

### 3.2.5 When

the Admin selects a start date and an end date and applies the filter

### 3.2.6 Then

the list of entries updates to show only records with a timestamp within the selected date range (inclusive)

### 3.2.7 Validation Notes

Test with a date range that includes some records and a range that excludes all records. Verify the query is inclusive of the start and end dates.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin filters the audit log by user (actor)

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Admin is viewing the audit log report

### 3.3.5 When

the Admin selects a user from a searchable dropdown list of tenant users and applies the filter

### 3.3.6 Then

the list of entries updates to show only records where the selected user was the actor

### 3.3.7 Validation Notes

The user list should only contain users from the Admin's tenant. Verify the query correctly filters by `actorUserId`.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin filters the audit log by action type

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the Admin is viewing the audit log report

### 3.4.5 When

the Admin selects an action type (e.g., 'Direct Data Edit', 'User Deactivated') from a dropdown and applies the filter

### 3.4.6 Then

the list of entries updates to show only records matching the selected `actionType`

### 3.4.7 Validation Notes

The dropdown should contain a predefined list of all possible auditable action types. Verify the query correctly filters by the `actionType` field.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin combines multiple filters

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

the Admin is viewing the audit log report

### 3.5.5 When

the Admin applies a date range filter AND a user filter

### 3.5.6 Then

the list of entries updates to show only records that satisfy both criteria

### 3.5.7 Validation Notes

Test various combinations of filters to ensure the backend query correctly combines them with 'AND' logic. This will require a composite index in Firestore.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin views detailed information for a specific log entry

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

the Admin is viewing the list of audit log entries

### 3.6.5 When

the Admin clicks on a specific entry in the list

### 3.6.6 Then

a modal or expanded view is displayed showing all details for that entry, including `targetEntityId`, `details` (with `oldValue` and `newValue`), and `justification` if present

### 3.6.7 Validation Notes

Verify that all fields from the Firestore document are displayed in a readable format.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Applied filters result in no matching records

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

the Admin is viewing the audit log report

### 3.7.5 When

the Admin applies filters that do not match any existing audit log records

### 3.7.6 Then

the system displays a clear, user-friendly message such as 'No audit records match the selected criteria'

### 3.7.7 Validation Notes

Ensure the UI does not just show a blank space, but provides explicit feedback to the user.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

Audit log data is paginated

### 3.8.3 Scenario Type

Alternative_Flow

### 3.8.4 Given

the audit log contains more records than the page limit (e.g., 50)

### 3.8.5 When

the Admin views the audit log report

### 3.8.6 Then

the system displays the first page of results and provides pagination controls (e.g., 'Next', 'Previous', page numbers) to navigate through the full result set

### 3.8.7 Validation Notes

Verify that clicking 'Next' loads the subsequent set of records. This must be implemented with server-side pagination using Firestore cursors.

## 3.9.0 Criteria Id

### 3.9.1 Criteria Id

AC-009

### 3.9.2 Scenario

Audit log is immutable from the UI

### 3.9.3 Scenario Type

Security

### 3.9.4 Given

the Admin is viewing the audit log report

### 3.9.5 When

the Admin interacts with the list of entries or the detail view

### 3.9.6 Then

there are no UI elements (e.g., 'Edit', 'Delete' buttons) that would allow modification or deletion of a log entry

### 3.9.7 Validation Notes

Perform a visual inspection of the UI. Backend security rules must also enforce this immutability.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Date range picker (start and end date)
- Searchable dropdown for filtering by User (Actor)
- Dropdown for filtering by Action Type
- Apply Filters button
- Clear Filters button
- A data table/list to display audit log entries
- Pagination controls
- A modal or expandable section for viewing entry details

## 4.2.0 User Interactions

- Admin can select dates from a calendar widget.
- Admin can type to search for a user in the user filter dropdown.
- Applying filters triggers a data refresh in the main view.
- Clicking a log entry row opens its detailed view.
- Clearing filters resets the view to the default state (all logs, newest first).

## 4.3.0 Display Requirements

- The list view must display: Timestamp (in tenant's timezone), Actor Name/Email, Action Type, and a brief summary.
- The detail view must display all fields from the `auditLog` document.
- Timestamps should be formatted for human readability (e.g., 'Jan 24, 2025, 10:30:15 AM').

## 4.4.0 Accessibility Needs

- All filter controls and the data table must be keyboard-navigable and screen-reader accessible, compliant with WCAG 2.1 Level AA.
- Sufficient color contrast must be used for all text and UI elements.

# 5.0.0 Business Rules

- {'rule_id': 'BR-AUD-001', 'rule_description': 'The `auditLog` collection is immutable. Records written to this collection cannot be updated or deleted by any user role, including Admin, via application logic or security rules.', 'enforcement_point': 'Firestore Security Rules on the `/auditLog/{logId}` path.', 'violation_handling': 'Any `update` or `delete` request to the collection from a client SDK will be denied by Firestore.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-050

#### 6.1.1.2 Dependency Reason

This story ('Admin directly edits an attendance record') is a primary source of data for the audit log. The log needs events to display.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-008

#### 6.1.2.2 Dependency Reason

This story ('Admin deactivates a user's account') generates audit log entries that need to be viewable in the report.

## 6.2.0.0 Technical Dependencies

- Finalized data model for the `/auditLog` collection in Firestore (as per REQ-DAT-001).
- Backend logic (Cloud Functions) to populate the `auditLog` collection must be in place.
- Firestore Security Rules to enforce read-only access for Admins and immutability.
- Definition and deployment of necessary composite indexes in `firestore.indexes.json` to support combined filtering queries.

## 6.3.0.0 Data Dependencies

- The system must have generated sample audit log data with various actors, action types, and timestamps to allow for thorough testing of all filter and pagination functionality.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Filtered report results should load in under 3 seconds on a standard internet connection.
- Firestore queries for the report must be efficient and not rely on client-side filtering for core logic.

## 7.2.0.0 Security

- Only users with the 'Admin' role can access this report.
- Firestore Security Rules must prevent any non-Admin role from reading the `/auditLog` collection.
- Firestore Security Rules must prevent ALL roles from writing to or deleting from the `/auditLog` collection via the client.

## 7.3.0.0 Usability

- Filter controls should be intuitive and easy to use.
- The report should be easy to read and scan for information.

## 7.4.0.0 Accessibility

- The report must adhere to WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard feature must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The primary complexity is on the backend, specifically designing and testing the Firestore queries with multiple optional filters.
- Correctly defining and deploying the required composite indexes is critical for performance and functionality.
- Implementing efficient server-side pagination with Firestore cursors requires careful state management on the client.

## 8.3.0.0 Technical Risks

- Poorly configured Firestore indexes could lead to slow query performance, high operational costs, or query failures.
- If the actor's name is not denormalized into the audit log entry, displaying it will require extra client-side lookups, impacting performance.

## 8.4.0.0 Integration Points

- This feature reads directly from the Firebase Firestore `/auditLog` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security
- Performance

## 9.2.0.0 Test Scenarios

- Verify each filter works independently.
- Verify combinations of 2 or more filters work correctly.
- Verify pagination with a large dataset.
- Verify the 'no results' message is displayed correctly.
- Verify that a non-Admin user cannot access the report page.
- Verify (via automated or manual tests) that API calls to modify audit log data are rejected.

## 9.3.0.0 Test Data Needs

- A pre-populated set of at least 100 audit log records with diverse `actorUserId`, `actionType`, and `timestamp` values.

## 9.4.0.0 Testing Tools

- Flutter's `integration_test` for E2E testing.
- Firebase Local Emulator Suite for testing Firestore queries and security rules locally.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage
- Integration testing of Firestore queries and security rules completed successfully
- User interface reviewed and approved by the Product Owner
- Performance requirements (query speed) verified
- Security requirements (role access, immutability) validated
- All necessary Firestore indexes are defined in IaC and deployed
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- Requires close collaboration between frontend and backend developers to ensure the queries and indexes are aligned.
- The creation of test data should be an explicit sub-task for this story.

## 11.4.0.0 Release Impact

This is a key feature for enterprise customers and is critical for compliance and security narratives.

