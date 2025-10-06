# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-046 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor reviews an attendance correction reques... |
| As A User Story | As a Supervisor, I want to view a clear, detailed ... |
| User Persona | Supervisor |
| Business Value | Enables informed and auditable decisions on attend... |
| Functional Area | Approval Workflows |
| Story Theme | Attendance Correction Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Supervisor views the details of a pending correction request

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a Supervisor logged into the application and I am on my dashboard's approval list

### 3.1.5 When

I tap on an item in my list that is marked as a 'Correction Pending'

### 3.1.6 Then

a detailed view of the correction request is displayed.

### 3.1.7 Validation Notes

Verify that tapping the list item navigates to a new screen or opens a modal with the request details.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Correction request detail view displays all required information

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am viewing the details of a correction request

### 3.2.5 When

the view loads

### 3.2.6 Then

the following information must be clearly displayed: Subordinate's full name, the date of the attendance record, the original check-in time, the original check-out time, the requested new check-in time, the requested new check-out time, and the full text of the subordinate's justification.

### 3.2.7 Validation Notes

Check that all specified data fields are present and populated with the correct data from the Firestore record.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Proposed changes are visually highlighted in the detail view

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I am viewing the details of a correction request where only the check-in time was changed

### 3.3.5 When

the view is displayed

### 3.3.6 Then

the 'Requested New Check-In Time' field should be visually distinct (e.g., different color, bold font) from the original time, while the check-out times (original and requested) are displayed without highlighting.

### 3.3.7 Validation Notes

Test with a request changing only check-in, only check-out, and both, ensuring the highlighting logic is correct in all cases.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Detail view provides clear action buttons

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

I am viewing the details of a correction request

### 3.4.5 When

the view is displayed

### 3.4.6 Then

there must be clearly labeled 'Approve' and 'Reject' buttons available for me to action the request.

### 3.4.7 Validation Notes

Confirm the presence and visibility of both buttons. Their functionality is covered in US-047 and US-048.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Supervisor attempts to view a request that was already actioned or cancelled

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am on my dashboard's approval list

### 3.5.5 And

a pending correction request in my list is simultaneously approved by an Admin or cancelled by the subordinate

### 3.5.6 When

I tap on that request item

### 3.5.7 Then

the system should display an informative message, such as 'This request is no longer pending and cannot be actioned', and the item should be removed from my pending list upon refresh.

### 3.5.8 Validation Notes

This requires simulating a race condition. A test can update the record's status in the backend while the UI is open, then simulate the tap action.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A list item component for 'Correction Pending' requests, visually distinct from standard attendance approvals.
- A detail view (modal or new screen) for the correction request.
- Read-only text fields for all original and requested data.
- A dedicated, multi-line display area for the justification text.
- An 'Approve' button.
- A 'Reject' button.

## 4.2.0 User Interactions

- User taps a list item to open the detail view.
- User can scroll to view the full justification if it is long.
- User taps 'Approve' or 'Reject' to trigger the respective workflows (covered in subsequent stories).

## 4.3.0 Display Requirements

- Timestamps should be displayed in a human-readable format, respecting the tenant's configured timezone.
- The subordinate's name and the attendance date should be prominently displayed as the title of the detail view.
- Proposed changes must be visually highlighted to be easily identifiable.

## 4.4.0 Accessibility Needs

- All text, including labels and justification, must have sufficient color contrast (WCAG 2.1 AA).
- All interactive elements (buttons) must have accessible names and be large enough for easy interaction.
- The screen should be navigable using screen reader technology.

# 5.0.0 Business Rules

- {'rule_id': 'BR-SUP-01', 'rule_description': 'A Supervisor can only view correction requests from their direct subordinates.', 'enforcement_point': "Firestore Security Rules on read operations for the 'attendance' collection.", 'violation_handling': 'The read request will be denied by Firestore, and no data will be returned to the client. The UI should handle an empty or error state gracefully.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-045

#### 6.1.1.2 Dependency Reason

A correction request must be created by a subordinate before a supervisor can review it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-037

#### 6.1.2.2 Dependency Reason

This story enhances the supervisor's pending items list, which must exist first.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-021

#### 6.1.3.2 Dependency Reason

The Supervisor must have a role-specific dashboard to navigate from.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role-based access control.
- Firestore database with an 'attendance' collection schema that supports a 'correction_pending' status and fields for requested times and justification.
- Firestore Security Rules that correctly map the supervisor-subordinate hierarchy.

## 6.3.0.0 Data Dependencies

- Test data must include a user with the 'Supervisor' role, a user with the 'Subordinate' role reporting to them, and an attendance record for the subordinate with status set to 'correction_pending'.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The correction request detail view must load and display all data within 2 seconds on a stable 4G connection.

## 7.2.0.0 Security

- Access to view correction requests must be strictly enforced by server-side Firestore Security Rules based on the user's role and their `supervisorId` relationship to the record's owner.
- Data must be transmitted over HTTPS.

## 7.3.0.0 Usability

- The distinction between original and requested times must be immediately obvious to the user without requiring instruction.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires creating a new, detailed UI view within the existing supervisor dashboard flow.
- State management logic is needed to fetch and display the specific record.
- UI logic to conditionally highlight changed data fields adds complexity.
- Requires robust Firestore Security Rules to ensure data privacy and integrity.

## 8.3.0.0 Technical Risks

- Incorrectly configured Firestore Security Rules could lead to data leakage between supervisors or teams.
- The data model for the attendance record must be carefully designed to handle the temporary state of a pending correction without losing original data.

## 8.4.0.0 Integration Points

- Integrates with the existing Supervisor dashboard/approval list.
- The 'Approve' and 'Reject' buttons will trigger Cloud Functions or client-side logic defined in US-047 and US-048.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget (Flutter)
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify a supervisor can see and open a request from their direct subordinate.
- Verify a supervisor CANNOT see a request from a user who is not their subordinate.
- Verify all data fields are displayed correctly for a request where both check-in and check-out are changed.
- Verify visual highlighting works correctly when only one of the two times is changed.
- Verify the UI gracefully handles a long justification text (e.g., proper scrolling).

## 9.3.0.0 Test Data Needs

- A Supervisor user.
- At least two Subordinate users, one reporting to the Supervisor and one not.
- An attendance record in 'correction_pending' state for the direct subordinate.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local integration and security rule testing.
- flutter_test for unit and widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new code
- Integration testing against the Firebase Emulator completed successfully
- Firestore Security Rules for this feature are written and tested
- User interface reviewed and approved by the Product Owner/UX designer
- Performance requirements verified
- Accessibility standards (WCAG 2.1 AA) have been met
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is tightly coupled with US-047 (Approve) and US-048 (Reject). It is highly recommended to implement all three in the same sprint as they share the same UI view.

## 11.4.0.0 Release Impact

- This is a core component of the attendance correction workflow, a key feature for the Supervisor persona.

