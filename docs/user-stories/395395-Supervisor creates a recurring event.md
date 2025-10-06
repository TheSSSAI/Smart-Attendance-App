# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-053 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor creates a recurring event |
| As A User Story | As a Supervisor, I want to define recurrence rules... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Reduces administrative time spent on scheduling re... |
| Functional Area | Event Management |
| Story Theme | Advanced Event Scheduling |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Supervisor creates a daily recurring event

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A Supervisor is on the 'Create Event' screen and has filled in all required event details (title, time, assigned users)

### 3.1.5 When

the Supervisor enables the 'Repeat' option, selects 'Daily', and sets an end date 10 days after the start date

### 3.1.6 Then

the system creates 10 individual event instances, one for each day in the specified date range, all linked by a common recurrence ID.

### 3.1.7 Validation Notes

Verify in Firestore that 10 event documents are created. A subordinate assigned to the event should see all 10 instances on their calendar view.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Supervisor creates a weekly recurring event for specific days

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

A Supervisor is on the 'Create Event' screen

### 3.2.5 When

the Supervisor enables 'Repeat', selects 'Weekly', checks 'Tuesday' and 'Thursday', and sets an end date four weeks away

### 3.2.6 Then

the system creates exactly 8 event instances, one for each Tuesday and Thursday within the four-week period.

### 3.2.7 Validation Notes

Query Firestore for events with the generated recurrence ID. The count must be 8, and their dates must correspond only to Tuesdays and Thursdays.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Supervisor creates a monthly recurring event

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

A Supervisor is creating an event that starts on January 15th

### 3.3.5 When

the Supervisor enables 'Repeat', selects 'Monthly', and sets an end date of April 15th

### 3.3.6 Then

the system creates 4 event instances for Jan 15, Feb 15, Mar 15, and Apr 15.

### 3.3.7 Validation Notes

Verify the creation of four distinct event documents with the correct dates in Firestore.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Attempting to create a recurring event with an end date before the start date

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

A Supervisor is creating a recurring event

### 3.4.5 When

they select an 'End Date' that is earlier than the event's 'Start Date'

### 3.4.6 Then

the system displays a validation error message like 'End date must be after the start date' and prevents the event from being saved.

### 3.4.7 Validation Notes

The 'Save' button should be disabled or the form submission should fail with a user-facing error.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Attempting to create a recurring event series longer than the allowed maximum

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A Supervisor is creating a recurring event

### 3.5.5 When

they set an 'End Date' that is more than 1 year after the 'Start Date'

### 3.5.6 Then

the system displays a validation error message like 'Recurring events cannot span more than one year' and prevents saving.

### 3.5.7 Validation Notes

This validation should occur on the client-side for immediate feedback and be re-validated on the server-side (Cloud Function).

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Monthly recurring event on a day that doesn't exist in a future month

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

A Supervisor is creating a monthly recurring event starting on January 31st

### 3.6.5 When

the recurrence period includes the month of February

### 3.6.6 Then

the system creates the event instance for February on the last day of that month (e.g., Feb 28th or 29th in a leap year).

### 3.6.7 Validation Notes

Check the generated event for February. Its date should be the last day of the month, not an invalid date like Feb 31st.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

User interface for recurrence options is intuitive

### 3.7.3 Scenario Type

Happy_Path

### 3.7.4 Given

A Supervisor is on the 'Create Event' screen

### 3.7.5 When

they toggle the 'Repeat' option on

### 3.7.6 Then

additional UI controls for frequency (Daily, Weekly, Monthly), recurrence details (e.g., day-of-week selector), and an 'End Date' picker become visible.

### 3.7.7 Validation Notes

UI review to confirm the conditional display of recurrence settings is clean and easy to understand.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A toggle switch or checkbox labeled 'Repeat Event'
- A radio button group or dropdown for 'Frequency' with options: 'Daily', 'Weekly', 'Monthly'
- A multi-select component (e.g., toggle buttons for days of the week) for weekly recurrence
- A date picker for the 'End Date' of the recurrence
- A summary text field that describes the created rule (e.g., 'Repeats every Tuesday until 12/31/2025')

## 4.2.0 User Interactions

- Toggling 'Repeat Event' on reveals the recurrence configuration options.
- Toggling 'Repeat Event' off hides the recurrence configuration options.
- Selecting 'Weekly' frequency shows the day-of-the-week selector.
- The 'Save' button is disabled if recurrence is enabled but required fields (e.g., end date) are missing.

