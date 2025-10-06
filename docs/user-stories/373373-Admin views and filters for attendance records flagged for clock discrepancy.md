# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-031 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin views and filters for attendance records fla... |
| As A User Story | As an Admin, I want to view and filter for attenda... |
| User Persona | Admin user responsible for data oversight, reporti... |
| Business Value | Enhances data integrity and trust in the attendanc... |
| Functional Area | Reporting and Administration |
| Story Theme | Attendance Auditing and Data Integrity |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Visual identification of a flagged record in the attendance report

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin is logged into the web dashboard and is viewing the main attendance report

### 3.1.5 When

the report displays an attendance record that has the 'clock_discrepancy' flag in its data

### 3.1.6 Then

that record's row must display a clear and distinct visual indicator (e.g., a warning icon or colored label) signifying a clock discrepancy.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Tooltip provides context for the discrepancy flag

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

an Admin is viewing an attendance record with the clock discrepancy indicator

### 3.2.5 When

the Admin hovers their mouse cursor over the visual indicator

### 3.2.6 Then

a tooltip must appear with an explanatory text, such as 'Device time differs from server time by more than 5 minutes.'

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin filters the report to show only records with clock discrepancies

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the attendance report contains a mix of records, some with the 'clock_discrepancy' flag and some without

### 3.3.5 When

the Admin selects the 'Clock Discrepancy' option from the report's filter controls

### 3.3.6 Then

the report view must update to show only the records that contain the 'clock_discrepancy' flag.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin clears the clock discrepancy filter

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the attendance report is currently filtered to show only records with a clock discrepancy

### 3.4.5 When

the Admin clears or deselects the 'Clock Discrepancy' filter

### 3.4.6 Then

the report view must revert to showing all records that match the other active filters (e.g., date range).

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Filtering for discrepancies when no such records exist

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

an Admin is viewing the attendance report for a period where no records have the 'clock_discrepancy' flag

### 3.5.5 When

the Admin applies the 'Clock Discrepancy' filter

### 3.5.6 Then

the report must display a clear empty state message, such as 'No records with a clock discrepancy found in the selected range.'

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Filter performance for large datasets

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

an Admin is viewing a report with a large number of attendance records

### 3.6.5 When

the Admin applies or clears the 'Clock Discrepancy' filter

### 3.6.6 Then

the report view must update in under 1 second.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A new filter option (e.g., a checkbox or dropdown item) labeled 'Clock Discrepancy' within the existing report filtering controls.
- A visual indicator (e.g., a yellow 'fas fa-clock-rotate-left' FontAwesome icon) to be displayed in the row of each affected attendance record.
- A tooltip component that appears on hover over the visual indicator.

## 4.2.0 User Interactions

- Admin can click the filter option to toggle the filtered view.
- Admin can hover over the indicator icon to see the explanatory tooltip.
- The filter state must be clearly visible to the user when active.

## 4.3.0 Display Requirements

- The visual indicator must not interfere with other record data and should be placed consistently, for example, in a 'Status' or 'Flags' column.
- The indicator must be visually distinct from other flags like 'Offline Entry' or 'Manually Corrected'.

## 4.4.0 Accessibility Needs

- The visual indicator must have an appropriate ARIA label for screen readers, e.g., 'aria-label="Warning: Clock Discrepancy"'.
- The color of the indicator must have sufficient contrast to meet WCAG 2.1 AA standards.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'A clock discrepancy is defined as a difference greater than 5 minutes between the client-side timestamp and the server-side timestamp upon record creation/sync.', 'enforcement_point': 'Backend (Cloud Function or Firestore Security Rule) during attendance record creation. This story consumes the result of this rule.', 'violation_handling': "The record is flagged with 'clock_discrepancy' for administrative review."}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-059

#### 6.1.1.2 Dependency Reason

The Admin's web dashboard with a basic attendance report view must exist to add the indicator and filter to.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-060

#### 6.1.2.2 Dependency Reason

The generic filtering mechanism for reports must be implemented first, as this story extends it with a new filter option.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

N/A (Backend Task)

#### 6.1.3.2 Dependency Reason

Requires completion of the backend task defined in REQ-FUN-004, which implements the server-side logic to compare timestamps and add the 'clock_discrepancy' flag to the attendance record's 'flags' array.

## 6.2.0.0 Technical Dependencies

- Firestore data model for the 'attendance' collection must include a 'flags' field of type array.
- A Firestore composite index must be configured for queries using 'array-contains' on the 'flags' field to ensure performant filtering.

## 6.3.0.0 Data Dependencies

- Requires test data in Firestore with and without the 'clock_discrepancy' flag to validate all acceptance criteria.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Filtering action on the report must complete and render the updated view within 1 second for up to 10,000 records in the current view.

## 7.2.0.0 Security

- The filter query must be protected by Firestore Security Rules to ensure the Admin can only view data for their own tenant.

## 7.3.0.0 Usability

- The purpose of the flag and filter should be intuitive to a non-technical Admin user, aided by the tooltip.

## 7.4.0.0 Accessibility

- All new UI elements (icon, filter control, tooltip) must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported browsers for the web dashboard (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both frontend (Flutter for Web) and backend (Firestore query/indexing) work.
- The primary complexity lies in ensuring the Firestore index is correctly defined and deployed via IaC (Firebase CLI). A missing index will cause query failure.
- Coordination is needed to ensure the frontend correctly queries for the flag string set by the backend.

## 8.3.0.0 Technical Risks

- Performance degradation if the Firestore index is not properly configured, leading to slow filtering on large tenants.
- Inconsistent user experience if the visual indicator for this flag clashes with indicators for other flags.

## 8.4.0.0 Integration Points

- Integrates with the existing Admin reporting UI.
- Depends on the data structure of the 'attendance' collection in Firestore.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify indicator appears for a record with the flag.
- Verify indicator does not appear for a record without the flag.
- Verify filter correctly isolates flagged records.
- Verify clearing the filter restores the full list.
- Verify the empty state message appears when no flagged records are found.
- Verify tooltip functionality on hover.
- Verify screen reader correctly announces the indicator and its meaning.

## 9.3.0.0 Test Data Needs

- A tenant with an Admin user.
- At least one attendance record with `flags: ['clock_discrepancy']`.
- At least one attendance record with `flags: []` or other flags like `['isOfflineEntry']`.
- A test scenario with no records having the flag.

## 9.4.0.0 Testing Tools

- Flutter's `widget_test` for unit tests.
- Firebase Local Emulator Suite for integration testing of the UI against a local Firestore instance.
- Browser developer tools for accessibility checks (e.g., Lighthouse).

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for UI components and state logic, achieving >80% coverage
- Integration testing completed successfully against the Firebase Emulator
- The required Firestore index is defined in `firestore.indexes.json` and deployed
- User interface reviewed and approved by the Product Owner for clarity and consistency
- Performance requirements for filtering verified
- Accessibility checks passed for new UI elements
- Documentation for the reporting feature is updated to include this new filter
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- Ensure the backend task for flagging records is completed in a prior or parallel sprint.
- The developer should have access to deploy Firestore indexes or coordinate with someone who does.

## 11.4.0.0 Release Impact

- This feature enhances the auditing capabilities of the Admin dashboard. It should be communicated in release notes as an improvement to data integrity and reporting.

