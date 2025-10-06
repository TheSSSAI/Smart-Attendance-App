# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-060 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin filters attendance reports by multiple crite... |
| As A User Story | As an Admin, I want to apply filters for date rang... |
| User Persona | Admin: A user with full access to their tenant's d... |
| Business Value | Enables efficient and targeted data analysis, savi... |
| Functional Area | Reporting and Analytics |
| Story Theme | Admin Dashboard Enhancements |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Filter by Date Range

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the Admin is viewing an attendance report on the web dashboard

### 3.1.5 When

the Admin selects a start date and an end date using a date range picker

### 3.1.6 Then

the report data refreshes to display only attendance records with a 'checkInTime' within the selected date range (inclusive).

### 3.1.7 Validation Notes

Verify that records from the day before the start date and the day after the end date are not visible.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Filter by a single User

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Admin is viewing an attendance report

### 3.2.5 When

the Admin selects a specific user from a searchable, multi-select dropdown

### 3.2.6 Then

the report data refreshes to display only attendance records for that selected user.

### 3.2.7 Validation Notes

The user dropdown should be populated with all active users in the tenant and be searchable by name or email.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Filter by a single Team

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Admin is viewing an attendance report

### 3.3.5 When

the Admin selects a specific team from a multi-select dropdown

### 3.3.6 Then

the report data refreshes to display attendance records for all users who are members of that selected team.

### 3.3.7 Validation Notes

Verify that records for users not in the selected team are excluded.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Filter by Status

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the Admin is viewing an attendance report

### 3.4.5 When

the Admin selects one or more statuses (e.g., 'approved', 'rejected') from a multi-select dropdown

### 3.4.6 Then

the report data refreshes to display only attendance records matching any of the selected statuses.

### 3.4.7 Validation Notes

The status filter should support 'pending', 'approved', 'rejected', and also allow filtering by flags like 'manually-corrected' or 'offlineEntry'.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Combine multiple filters (Date, Team, and Status)

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

the Admin is viewing an attendance report

### 3.5.5 When

the Admin selects a date range, a specific team, AND the 'rejected' status

### 3.5.6 Then

the report data refreshes to display only records that match ALL applied criteria (logical AND).

### 3.5.7 Validation Notes

Test with a dataset where some records match all criteria and others match only one or two, ensuring only the former are displayed.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Clear all applied filters

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

the Admin has applied one or more filters to the report

### 3.6.5 When

the Admin clicks a 'Clear Filters' or 'Reset' button

### 3.6.6 Then

all filter controls are reset to their default state and the report data reverts to the complete, unfiltered view.

### 3.6.7 Validation Notes

Verify that date pickers are cleared, and all selections in dropdowns are removed.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Filter combination yields no results

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

the Admin is viewing an attendance report

### 3.7.5 When

the Admin applies a combination of filters that does not match any records in the database

### 3.7.6 Then

the report area displays a user-friendly message, such as 'No records match the selected criteria', instead of an empty table.

### 3.7.7 Validation Notes

The UI should not show an error, but rather an informational message.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

UI indicates active filters

### 3.8.3 Scenario Type

Happy_Path

### 3.8.4 Given

the Admin has applied one or more filters

### 3.8.5 When

the report data is displayed

### 3.8.6 Then

there is a clear visual indication of which filters are currently active (e.g., filter tags above the report table).

### 3.8.7 Validation Notes

For example, display tags like 'Team: Engineering' or 'Status: Approved'.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Date range picker component
- Searchable, multi-select dropdown for Users
- Multi-select dropdown for Teams
- Multi-select dropdown for Statuses/Flags
- A 'Clear Filters' button
- Visual tags or indicators for applied filters
- A loading indicator shown while data is being fetched
- An informational message area for 'No results found'

## 4.2.0 User Interactions

- Selecting a date range triggers a data refresh.
- Selecting/deselecting items in dropdowns triggers a data refresh.
- Typing in the user filter dropdown should dynamically search and filter the list of users.
- Clicking 'Clear Filters' resets all filter controls and triggers a data refresh.

## 4.3.0 Display Requirements

- The filter controls must be logically grouped and positioned above the report data.
- The number of records found should be displayed.
- Applied filters must be clearly visible to the user.

## 4.4.0 Accessibility Needs

