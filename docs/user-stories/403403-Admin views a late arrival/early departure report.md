# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-061 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views a late arrival / early departure repor... |
| As A User Story | As an Admin, I want to view a 'Late Arrival / Earl... |
| User Persona | Admin: Responsible for organizational oversight, u... |
| Business Value | Provides actionable insights into workforce punctu... |
| Functional Area | Reporting & Analytics |
| Story Theme | Admin Dashboard Enhancements |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Report Access and Default View

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and default working hours are configured for my tenant

### 3.1.5 When

I navigate to the 'Reports' section and select the 'Late Arrival / Early Departure Report'

### 3.1.6 Then

the report page loads, displaying all late arrivals and early departures for the current week by default.

### 3.1.7 Validation Notes

Verify navigation path and that the report defaults to the current week's data.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Correctly Identifying Late Arrivals

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the tenant's working hours are set from 09:00 to 17:00 in the configured tenant timezone

### 3.2.5 And

a user has an attendance record with a check-in time of 09:15

### 3.2.6 When

I view the report for the corresponding date

### 3.2.7 Then

the report must list this user's record as a late arrival with a deviation of '15 minutes late'.

### 3.2.8 Validation Notes

Test with various late check-in times. Ensure the comparison respects the tenant's timezone.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Correctly Identifying Early Departures

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the tenant's working hours are set from 09:00 to 17:00 in the configured tenant timezone

### 3.3.5 And

a user has an attendance record with a check-out time of 16:30

### 3.3.6 When

I view the report for the corresponding date

### 3.3.7 Then

the report must list this user's record as an early departure with a deviation of '30 minutes early'.

### 3.3.8 Validation Notes

Test with various early check-out times. Ensure the comparison respects the tenant's timezone.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Report Data Filtering

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the report is displaying data

### 3.4.5 When

I apply filters for a specific date range, a single user, and/or a team

### 3.4.6 Then

the report view updates to show only the records that match all applied filter criteria.

### 3.4.7 Validation Notes

Test each filter individually and in combination to ensure they work correctly.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

No Working Hours Configured

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

I am an Admin logged into the web dashboard

### 3.5.5 And

the default working hours have NOT been configured for my tenant

### 3.5.6 When

I navigate to the 'Late Arrival / Early Departure Report'

### 3.5.7 Then

the system must display an informative message prompting me to configure working hours in the Tenant Settings, and the report table must not be rendered.

### 3.5.8 Validation Notes

Verify that the report is disabled and a clear call-to-action message is shown.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

No Data Found for Filters

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

I have applied filters to the report

### 3.6.5 And

there are no late arrivals or early departures that match the criteria

### 3.6.6 When

the report data is fetched

### 3.6.7 Then

the system must display a 'No records found' message in place of the report table.

### 3.6.8 Validation Notes

Ensure an empty state message is shown instead of a blank table.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Handling Records with Missed Check-out

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

a user checked in late but has no check-out time for that day

### 3.7.5 When

I view the report for that day

### 3.7.6 Then

the user's record should appear in the report, flagged as a late arrival, and the check-out columns should indicate 'Missed Check-out'.

### 3.7.7 Validation Notes

Verify that records with null check-out times are processed correctly for the check-in part.

## 3.8.0 Criteria Id

### 3.8.1 Criteria Id

AC-008

### 3.8.2 Scenario

On-Time Records are Excluded

### 3.8.3 Scenario Type

Happy_Path

### 3.8.4 Given

a user has an attendance record where check-in is at or before the start time and check-out is at or after the end time

### 3.8.5 When

I view the report for that day

### 3.8.6 Then

this user's record must NOT appear in the 'Late Arrival / Early Departure Report'.

### 3.8.7 Validation Notes

Confirm that the report only includes exceptions and excludes compliant records.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Date range picker
- Dropdown for Team selection
- Dropdown/Autocomplete for User selection
- Apply Filters button
- Reset Filters button
- Data table/grid for displaying report results
- Export to CSV button

## 4.2.0 User Interactions

- Admin selects a date range to filter the report.
- Admin selects a team or user to narrow down the results.
- The report data refreshes upon applying filters.
- Deviation values (e.g., '15 min late') should be visually highlighted (e.g., red text) for quick identification.

## 4.3.0 Display Requirements

- The report table must include columns for: User Name, Date, Team, Scheduled Start, Actual Check-In, Late Deviation, Scheduled End, Actual Check-Out, Early Deviation.
- If working hours are not configured, a clear instructional message must be displayed.
- A loading indicator must be shown while data is being fetched.

