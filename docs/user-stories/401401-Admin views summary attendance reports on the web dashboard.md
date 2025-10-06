# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-059 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views summary attendance reports on the web ... |
| As A User Story | As an Admin, I want to view aggregated summary rep... |
| User Persona | Admin: Responsible for overall tenant management, ... |
| Business Value | Provides immediate, actionable insights into workf... |
| Functional Area | Reporting & Analytics |
| Story Theme | Admin Dashboard Experience |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Default view of the daily summary report

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and I navigate to the 'Reports' section

### 3.1.5 When

the reports page loads

### 3.1.6 Then

the 'Daily Summary' view is displayed by default, showing the attendance summary for the current date based on the tenant's timezone.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Viewing a specific daily summary report

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am viewing the reports page

### 3.2.5 When

I select the 'Daily Summary' view and choose a specific past date using the date picker

### 3.2.6 Then

the dashboard updates to show the total number of active users, the number of users who checked in, the number of absent users, and the attendance percentage for that selected date.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Viewing a weekly summary report

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I am viewing the reports page

### 3.3.5 When

I select the 'Weekly Summary' view and choose a specific week

### 3.3.6 Then

the dashboard displays the average daily attendance percentage for that week and a trend chart visualizing the daily attendance percentage for each day of the selected week.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Viewing a monthly summary report

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

I am viewing the reports page

### 3.4.5 When

I select the 'Monthly Summary' view and choose a specific month

### 3.4.6 Then

the dashboard displays the average daily attendance percentage for that month and a trend chart visualizing the daily attendance percentage for each day of the selected month.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Report for a period with no attendance data

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am viewing the reports page

### 3.5.5 When

I select a date range (day, week, or month) in the future or a period where no one checked in (e.g., a public holiday)

### 3.5.6 Then

the dashboard displays a clear message such as 'No attendance data available for the selected period' instead of showing zero values or an error state.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Data accuracy in summary calculations

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

there are 100 active users in the tenant for a specific day

### 3.6.5 When

85 of those users have a check-in record for that day

### 3.6.6 Then

the daily summary report must display 'Present: 85', 'Absent: 15', and 'Attendance: 85%'.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Report generation performance

### 3.7.3 Scenario Type

Non_Functional

### 3.7.4 Given

I am an Admin of a tenant with 1,000 users and a full month of attendance data

### 3.7.5 When

I request a monthly summary report

### 3.7.6 Then

the report and its associated chart must load in under 5 seconds.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Tabs or a segmented control to switch between 'Daily', 'Weekly', and 'Monthly' views.
- A date/period picker component appropriate for each view (e.g., single day picker, week picker, month/year picker).
- Data cards to display key metrics (e.g., 'Total Present', 'Total Absent', 'Attendance %').
- A line or bar chart component for visualizing trends in weekly and monthly views.

## 4.2.0 User Interactions

- Selecting a report type (Daily/Weekly/Monthly) updates the view and the date picker.
- Changing the date/period triggers a data refresh for the report.
- Hovering over points on the trend chart should display a tooltip with the specific date and attendance percentage.

## 4.3.0 Display Requirements

- All calculations must be based on the tenant's configured timezone.
- The 'Total Users' count for any given day must only include users with an 'active' status on that day.
- Charts must have clearly labeled X and Y axes.

## 4.4.0 Accessibility Needs

- The dashboard must comply with WCAG 2.1 Level AA standards.
- All controls must be keyboard navigable.
- Charts must have accessible labels and data points for screen readers.
- Sufficient color contrast must be used for text and chart elements.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-REP-001

### 5.1.2 Rule Description

An employee is considered 'Present' on a given day if at least one 'check-in' record exists for them on that calendar day, according to the tenant's timezone.

### 5.1.3 Enforcement Point

Backend data aggregation logic.

### 5.1.4 Violation Handling

N/A (Calculation rule).

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-REP-002

### 5.2.2 Rule Description