## 4.3.0 Display Requirements

- Clear validation messages for invalid date ranges or exceeding recurrence limits.

## 4.4.0 Accessibility Needs

- All form controls for recurrence must have proper labels for screen readers.
- The UI must adhere to WCAG 2.1 AA contrast standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-REC-001

### 5.1.2 Rule Description

A recurring event series cannot span a period longer than 366 days from the start date.

### 5.1.3 Enforcement Point

Client-side form validation and server-side Cloud Function.

### 5.1.4 Violation Handling

Prevent event creation and display an informative error message to the user.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-REC-002

### 5.2.2 Rule Description

For monthly recurring events scheduled on a date that does not exist in a given month (e.g., 31st), the event instance shall be created on the last day of that month.

### 5.2.3 Enforcement Point

Server-side Cloud Function responsible for generating event instances.

### 5.2.4 Violation Handling

The system automatically adjusts the date to the last day of the month. No user error is displayed.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-052', 'dependency_reason': 'This story extends the basic event creation functionality. The form and logic for creating a single event must exist first.'}

## 6.2.0 Technical Dependencies

- A Firebase Cloud Function (on document create) is required to process the recurrence rule and generate the individual event instances asynchronously.
- A robust server-side date/time library (e.g., date-fns) to handle date calculations, including leap years and timezones.

## 6.3.0 Data Dependencies

- The `events` collection schema must be updated to support a master recurrence document and child event instances, likely using a `recurrenceId` field to link them.

## 6.4.0 External Dependencies

*No items available*

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The generation of event instances by the Cloud Function should not block the UI. The user should receive immediate feedback that the event is being created.
- The Cloud Function execution time for generating a full year of daily events should be within acceptable limits (e.g., under 10 seconds).

## 7.2.0 Security

- Firestore Security Rules must ensure that only a Supervisor can create events with recurrence rules.
- The Cloud Function must validate that the user triggering the function has the appropriate 'Supervisor' role.

## 7.3.0 Usability

- The process of setting up a recurring event should be intuitive and require minimal clicks.

## 7.4.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0 Compatibility

- The feature must function correctly on all supported mobile and web platforms.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Medium

## 8.2.0 Complexity Factors

- Requires backend logic (Cloud Function) to handle date calculations and event generation.
- Handling of date/time edge cases (leap years, month ends, timezones) adds complexity.
- Requires a data model that supports a series of related events.
- Asynchronous processing adds a layer of complexity for providing user feedback.

## 8.3.0 Technical Risks

- Incorrectly implemented date logic could lead to events being created on wrong dates or missed entirely.
- A bug in the Cloud Function could lead to runaway writes, incurring high costs. Proper limits and error handling are critical.
- Potential for race conditions if a user tries to edit the master event while instances are being generated.

## 8.4.0 Integration Points

- Integrates with the existing event creation UI.
- Triggers a new Firebase Cloud Function on event creation.
- Writes multiple documents to the Firestore `events` collection.

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Integration
- E2E
- Accessibility

## 9.2.0 Test Scenarios

- Create daily, weekly, and monthly recurring events with various date ranges.
- Test weekly recurrence with single and multiple days selected.
- Test monthly recurrence over a leap year to ensure Feb 29th is handled correctly.
- Test monthly recurrence for the 31st day to ensure it falls back to the last day of shorter months.
- Test all validation rules: end date before start date, recurrence period > 1 year.
- Verify that a subordinate user correctly sees all instances of an assigned recurring event on their calendar.

## 9.3.0 Test Data Needs

- User accounts with Supervisor and Subordinate roles.
- Date ranges that span across months, years, and include a leap day.

## 9.4.0 Testing Tools

- Firebase Local Emulator Suite for local integration testing of the Cloud Function.
- Jest for unit testing the TypeScript Cloud Function.
- flutter_test for widget testing the UI components.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for the Cloud Function's date logic implemented with >80% coverage
- Widget tests for the recurrence UI components implemented
- Integration testing of the end-to-end flow (UI -> Firestore -> Cloud Function -> Firestore) completed successfully
- User interface reviewed and approved for usability and accessibility
- Documentation for the recurrence data model and Cloud Function logic is created
- Story deployed and verified in the staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

5

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This story should be prioritized after the basic event creation story (US-052) is completed.
- Requires both frontend (Flutter) and backend (Cloud Function) development effort, which should be coordinated.

## 11.4.0 Release Impact

- This is a significant feature enhancement for the Event Management module and a key selling point for managers.

