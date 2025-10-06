# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-062 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views an exception report to identify and ma... |
| As A User Story | As an Admin, I want to view a dedicated exception ... |
| User Persona | Admin user responsible for data integrity, complia... |
| Business Value | Improves administrative efficiency by consolidatin... |
| Functional Area | Reporting and Analytics |
| Story Theme | Administrative Oversight and Data Auditing |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Viewing the exception report with all exception types

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard, and there are attendance records with various exception flags within my tenant

### 3.1.5 When

I navigate to the 'Reports' section and select the 'Exception Report'

### 3.1.6 Then

the system displays a paginated list of all attendance records that have at least one of the following flags: 'isOfflineEntry', 'auto-checked-out', 'manually-corrected', or 'clock_discrepancy'.

### 3.1.7 Validation Notes

Verify that the query correctly fetches records containing any of the specified flags in the 'flags' array field. The report should load within 3 seconds for a dataset of 10,000 records.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Each record in the report clearly indicates the exception type(s)

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am viewing the Exception Report

### 3.2.5 When

I look at the list of records

### 3.2.6 Then

each row must display clear visual indicators (e.g., colored tags or icons) for every exception type associated with that record (e.g., a record could be both 'Offline Entry' and 'Manually Corrected').

### 3.2.7 Validation Notes

Check a record with multiple flags to ensure all corresponding indicators are displayed.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Filtering the report by a single exception type

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I am viewing the Exception Report

### 3.3.5 When

I use the filter control to select only 'Missed Check-out' (i.e., 'auto-checked-out' flag)

### 3.3.6 Then

the report view updates to show only the attendance records that have the 'auto-checked-out' flag.

### 3.3.7 Validation Notes

Test this for each individual exception type to ensure the filter logic is correct.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Filtering the report by multiple exception types

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

I am viewing the Exception Report

### 3.4.5 When

I use the filter control to select both 'Offline Entry' and 'Clock Discrepancy'

### 3.4.6 Then

the report view updates to show records that have either the 'isOfflineEntry' flag OR the 'clock_discrepancy' flag.

### 3.4.7 Validation Notes

Verify the filter uses OR logic for multiple exception type selections.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Combining exception type filters with other standard filters

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

I am viewing the Exception Report

### 3.5.5 When

I filter by exception type 'Manually Corrected', a specific date range, and a specific team

### 3.5.6 Then

the report updates to show only records that meet all three criteria.

### 3.5.7 Validation Notes

Confirm that the query correctly combines the 'flags' array filter with filters on other fields like date and teamId.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Report displays a message when no exceptions are found

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

I am an Admin logged in, and there are no attendance records with exception flags for the selected filter criteria

### 3.6.5 When

I view the Exception Report or apply a filter that yields no results

### 3.6.6 Then

the system displays a user-friendly message, such as 'No exception records found for the selected criteria.'

### 3.6.7 Validation Notes

Test with a date range where no exceptions exist to verify the empty state is handled gracefully.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Report data is paginated for large result sets

### 3.7.3 Scenario Type

Happy_Path

### 3.7.4 Given

the Exception Report query returns more records than the page size (e.g., >50 records)

### 3.7.5 When

I view the report

### 3.7.6 Then

the records are displayed on the first page, and pagination controls are available to navigate to subsequent pages.

### 3.7.7 Validation Notes

Seed the database with 100+ exception records and verify that pagination controls appear and function correctly.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A link/tab for 'Exception Report' in the main reporting dashboard.
- Multi-select dropdown or checkbox group to filter by exception types: 'Missed Check-out', 'Manually Corrected', 'Offline Entry', 'Clock Discrepancy'.
- Standard filter controls for Date Range, User, and Team (reusing components from US-060).
- A data table to display the results with columns for User, Date, Check-in Time, Check-out Time, and Exception Type(s).
- Visual tags/icons within the table to indicate the specific exception(s) for each record.
- Pagination controls at the bottom of the table.

## 4.2.0 User Interactions

- Admin can select one or more exception types to filter the report.
- Applying a filter automatically refreshes the report data.
- Clicking on a table header (e.g., 'Date', 'User') sorts the data.
- Clicking on a record in the table can navigate to a detailed view of that attendance entry.

## 4.3.0 Display Requirements

- The report must only display data from the Admin's own tenant.
- Timestamps should be displayed in the tenant's configured timezone (REQ-FUN-069).

## 4.4.0 Accessibility Needs

