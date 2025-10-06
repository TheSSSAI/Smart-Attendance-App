# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-051 |
| Elaboration Date | 2024-10-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views the audit log of data changes |
| As A User Story | As an Admin, I want to view a filterable and immut... |
| User Persona | Admin user responsible for tenant oversight, compl... |
| Business Value | Provides a trustworthy, unalterable record for int... |
| Functional Area | Reporting and Administration |
| Story Theme | Auditing and Compliance |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin views the audit log with default settings

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard

### 3.1.5 And

the view is paginated to handle a large number of entries

### 3.1.6 When

I navigate to the 'Audit Log' section

### 3.1.7 Then

I see a list of audit log entries displayed in reverse chronological order (newest first)

### 3.1.8 Validation Notes

Verify the default sort order and that pagination controls are visible if the number of records exceeds the page size.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Audit log entry displays all required information

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am viewing the audit log

### 3.2.5 When

I inspect an individual log entry

### 3.2.6 Then

it must clearly display the following fields: 'Timestamp', 'Actor' (user who performed the action), 'Action Type' (e.g., 'Direct Edit'), 'Target Entity' (a human-readable description of what was changed), and 'Justification' (if applicable)

### 3.2.7 Validation Notes

Check an entry for a direct edit (REQ-FUN-014) and confirm the justification text is visible. Check an entry for a correction approval and confirm all fields are present.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin filters the audit log by date range

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I am viewing the audit log with entries spanning multiple days

### 3.3.5 When

I select a start and end date using the date range filter and apply it

### 3.3.6 Then

the list of entries is updated to show only the actions that occurred within that date range, inclusive

### 3.3.7 Validation Notes

Test with a single-day range and a multi-day range. The UI should prevent selecting an end date before the start date.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin filters the audit log by Actor

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

I am viewing the audit log with entries from multiple users

### 3.4.5 When

I select a specific user from the 'Actor' filter dropdown and apply it

### 3.4.6 Then

the list of entries is updated to show only the actions performed by that selected user

### 3.4.7 Validation Notes

The Actor filter should be populated with a list of all users within the tenant.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin filters the audit log by Action Type

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

I am viewing the audit log with entries of different action types (e.g., 'Direct Edit', 'User Deactivation')

### 3.5.5 When

I select one or more action types from the 'Action Type' filter and apply it

### 3.5.6 Then

the list of entries is updated to show only the actions matching the selected types

### 3.5.7 Validation Notes

The filter should support multi-selection of action types.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin combines multiple filters

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

I am viewing the audit log

### 3.6.5 When

I apply a filter for a specific Actor AND a specific date range

### 3.6.6 Then

the list of entries is updated to show only actions performed by that actor within that date range

### 3.6.7 Validation Notes

Verify that combining filters uses an AND condition.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Viewing an audit log with no entries

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

I am an Admin for a brand new tenant where no auditable actions have occurred

### 3.7.5 When

I navigate to the 'Audit Log' section

### 3.7.6 Then

a clear message is displayed, such as 'No audit log entries found.'

### 3.7.7 Validation Notes

The view should not show an empty table or an error.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

Applying filters that yield no results

### 3.8.3 Scenario Type

Error_Condition

### 3.8.4 Given

I am viewing the audit log

### 3.8.5 When

I apply a set of filters that do not match any existing log entries

### 3.8.6 Then

the list becomes empty and a clear message is displayed, such as 'No entries match your filter criteria.'

### 3.8.7 Validation Notes

This confirms the filtering logic is working correctly and provides good user feedback.

## 3.9.0 Criteria Id

### 3.9.1 Criteria Id

AC-009

### 3.9.2 Scenario

Viewing an entry for a deleted/anonymized user

### 3.9.3 Scenario Type

Edge_Case

### 3.9.4 Given

an auditable action was performed by a user who has since been deactivated and anonymized per the data retention policy

### 3.9.5 When

I view the audit log containing that action

### 3.9.6 Then

the 'Actor' field for that entry displays the non-reversible, anonymized identifier (e.g., 'DeletedUser-XYZ') instead of the user's personal information

### 3.9.7 Validation Notes

This is critical for GDPR compliance and data retention policies (see Data Retention Policy section in SRS).

## 3.10.0 Criteria Id

### 3.10.1 Criteria Id

AC-010

### 3.10.2 Scenario

Viewing detailed change data

### 3.10.3 Scenario Type

Alternative_Flow

### 3.10.4 Given

I am viewing an audit log entry for a 'Direct Edit' action

### 3.10.5 When

I click on the entry to view more details

### 3.10.6 Then

a modal or expandable section appears, showing the 'Old Value' and 'New Value' for the fields that were changed

### 3.10.7 Validation Notes

The presentation of the diff should be clear and easy to understand.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A data table or list to display log entries
- Date range picker for filtering
- Searchable dropdown for 'Actor' filter
- Multi-select dropdown for 'Action Type' filter
- 'Apply Filters' and 'Reset Filters' buttons
- Pagination controls (e.g., 'Next', 'Previous', page numbers)
- Modal or expandable row component to show detailed change data

## 4.2.0 User Interactions