An employee is considered 'Absent' if they have an 'active' status but no 'check-in' record for a given calendar day.

### 5.2.3 Enforcement Point

Backend data aggregation logic.

### 5.2.4 Violation Handling

N/A (Calculation rule).

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant must exist to have an Admin and data.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

The Admin web dashboard must exist as a container for the reports section.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-028

#### 6.1.3.2 Dependency Reason

Requires attendance data from user check-ins to generate any reports.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-069

#### 6.1.4.2 Dependency Reason

Requires the ability to configure and retrieve the tenant's timezone for accurate date-based calculations.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for Admin role verification.
- Firestore for querying user and attendance collections.
- A charting library for Flutter Web (e.g., fl_chart).
- Potential dependency on a scheduled Cloud Function for data pre-aggregation to meet performance requirements.

## 6.3.0.0 Data Dependencies

- Access to `/tenants/{tenantId}/users` collection to determine total active users.
- Access to `/tenants/{tenantId}/attendance` collection for check-in data.
- Access to `/tenants/{tenantId}/config` document for the organization's timezone.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- 95th percentile (p95) load time for any summary report page shall be under 5 seconds.
- Firestore query complexity must be optimized to minimize read operations and cost, potentially through server-side aggregation.

## 7.2.0.0 Security

- All data queries must be scoped to the authenticated Admin's `tenantId` using Firestore Security Rules.
- Admins must not be able to view data from any other tenant.

## 7.3.0.0 Usability

- The interface for selecting dates and report types must be intuitive and require minimal clicks.
- Data visualizations must be clear and easy to interpret.

## 7.4.0.0 Accessibility

- Must meet WCAG 2.1 Level AA standards as per REQ-INT-001.

## 7.5.0.0 Compatibility

- The web dashboard must be fully functional on the latest stable versions of Chrome, Firefox, Safari, and Edge, as per REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Firestore query performance at scale. A naive client-side fetch-and-aggregate approach will not scale and will be costly. A server-side pre-aggregation strategy using a daily scheduled Cloud Function is recommended.
- Accurate handling of timezones across all queries and calculations is critical and non-trivial.
- Integration and configuration of a charting library in Flutter Web.
- Designing efficient Firestore composite indexes to support the required queries.

## 8.3.0.0 Technical Risks

- Risk of high Firestore costs if queries are not optimized.
- Risk of poor performance on large tenants if a server-side aggregation strategy is not implemented.
- Potential for off-by-one errors in date calculations if timezone handling is incorrect.

## 8.4.0.0 Integration Points

- Reads from Firestore `users` and `attendance` collections.
- May write to a new Firestore `dailySummaries` collection if a pre-aggregation strategy is chosen.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Performance
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify calculations for a day with partial attendance.
- Verify calculations for a day with full attendance.
- Verify calculations for a day with zero attendance.
- Test weekly/monthly reports that span across a month-end/year-end.
- Test with a tenant in a different timezone from the server to validate timezone logic.
- Test report generation for a large dataset (1000+ users) to validate performance.

## 9.3.0.0 Test Data Needs

- A tenant with a mix of active and deactivated users.
- At least one month of mock attendance data with varying daily participation.
- A tenant configured with a non-UTC timezone.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration testing.
- `flutter_test` for unit and widget tests.
- `integration_test` for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- Integration testing with the Firebase Emulator completed successfully
- User interface reviewed and approved for usability and adherence to design specs
- Performance requirements verified against a large, seeded dataset
- Security rules are in place and tested to ensure tenant data isolation
- Documentation for the reporting feature is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

8

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- The decision on the data aggregation strategy (client-side vs. server-side) must be made during sprint planning as it significantly impacts the implementation scope.
- Requires both frontend (Flutter Web) and backend (Cloud Function, if chosen) development effort.
- A prerequisite task may be to create a data seeding script for performance testing.

## 11.4.0.0 Release Impact

- This is a core feature for the Admin persona and a key selling point for the product's management capabilities. It is a high-priority item for the initial release.