- All filter controls must be keyboard accessible (tab navigation, selection with Enter/Space).
- All controls must have appropriate ARIA labels for screen readers.
- Sufficient color contrast must be used for all UI elements, per WCAG 2.1 AA standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Filter logic across different filter types (Date, User, Team, Status) must be combined using a logical AND.

### 5.1.3 Enforcement Point

Backend query construction (Firestore).

### 5.1.4 Violation Handling

N/A - This is a system logic rule.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Filter logic within a single multi-select filter type (e.g., selecting multiple statuses) must be combined using a logical OR (e.g., status is 'approved' OR 'pending').

### 5.2.3 Enforcement Point

Backend query construction (Firestore 'in' operator).

### 5.2.4 Violation Handling

N/A - This is a system logic rule.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-059

#### 6.1.1.2 Dependency Reason

A basic reporting view must exist before filters can be added to it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-011

#### 6.1.2.2 Dependency Reason

Team data structures must be implemented to allow filtering by team.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

REQ-REP-001

#### 6.1.3.2 Dependency Reason

The overall requirement for an Admin reporting dashboard must be established, defining the data to be filtered.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore for data storage and querying.
- Flutter for Web for the Admin dashboard UI.
- A UI component library providing accessible date pickers and multi-select dropdowns.

## 6.3.0.0 Data Dependencies

- Requires access to `attendance`, `users`, and `teams` collections in Firestore.
- The `attendance` documents must be structured with queryable fields for `userId`, `teamId` (or derivable), `status`, `flags`, and `checkInTime`.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Report data refresh after applying/changing a filter should complete in under 2 seconds for a tenant with up to 10,000 attendance records.
- The user and team filter dropdowns should load and be interactive within 1 second for tenants with up to 1,000 users/teams.

## 7.2.0.0 Security

- All queries for report data must be scoped to the Admin's `tenantId` via Firestore Security Rules.
- Input from filter controls should be sanitized to prevent any form of injection attack, although Firestore SDKs largely mitigate this.

## 7.3.0.0 Usability

- The filtering process should be intuitive, with clear labels and immediate visual feedback (loading state, updated results).
- It should be easy to see which filters are currently active.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard must be fully functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Constructing dynamic, multi-conditional Firestore queries on the backend.
- Identifying, creating, and deploying the necessary composite indexes in Firestore is critical for performance and query success.
- Managing the state of multiple filters on the frontend and ensuring they correctly trigger data refetches.
- Ensuring the user/team selection components are performant for tenants with large numbers of users/teams.

## 8.3.0.0 Technical Risks

- Forgetting to create required composite indexes will cause queries to fail at runtime.
- Poorly constructed queries could lead to slow performance and high Firestore read costs for large tenants.

## 8.4.0.0 Integration Points

- This feature integrates directly with the Firestore database to query the `attendance` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget (Flutter)
- Integration
- E2E
- Performance
- Accessibility

## 9.2.0.0 Test Scenarios

- Test each filter individually.
- Test various combinations of 2, 3, and 4 filters.
- Test the 'clear filters' functionality from a filtered state.
- Test the 'no results found' scenario.
- Test filtering with a large dataset to verify performance and check for query timeouts.
- Test UI responsiveness and accessibility using keyboard navigation and screen readers.

## 9.3.0.0 Test Data Needs

- A seeded Firestore database with a variety of attendance records spanning multiple users, teams, statuses, and dates.
- At least one user who is a member of multiple teams.
- Records with different flags (`isOfflineEntry`, `manually-corrected`, etc.).

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and integration testing.
- `flutter_test` for unit and widget tests.
- `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- E2E integration testing completed successfully in a staging environment
- All required Firestore composite indexes are defined in `firestore.indexes.json` and deployed
- Performance requirements verified against a large, seeded dataset
- UI reviewed for usability and adherence to design specifications
- Accessibility requirements (WCAG 2.1 AA) validated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is dependent on US-059 (Admin views summary reports) and should be scheduled in a subsequent sprint.
- Allocate time for identifying and testing the required Firestore indexes, as this can be an iterative process.

## 11.4.0.0 Release Impact

This is a key feature for the reporting module, significantly increasing its value for administrative users. It is a high-priority item for the release containing reporting features.