## 4.4.0 Accessibility Needs

- The report table must use proper HTML `<table>`, `<thead>`, `<tbody>`, and `<th>` tags with `scope` attributes for screen reader compatibility.
- Color-based highlighting must be supplemented with text or icons to be accessible to color-blind users.
- All filter controls must be keyboard navigable and have proper labels.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A check-in is considered 'late' if its timestamp is after the configured 'start of workday' time for the tenant.

### 5.1.3 Enforcement Point

Report generation logic (Cloud Function or client-side).

### 5.1.4 Violation Handling

The record is included in the report with the calculated time deviation.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

A check-out is considered 'early' if its timestamp is before the configured 'end of workday' time for the tenant.

### 5.2.3 Enforcement Point

Report generation logic (Cloud Function or client-side).

### 5.2.4 Violation Handling

The record is included in the report with the calculated time deviation.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

All time comparisons must be performed using the tenant's configured timezone to ensure accuracy.

### 5.3.3 Enforcement Point

Report generation logic.

### 5.3.4 Violation Handling

N/A - This is a processing requirement.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-072

#### 6.1.1.2 Dependency Reason

This report is entirely dependent on the existence of configured default working hours to compare against. It cannot be built without this feature.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-069

#### 6.1.2.2 Dependency Reason

The tenant's timezone configuration is required to perform accurate time comparisons for late/early calculations.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-060

#### 6.1.3.2 Dependency Reason

This story relies on the generic filtering components and patterns that will be established for all reports.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-064

#### 6.1.4.2 Dependency Reason

The 'Export to CSV' functionality for this report will be implemented as part of this separate, generic story.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore for data storage and querying.
- Flutter for Web for the Admin dashboard UI.
- A robust date/time library for Dart that supports timezone conversions (e.g., `timezone` package).

## 6.3.0.0 Data Dependencies

- Access to the `/attendance` collection for the tenant.
- Access to the `/users` collection to resolve user names.
- Access to the tenant's configuration document in `/config/{singletonDoc}` to fetch `workingHours` and `timezone`.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The report must load within 3 seconds for a 90-day date range for a tenant with up to 500 users.
- Applying filters should refresh the report data in under 2 seconds.

## 7.2.0.0 Security

- Access to this report must be strictly limited to users with the 'Admin' role.
- All data queries must be scoped to the Admin's `tenantId` using Firestore Security Rules.

## 7.3.0.0 Usability

- The report should be easy to read and interpret, with clear headings and visually distinct data for exceptions.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard must be fully functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Timezone-aware calculations are inherently complex and error-prone if not handled carefully.
- Firestore query optimization will be critical to meet performance requirements for large tenants and long date ranges. This may require specific composite indexes.
- Client-side vs. Server-side Logic: For performance, it may be better to perform the filtering and deviation calculations in a callable Cloud Function rather than pulling all raw data to the client.

## 8.3.0.0 Technical Risks

- Poorly structured Firestore queries could lead to high read costs and slow performance.
- Incorrect implementation of timezone logic could lead to inaccurate reports.

## 8.4.0.0 Integration Points

- Integrates with the central tenant configuration service to fetch working hours and timezone.
- Integrates with the shared reporting filter components.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Performance

## 9.2.0.0 Test Scenarios

- Verify report with a user who is late but not early.
- Verify report with a user who is early but not late.
- Verify report with a user who is both late and early.
- Verify report for a user who checks in/out exactly on the configured time (should not appear).
- Test across different timezones to ensure calculations are correct.
- Test with large datasets in the Firebase Emulator to check performance.

## 9.3.0.0 Test Data Needs

- A tenant with configured working hours and timezone.
- A tenant without configured working hours.
- Multiple users and teams.
- A comprehensive set of attendance records: on-time, late, early, missed check-out, records on the boundary times.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite
- Flutter's `flutter_test` for unit/widget tests
- Flutter's `integration_test` for E2E tests

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for the new logic
- E2E integration testing completed successfully in the emulator environment
- User interface reviewed and approved by the Product Owner
- Performance requirements verified against a representative test dataset
- Security rules updated and tested to restrict access to Admins
- Accessibility checks (automated and manual) have been completed
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is blocked by US-072 and US-069. It cannot be started until those are complete.
- Requires collaboration between frontend and backend (if a Cloud Function is used) developers.

## 11.4.0.0 Release Impact

This is a key feature for the administrative reporting suite and a major value-add for managers.

