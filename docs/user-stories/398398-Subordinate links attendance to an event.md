# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-056 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate links attendance to an event |
| As A User Story | As a Subordinate, I want to select from a list of ... |
| User Persona | Subordinate: The primary end-user of the mobile ap... |
| Business Value | Enriches attendance data by adding context, enabli... |
| Functional Area | Attendance Management |
| Story Theme | Event-Based Attendance |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

User with a single assigned event for the day links it during check-in

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a logged-in Subordinate and I have exactly one event assigned to me for the current calendar day

### 3.1.5 When

I initiate the check-in process

### 3.1.6 Then

a new attendance record is created in Firestore with the `eventId` of the selected event.

### 3.1.7 And

I select the assigned event and confirm my check-in

### 3.1.8 Validation Notes

Verify the `attendance` collection in Firestore for a new record with the correct `userId` and a non-null `eventId` matching the assigned event's ID.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

User with multiple assigned events for the day links one during check-in

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am a logged-in Subordinate and I have multiple events assigned to me for the current calendar day

### 3.2.5 When

I initiate the check-in process

### 3.2.6 Then

a new attendance record is created with the `eventId` of the chosen event.

### 3.2.7 And

I select one event from the list and confirm my check-in

### 3.2.8 Validation Notes

Verify the created attendance record in Firestore contains the correct `eventId` corresponding to the specific event selected from the list.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User with assigned events chooses not to link any event

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

I am a logged-in Subordinate and I have one or more events assigned to me for the day

### 3.3.5 When

I initiate the check-in process and am presented with the event selection screen

### 3.3.6 And

I choose the option to proceed without selecting an event (e.g., tap 'Skip' or 'General Check-in')

### 3.3.7 Then

a new attendance record is created with a null or absent `eventId` field.

### 3.3.8 Validation Notes

Verify the created attendance record in Firestore has a null or non-existent `eventId` field.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User with no assigned events for the day performs a check-in

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

I am a logged-in Subordinate and I have no events assigned to me for the current calendar day

### 3.4.5 When

I initiate the check-in process

### 3.4.6 Then

the system bypasses the event selection step entirely and proceeds directly to the check-in confirmation

### 3.4.7 And

a new attendance record is created with a null or absent `eventId` field.

### 3.4.8 Validation Notes

Confirm the user is not shown the event selection UI. Verify the created attendance record in Firestore has a null `eventId`.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

User checks in while offline with a cached event

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am a logged-in Subordinate with my device in offline mode

### 3.5.5 And

when my device connectivity is restored, the record is successfully synced to the server with the correct `eventId`.

### 3.5.6 When

I initiate the check-in process and select a cached event

### 3.5.7 Then

an attendance record is created in the local Firestore cache with the correct `eventId`

### 3.5.8 Validation Notes

Test by enabling airplane mode, performing the check-in, then disabling airplane mode. Verify the final record in Firestore.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A modal dialog or a dedicated screen for event selection that appears during the check-in flow.
- A scrollable list to display event items.
- Each list item should display the event `title` and `startTime` - `endTime`.
- A button or option to select an event.
- A clear button or link to 'Skip' or perform a 'General Check-in' without linking an event.

## 4.2.0 User Interactions

- Tapping the 'Check-In' button triggers the event fetching logic.
- If events exist, the selection UI is displayed.
- Tapping an event in the list highlights it as the selection.
- Tapping a 'Confirm' button proceeds with the check-in, linking the selected event.
- Tapping 'Skip' proceeds with the check-in without linking any event.

## 4.3.0 Display Requirements

- The list of events must only show events scheduled for the current calendar day, based on the tenant's timezone.
- Events should be sorted chronologically by their start time.

## 4.4.0 Accessibility Needs

- The event list must be navigable using screen readers.
- All buttons and interactive elements must have clear labels for accessibility services.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Only events assigned to the user for the current calendar day (00:00 to 23:59 in the tenant's timezone) can be displayed for selection.

### 5.1.3 Enforcement Point

During the Firestore query when the user initiates a check-in.

### 5.1.4 Violation Handling

Events outside the current day are not fetched or displayed, ensuring they cannot be selected.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

A single attendance record can only be linked to a single event.

### 5.2.3 Enforcement Point

Data model and UI design.

### 5.2.4 Violation Handling

The UI shall only permit the selection of one event. The `eventId` field in the `attendance` collection is a single string, not an array.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

The core check-in functionality must exist before it can be modified to include event selection.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-052

#### 6.1.2.2 Dependency Reason

The system must support the creation of events before they can be linked to attendance.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-054

#### 6.1.3.2 Dependency Reason

The system must support assigning events to users before a user can see and select their assigned events.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-057

#### 6.1.4.2 Dependency Reason

The data model and basic query logic for a user to fetch their events must be established.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore for querying the `events` collection.
- Firestore composite index to support querying events by `assignedUserIds` and `startTime`.
- Local database package (`drift`) for caching event data for offline use, as per REQ-INT-003.

## 6.3.0.0 Data Dependencies

- The `attendance` collection schema must be updated to include an optional `eventId` field (string).
- The `events` collection must be populated with test data for assigned users and various dates.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The query to fetch a user's events for the day must execute and return data to the client in under 500ms on a stable connection.

## 7.2.0.0 Security

- Firestore Security Rules must ensure that users can only query for events where their `userId` is present in the `assignedUserIds` array.

## 7.3.0.0 Usability

- The event selection process should add minimal friction to the check-in flow. It should be quick and intuitive.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Modifying a critical, existing user workflow (check-in).
- Implementing an efficient Firestore query with a composite index.
- Handling the UI state for the multi-step check-in process.
- Implementing offline support by reading from a local cache (`drift`) of the user's event calendar.

## 8.3.0.0 Technical Risks

- Poorly designed Firestore query could lead to slow performance or high read costs.
- Incorrectly managing the offline cache could lead to users seeing stale event data.

## 8.4.0.0 Integration Points

- Integrates directly into the existing attendance check-in module.
- Reads data from the `events` collection in Firestore.
- Writes data to the `attendance` collection in Firestore.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- A user with one event today selects it.
- A user with multiple events today selects one.
- A user with events today skips the selection.
- A user with no events today checks in.
- A user with events only for past/future dates checks in.
- The entire flow is tested in offline mode.

## 9.3.0.0 Test Data Needs

- Test users with different event schedules: no events, one event today, multiple events today, events only on other days.
- Events assigned to individual users and to teams the user is a member of.

## 9.4.0.0 Testing Tools

- flutter_test
- integration_test
- Firebase Local Emulator Suite

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >80% coverage for new logic
- E2E integration testing completed successfully for online and offline scenarios
- User interface reviewed and approved by the design/product owner
- Performance of the event query is verified to be within the defined limits
- Firestore security rules updated and tested
- Schema changes documented
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is blocked by several other stories related to core attendance and event creation. It should be scheduled in a sprint after all prerequisites are completed and merged.

## 11.4.0.0 Release Impact

- This is a key feature for the Event Management theme and significantly enhances the value of the attendance data collected.

