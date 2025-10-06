# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-052 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor creates a new event |
| As A User Story | As a Supervisor, I want to create a new event with... |
| User Persona | Supervisor (as defined in REQ-USR-001) |
| Business Value | Enables formal scheduling of team activities withi... |
| Functional Area | Event Management |
| Story Theme | Event Scheduling and Assignment |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Supervisor successfully creates a single, non-recurring event

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a Supervisor logged into the application and have navigated to the 'Create Event' screen

### 3.1.5 When

I enter a valid title, a description, select a future start date and time, select an end date and time that is after the start time, and tap the 'Save' button

### 3.1.6 Then

A success notification (e.g., toast or snackbar) is displayed, the form is closed or reset, and a new document is created in the `/tenants/{myTenantId}/events` collection in Firestore with the provided details.

### 3.1.7 Validation Notes

Verify the new document in Firestore contains the correct `title`, `description`, `startTime` (as Timestamp), `endTime` (as Timestamp), `createdBy` (Supervisor's userId), and `tenantId`.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: Attempting to save an event with a missing title

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am a Supervisor on the 'Create Event' screen

### 3.2.5 When

I leave the 'Title' field blank and tap the 'Save' button

### 3.2.6 Then

A validation error message, such as 'Title is required', is displayed next to the title field, the 'Save' button may be disabled, and no data is sent to the server.

### 3.2.7 Validation Notes

The form should remain open, and no new event document should be created in Firestore.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Error Condition: Attempting to save an event where the end time is before the start time

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am a Supervisor on the 'Create Event' screen and have filled in all fields

### 3.3.5 When

I select an 'End Time' that is chronologically earlier than the 'Start Time' and tap the 'Save' button

### 3.3.6 Then

A validation error message, such as 'End time must be after start time', is displayed, and the event is not saved.

### 3.3.7 Validation Notes

The form should remain open, allowing the user to correct the times. No new event document should be created in Firestore.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Alternative Flow: User cancels event creation

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

I am a Supervisor on the 'Create Event' screen and have entered some data into the form

### 3.4.5 When

I tap the 'Cancel' or 'Back' button

### 3.4.6 Then

A confirmation dialog appears asking if I want to discard my changes. If I confirm, the form is closed, and no event is created.

### 3.4.7 Validation Notes

Verify that if the user cancels the confirmation dialog, they remain on the form with their data intact.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Security: A non-supervisor user cannot create an event

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A user with the 'Subordinate' role is logged in

### 3.5.5 When

They attempt to access the event creation functionality (e.g., via a deep link or API call)

### 3.5.6 Then

The UI for creating an event should not be visible or accessible to them, and any direct API/database attempt must be rejected by Firestore Security Rules.

### 3.5.7 Validation Notes

Test Firestore Security Rules to ensure writes to the `events` collection are denied for users without the 'Supervisor' or 'Admin' role.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Text input field for 'Event Title'
- Multi-line text area for 'Description'
- Date and Time picker for 'Start Time'
- Date and Time picker for 'End Time'
- A 'Save' or 'Create' button
- A 'Cancel' or 'Back' button/icon
- Loading indicator shown during the save operation

## 4.2.0 User Interactions

- Tapping on time fields opens a native-style date/time picker.
- The 'Save' button should be disabled until all mandatory fields are filled with valid data.
- Inline validation messages should appear as the user types or on attempting to save with invalid data.

## 4.3.0 Display Requirements

- The form must clearly label all input fields.
- Success and error messages must be clear and user-friendly.

## 4.4.0 Accessibility Needs

- All form fields must have labels associated for screen readers.
- UI must adhere to WCAG 2.1 Level AA for color contrast and touch target size (as per REQ-INT-001).

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-EVT-001

### 5.1.2 Rule Description

Event title is a mandatory field.

### 5.1.3 Enforcement Point

Client-side form validation and Firestore Security Rules.

### 5.1.4 Violation Handling

Prevent form submission and display a user-friendly error message.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-EVT-002

### 5.2.2 Rule Description

Event end time must be chronologically after the start time.

### 5.2.3 Enforcement Point

Client-side form validation and Firestore Security Rules.

### 5.2.4 Violation Handling

Prevent form submission and display a user-friendly error message.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-EVT-003

### 5.3.2 Rule Description

Only users with the 'Supervisor' or 'Admin' role can create events.

### 5.3.3 Enforcement Point

UI visibility logic and Firestore Security Rules.

### 5.3.4 Violation Handling

UI element is hidden. Direct database write is rejected with a 'permission-denied' error.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-011

#### 6.1.1.2 Dependency Reason

A Supervisor role and team structure must exist before events can be conceptualized for a team.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

Requires a role-specific UI for the Supervisor to access the event creation feature.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user role and tenant verification.
- Firebase Firestore for data storage.
- Defined Firestore data model for the `events` collection (REQ-DAT-001).
- Flutter state management solution (e.g., Riverpod) for form state handling.

## 6.3.0.0 Data Dependencies

- The system must have at least one user with the 'Supervisor' role for testing.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The event creation form must load in under 1 second.
- The save operation (client to server confirmation) should complete in under 1 second on a stable 4G connection (as per REQ-NFR-001).

## 7.2.0.0 Security

- Firestore Security Rules must enforce that a user can only create an event within their own tenant (`tenantId`).
- Firestore Security Rules must validate the data types of incoming event data (e.g., title is a string, startTime is a timestamp).

## 7.3.0.0 Usability

- The process of creating an event should be intuitive, requiring minimal instruction.
- The date/time picker should be easy to use on a mobile device.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards (REQ-INT-001).

## 7.5.0.0 Compatibility

- The feature must function correctly on supported iOS and Android versions (REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Standard form UI development.
- Integration with a standard date/time picker component.
- Basic Firestore write operation.
- Writing and testing Firestore security rules.

## 8.3.0.0 Technical Risks

- Ensuring the date/time picker component provides a good user experience on both iOS and Android.
- Timezone handling for `startTime` and `endTime` must be consistent. All timestamps should be stored in UTC in Firestore.

## 8.4.0.0 Integration Points

- Writes to the Firebase Firestore `events` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget (Flutter)
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Create a valid event and verify its creation in the database.
- Attempt to create an event with invalid data (empty title, end time before start time) and verify validation.
- Log in as a Subordinate and verify that the event creation UI is not accessible.
- Test the Firestore security rules using the Firebase Emulator test suite to ensure unauthorized creation is blocked.

## 9.3.0.0 Test Data Needs

- Test accounts with 'Supervisor' and 'Subordinate' roles within the same tenant.

## 9.4.0.0 Testing Tools

- flutter_test for unit/widget tests.
- Firebase Local Emulator Suite for integration and security rule testing.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >= 80% code coverage for new logic
- Firestore Security Rules for event creation are written and tested
- Integration testing against the Firebase Emulator completed successfully
- User interface reviewed for usability and adherence to design guidelines
- Feature is manually verified on both iOS and Android physical devices or emulators
- No new high-priority accessibility issues are introduced
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story for the Event Management epic. It unblocks event assignment (US-054, US-055) and event visibility (US-057).
- The scope of this story is intentionally limited to creating a single, non-recurring event. Recurring events are handled in US-053.

## 11.4.0.0 Release Impact

This feature is a core component of the event management module and is required for the initial release of this functionality.

