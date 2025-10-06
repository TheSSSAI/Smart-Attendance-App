# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-043 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate views the reason for a rejected record |
| As A User Story | As a Subordinate, I want to see the specific reaso... |
| User Persona | Subordinate: The primary end-user of the mobile ap... |
| Business Value | Increases transparency in the approval process, re... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Display of rejection reason for a rejected record

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a Subordinate logged into the mobile application and I have an attendance record that has been rejected by my Supervisor

### 3.1.5 When

I navigate to my attendance history and view the details of the rejected record

### 3.1.6 Then

The record's status must be clearly displayed as 'Rejected'

### 3.1.7 And

This section must contain the exact text my Supervisor entered as the reason for rejection.

### 3.1.8 Validation Notes

Verify by logging in as a test Supervisor, rejecting a record with a specific reason, then logging in as the test Subordinate to confirm the reason is displayed correctly.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Visual distinction of rejected records in the list view

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am a Subordinate viewing my list of attendance records

### 3.2.5 When

The list contains records with 'Approved', 'Pending', and 'Rejected' statuses

### 3.2.6 Then

The rejected records must be visually distinct from the others, for example, by using a red color indicator or an icon.

### 3.2.7 Validation Notes

QA to check the attendance list UI to ensure rejected items are easily identifiable at a glance.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Handling of a long rejection reason

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

My Supervisor has rejected my attendance record with a very long reason (e.g., >200 characters)

### 3.3.5 When

I view the details of that rejected record

### 3.3.6 Then

The full text of the reason must be readable and must not break the UI layout

### 3.3.7 And

The text should wrap correctly or be contained within a scrollable element.

### 3.3.8 Validation Notes

Test with a long string of text as the rejection reason to ensure the UI remains functional and readable.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Handling of a missing rejection reason

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

An attendance record has a status of 'Rejected' but the `rejectionReason` field in the database is null or empty

### 3.4.5 When

I view the details of that rejected record

### 3.4.6 Then

The application must not crash

### 3.4.7 And

A user-friendly default message, such as 'No reason was provided.', should be displayed in place of the reason.

### 3.4.8 Validation Notes

Manually edit a Firestore document to set status to 'rejected' and `rejectionReason` to null, then view it in the app to confirm graceful handling.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A visual indicator (icon or color) for 'Rejected' status in the attendance list.
- A dedicated, read-only text area or card in the attendance detail view to display the rejection reason.

## 4.2.0 User Interactions

- User taps on a rejected record in their history list to navigate to the detail view.
- The rejection reason is for display only; no user interaction is required with the reason text itself.

## 4.3.0 Display Requirements

- The status 'Rejected' must be clearly visible on both the list and detail views.
- The rejection reason must be clearly labeled, e.g., 'Reason for Rejection:'.

## 4.4.0 Accessibility Needs

- The color used for the 'Rejected' status must meet WCAG 2.1 AA contrast ratio standards.
- The rejection reason text must be accessible to screen readers, which should announce the label and the reason itself.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'A Subordinate can only view rejection reasons for their own attendance records.', 'enforcement_point': 'Database query level via Firestore Security Rules.', 'violation_handling': 'The query will return no data for records belonging to other users, effectively preventing access.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-040', 'dependency_reason': 'This story depends on the functionality for a Supervisor to reject a record and provide a reason. The `rejectionReason` field must be populated in the Firestore document by US-040 before it can be displayed here.'}

## 6.2.0 Technical Dependencies

- Firebase Firestore SDK for data retrieval.
- Existing UI components for the attendance history list and detail screens.

## 6.3.0 Data Dependencies

- Requires the `attendance` collection in Firestore to have documents with a `status` field (e.g., 'rejected') and a `rejectionReason` field (string).

## 6.4.0 External Dependencies

*No items available*

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- Loading the attendance detail view, including the rejection reason, should complete in under 1 second on a 4G connection.

## 7.2.0 Security

- Firestore Security Rules must strictly enforce that a user can only read their own attendance records and associated rejection reasons.

## 7.3.0 Usability

- The reason for rejection should be one of the first pieces of information a user sees when viewing a rejected record to minimize confusion.

## 7.4.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0 Compatibility

- The UI must render correctly on all supported iOS and Android screen sizes.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Low

## 8.2.0 Complexity Factors

- This is primarily a UI feature that involves reading and displaying an existing data field.
- No new backend logic or complex state management is required.

## 8.3.0 Technical Risks

- Minimal risk. The main risk is a UI layout issue when handling very long rejection reasons, which can be mitigated through proper testing.

## 8.4.0 Integration Points

- Reads data from the Firebase Firestore `attendance` collection.

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Widget
- Integration
- Accessibility

## 9.2.0 Test Scenarios

- Verify a rejected record in the list is visually distinct.
- Verify the correct rejection reason is displayed on the detail screen.
- Verify the UI handles a very long rejection reason without breaking.
- Verify the UI handles a null or empty rejection reason gracefully.
- Verify a user cannot see rejection reasons for another user's records (requires security rule testing).

## 9.3.0 Test Data Needs

- A test Subordinate user account.
- An attendance record for this user with `status: 'rejected'` and a populated `rejectionReason` field.
- An attendance record with `status: 'rejected'` and a null `rejectionReason` field.

## 9.4.0 Testing Tools

- flutter_test for unit and widget tests.
- Firebase Local Emulator Suite to test security rules.
- integration_test for end-to-end scenarios.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >= 80% coverage for new code
- Integration testing completed successfully against a staging environment
- User interface reviewed and approved by the Product Owner/Designer
- Accessibility requirements (screen reader, contrast) validated
- No regressions introduced in the attendance history feature
- Story deployed and verified in staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

1

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This story should be scheduled in the same sprint as or immediately after US-040 to complete the rejection workflow loop for the user.
- Low complexity makes it a good candidate to pair with a more complex story in a sprint.

## 11.4.0 Release Impact

This is a core part of the user feedback loop for the attendance approval workflow. The workflow is incomplete without it.