- Admin navigates to the Audit Log via the main dashboard navigation.
- Applying filters updates the list of log entries.
- Resetting filters returns the list to its default state (all entries, sorted by newest).
- Clicking a log entry reveals more detailed information about the change.

## 4.3.0 Display Requirements

- Timestamps must be displayed in the tenant's configured timezone (REQ-FUN-069).
- The UI must clearly indicate when filters are active.
- Informative messages must be shown for empty states (no logs at all, or no results from filtering).

## 4.4.0 Accessibility Needs

- The log table must be keyboard navigable.
- Table headers must be correctly associated with their cells for screen readers.
- All interactive elements (filters, buttons) must have accessible labels (aria-labels).

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

The audit log is immutable. Entries cannot be edited or deleted by any user, including Admins, through the application interface.

### 5.1.3 Enforcement Point

Firestore Security Rules on the `/auditLog/{logId}` path.

### 5.1.4 Violation Handling

Any `update` or `delete` request to the collection will be denied by Firestore rules, returning a 'Permission Denied' error.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Only users with the 'Admin' role can view the audit log for their tenant.

### 5.2.3 Enforcement Point

Firestore Security Rules on the `/auditLog/{logId}` path, checking for `request.auth.token.role == 'Admin'` and matching `tenantId`.

### 5.2.4 Violation Handling

Any `get` or `list` request from a non-Admin user will be denied by Firestore rules.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-050

#### 6.1.1.2 Dependency Reason

This story (Admin directly edits an attendance record) is a primary source of audit log entries. The data model for the log entry must be defined and implemented there first.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-047

#### 6.1.2.2 Dependency Reason

This story (Supervisor approves an attendance correction request) also generates audit log entries that need to be displayed.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-008

#### 6.1.3.2 Dependency Reason

This story (Admin deactivates a user's account) is another critical action that must be logged and will be viewed via this story.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-086

#### 6.1.4.2 Dependency Reason

This story (User's personal data is anonymized) defines the process for anonymizing user data, which the audit log view must correctly display.

## 6.2.0.0 Technical Dependencies

- Firestore database with the `/auditLog` collection schema defined (REQ-DAT-001).
- Firebase Authentication for role-based access control.
- Flutter for Web framework for the Admin dashboard UI.

## 6.3.0.0 Data Dependencies

- Existence of data in the `/auditLog` collection to test the viewing and filtering functionality.
- Access to the `/users` collection to populate the 'Actor' filter.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Initial page load of the audit log should complete in under 2 seconds.
- Applying filters and refreshing the data should complete in under 1.5 seconds.
- This requires defining and deploying appropriate composite indexes in `firestore.indexes.json` for all filterable fields.

## 7.2.0.0 Security

- All access to the audit log data must be enforced by Firestore Security Rules, ensuring tenant isolation and role-based access.
- The audit log collection must be configured to be immutable (create-only) via security rules.

## 7.3.0.0 Usability

- The log must be easy to read and scan.
- Filtering should be intuitive and provide immediate feedback.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Firestore Querying: Designing efficient queries and the corresponding composite indexes for multi-field filtering is critical for performance.
- Pagination Logic: Implementing robust server-side pagination with Firestore cursors.
- UI State Management: Managing the state of multiple filters, pagination, and the resulting data list on the client-side.
- Data Presentation: Creating a flexible UI component to display the 'details' of various action types, which may have different data structures.

## 8.3.0.0 Technical Risks

- Poorly designed Firestore indexes could lead to slow query performance and high read costs as the log grows.
- Failure to properly handle the anonymized user data case could lead to data privacy violations or application errors.

## 8.4.0.0 Integration Points

- Reads from the Firestore `/auditLog` collection.
- Reads from the Firestore `/users` collection to populate the actor filter.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Performance
- Security

## 9.2.0.0 Test Scenarios

- Verify that a non-admin user cannot access the audit log page or API endpoint.
- Test filtering with all possible combinations of filters.
- Test pagination by populating the log with more records than the page size and navigating between pages.
- Test the display of an audit log entry for every defined auditable action type.
- Verify the anonymized user ID is displayed correctly after a user is deleted.

## 9.3.0.0 Test Data Needs

- A tenant with multiple users (Admin, Supervisor, Subordinate).
- A populated `auditLog` collection with at least 50 entries, covering multiple actors, action types, and dates.
- At least one user who has been deactivated and anonymized, with corresponding log entries.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for integration testing.
- `flutter_test` for unit/widget tests.
- `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage
- Integration testing against the Firebase Emulator completed successfully
- E2E test scenario for viewing and filtering the log is implemented and passing
- Firestore Security Rules for immutability and access control are implemented and tested
- Required Firestore composite indexes are defined in `firestore.indexes.json` and deployed
- UI reviewed for usability and adherence to design specifications
- Performance requirements for loading and filtering are verified
- Documentation for the audit log feature is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

8

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story depends on the completion of features that generate audit log data. It should be scheduled in a sprint after those prerequisite stories are done.
- The data model for the `auditLog` collection must be finalized and agreed upon before starting implementation.

## 11.4.0.0 Release Impact

This is a key feature for enterprise customers and organizations with compliance requirements. Its inclusion is critical for marketing the product to these segments.