- All filter controls and the data table must be keyboard-navigable.
- Visual indicators (tags/icons) for exceptions must have accessible text alternatives (e.g., aria-label).
- The report must comply with WCAG 2.1 Level AA standards.

# 5.0.0 Business Rules

- {'rule_id': 'BR-EXC-001', 'rule_description': "An attendance record is classified as an 'exception' if its 'flags' array field contains any of the following strings: 'isOfflineEntry', 'auto-checked-out', 'manually-corrected', 'clock_discrepancy'.", 'enforcement_point': 'Backend query for the Exception Report.', 'violation_handling': 'N/A - This is a classification rule for reporting.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-031

#### 6.1.1.2 Dependency Reason

Establishes the concept of flagging records for 'clock_discrepancy', a key exception type.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-032

#### 6.1.2.2 Dependency Reason

Implements the auto-checkout feature, which generates the 'auto-checked-out' flag (Missed Check-out).

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-033

#### 6.1.3.2 Dependency Reason

Implements offline attendance, which generates the 'isOfflineEntry' flag.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-050

#### 6.1.4.2 Dependency Reason

Implements direct admin edits, which generate the 'manually-corrected' flag.

### 6.1.5.0 Story Id

#### 6.1.5.1 Story Id

US-059

#### 6.1.5.2 Dependency Reason

Provides the base reporting dashboard where this new report will be located.

### 6.1.6.0 Story Id

#### 6.1.6.1 Story Id

US-060

#### 6.1.6.2 Dependency Reason

Provides the generic filtering components (date, user, team) that will be reused in this report.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore as the data source.
- Flutter for Web for the Admin dashboard UI.
- A defined and deployed composite index on the 'attendance' collection to support efficient querying by tenantId, date, and the 'flags' array.

## 6.3.0.0 Data Dependencies

- Requires the existence of an 'attendance' collection with records that have a 'flags' array field as defined in REQ-DAT-001.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The p95 latency for loading the initial report view should be under 3 seconds.
- Applying filters should update the report view in under 2 seconds.

## 7.2.0.0 Security

- All data access must be governed by Firestore Security Rules, ensuring an Admin can only view data from their own tenant (`/tenants/{tenantId}`).

## 7.3.0.0 Usability

- The report and its filters should be intuitive for a non-technical Admin user.
- The meaning of each exception type should be clear, possibly with a tooltip or help icon.

## 7.4.0.0 Accessibility

- The report must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The primary complexity is designing the Firestore query and the necessary composite indexes to efficiently filter on an array field ('flags') in combination with other range and equality filters (date, team).
- Ensuring the query remains cost-effective (minimizing document reads) as the dataset grows is a key consideration.
- The frontend work is relatively low complexity, assuming reusable filter and table components exist.

## 8.3.0.0 Technical Risks

- Poorly designed Firestore indexes could lead to slow report performance or high operational costs.
- If multiple exception types are selected in the filter, a simple 'array-contains-any' query might not be directly supported, potentially requiring multiple queries to be merged on the client-side, which adds complexity.

## 8.4.0.0 Integration Points

- This feature reads directly from the `/tenants/{tenantId}/attendance` collection in Firestore.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Performance
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify report accuracy for each individual exception type.
- Verify report accuracy for combined filters (e.g., date range + exception type + team).
- Verify the 'no results' message is shown correctly.
- Verify pagination works with a large dataset.
- Verify performance with a large number of attendance records in Firestore.

## 9.3.0.0 Test Data Needs

- A test tenant with a significant number of attendance records (~1000+).
- Records must include examples of each exception type, as well as records with multiple exception flags.
- Records must be spread across multiple users, teams, and dates to test filtering.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and integration testing.
- Flutter's `integration_test` package for E2E testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for query logic and UI components, achieving >80% coverage
- Integration testing completed successfully against the Firebase Emulator
- E2E tests for filtering and viewing the report are passing
- User interface reviewed and approved by the Product Owner
- Performance requirements (load times) verified against a representative dataset
- Accessibility audit passed (WCAG 2.1 AA)
- Required Firestore indexes are defined in `firestore.indexes.json` and deployed
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- The backend developer should prioritize defining and testing the Firestore query and indexes early in the sprint, as this is the main risk area.
- Requires coordination with QA to ensure adequate test data is available in the staging environment.

## 11.4.0.0 Release Impact

- This is a key feature for the Admin persona and a significant enhancement to the reporting capabilities of the application.

