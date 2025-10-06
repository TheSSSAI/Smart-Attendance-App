# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-057 |
| Elaboration Date | 2025-01-20 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate views their event calendar |
| As A User Story | As a Subordinate, I want to view a calendar that d... |
| User Persona | The 'Subordinate' user role, who is the primary en... |
| Business Value | Improves operational efficiency by providing emplo... |
| Functional Area | Event Management |
| Story Theme | User Schedule and Task Visibility |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Default calendar view shows events for the current month

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the Subordinate is logged into the mobile application

### 3.1.5 When

they navigate to the 'Calendar' or 'Schedule' screen

### 3.1.6 Then

a calendar is displayed in a month view by default, centered on the current month

### 3.1.7 And

days that contain one or more events are visually distinguished (e.g., with a dot indicator).

### 3.1.8 Validation Notes

Verify that the calendar component loads and the current month is displayed. Check for visual markers on days with known event data.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Calendar displays both individually-assigned and team-assigned events

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Subordinate is assigned to an individual event 'Site Visit A'

### 3.2.5 And

the Subordinate is a member of a team that is assigned to a team event 'Team Training B'

### 3.2.6 When

they view their calendar for the relevant month

### 3.2.7 Then

visual indicators for both 'Site Visit A' and 'Team Training B' are present on their respective days.

### 3.2.8 Validation Notes

Requires test data with a user in a team, an event assigned to the user, and another event assigned to the team. The query must correctly fetch both.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User views event details

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the user is viewing the calendar and sees an event on a specific day

### 3.3.5 When

they tap on the event indicator or the day itself

### 3.3.6 Then

a modal, bottom sheet, or list of events for that day is displayed

### 3.3.7 And

the details view is strictly read-only, with no edit or delete controls.

### 3.3.8 Validation Notes

Tap on a day with an event. Verify a details view appears and contains the correct, non-editable information from the Firestore document.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User navigates between months

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

the user is viewing the calendar in month view

### 3.4.5 When

they swipe horizontally or tap on next/previous month navigation controls

### 3.4.6 Then

the calendar view updates to show the events for the newly selected month.

### 3.4.7 Validation Notes

Confirm that swiping/tapping navigation controls successfully loads data for adjacent months.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Calendar displays recurring events correctly

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

the user is assigned to an event that recurs every Monday

### 3.5.5 When

they view their calendar for a month containing multiple Mondays

### 3.5.6 Then

the event is displayed on every Monday of that month.

### 3.5.7 Validation Notes

Requires test data for a recurring event. Verify that the client-side logic correctly expands the recurrence rule for the visible date range.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Calendar view with no scheduled events

### 3.6.3 Scenario Type

Edge_Case

### 3.6.4 Given

the Subordinate has no events assigned to them or their teams for a specific month

### 3.6.5 When

they navigate to view that month in the calendar

### 3.6.6 Then

the calendar grid is displayed without any event indicators

### 3.6.7 And

a user-friendly message, such as 'No events scheduled', is displayed.

### 3.6.8 Validation Notes

Use a test user with no event data or navigate to a future date far from any test data. Verify the empty state message appears.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Viewing calendar while offline

### 3.7.3 Scenario Type

Error_Condition

### 3.7.4 Given

the user has previously viewed their calendar while online, caching the data

### 3.7.5 And

a non-intrusive UI indicator (e.g., a banner) informs the user they are offline and the data may be outdated.

### 3.7.6 When

they navigate to the calendar screen

### 3.7.7 Then

the calendar displays the last-synced events from the local cache

### 3.7.8 Validation Notes

Load the calendar online. Turn off WiFi/cellular. Re-open the calendar screen. Verify cached data is shown and the offline indicator is present.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Calendar grid (supporting month, week, day views)
- Navigation controls (e.g., arrows for next/previous period)
- View switcher controls (e.g., buttons for 'Month', 'Week', 'Day')
- Event indicators on the calendar (e.g., dots, colored backgrounds)
- Event details modal or bottom sheet
- Empty state message display area
- Offline status indicator banner

## 4.2.0 User Interactions

- User can tap on a day to see a list of events for that day.
- User can tap on a specific event to view its full details.
- User can swipe left/right to navigate between months/weeks.
- User can select different calendar views (month, week, day).

## 4.3.0 Display Requirements

- Event times must be displayed in the tenant's configured timezone.
- Event details must clearly show title, description, start time, and end time.
- The current day should be visually highlighted in the calendar grid.

## 4.4.0 Accessibility Needs

- All controls must have appropriate labels for screen readers (e.g., 'Next month').
- Sufficient color contrast must be used for event indicators and text.
- The calendar must be navigable using accessibility services.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Subordinates can only view events they are assigned to, either directly or through team membership.

### 5.1.3 Enforcement Point

Firestore Security Rules and backend query logic.

### 5.1.4 Violation Handling

The query will not return events the user is not authorized to see. Any direct fetch attempt would be denied by security rules.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The event calendar is a read-only view for Subordinates.

### 5.2.3 Enforcement Point

Client-side UI (no edit controls) and Firestore Security Rules (deny write/update operations on /events collection for Subordinate role).

### 5.2.4 Violation Handling

The UI will not present any editing options. Any malicious attempt to write to the database will be blocked by security rules, resulting in a 'permission-denied' error.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-052

#### 6.1.1.2 Dependency Reason

The system must support the creation of events before they can be viewed.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-054

#### 6.1.2.2 Dependency Reason

The system must allow events to be assigned to individuals.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-055

#### 6.1.3.2 Dependency Reason

The system must allow events to be assigned to teams.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-011

#### 6.1.4.2 Dependency Reason

The concept of teams must exist to resolve team-based event assignments.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user identification.
- Firestore for storing and querying event data.
- A Flutter calendar UI library (e.g., table_calendar, syncfusion_flutter_calendar).
- Local data persistence mechanism (Firestore offline cache or Drift) for offline support.

## 6.3.0.0 Data Dependencies

- Access to the `/events` collection in Firestore.
- Access to the current user's profile to determine their `userId` and `teamIds`.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Calendar screen should load and render within 2 seconds on a stable connection.
- Navigating between months/weeks should feel instantaneous (<300ms UI update).
- Offline data should load from cache in under 1 second.

## 7.2.0.0 Security

- Firestore Security Rules must strictly enforce that a user can only query events relevant to them.

## 7.3.0.0 Usability

- The calendar interface should be intuitive and follow standard mobile calendar conventions.
- It should be easy to distinguish days with events from days without.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The calendar must render correctly on all supported iOS and Android devices and screen sizes.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The Firestore query to fetch events for a user is complex, requiring a query on two different array fields (`assignedUserIds`, `assignedTeamIds`). This may require composite indexes and careful data modeling.
- Implementing the client-side logic to expand recurring event rules (e.g., RRULE) into concrete instances for display.
- Integration and customization of a third-party calendar UI library.
- Ensuring robust offline caching and synchronization of event data.

## 8.3.0.0 Technical Risks

- Firestore's `array-contains-any` operator is limited to 10 items. If a user is a member of more than 10 teams, the query will fail. This may require a data model redesign (e.g., a subcollection of assignees per event).
- Performance degradation if a user has a very large number of recurring events that need to be expanded on the client.

## 8.4.0.0 Integration Points

- Reads data from Firestore's `/events` and `/users` collections.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Usability
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify calendar for a user with no events.
- Verify calendar for a user with only individual events.
- Verify calendar for a user with only team events.
- Verify calendar for a user with a mix of individual, team, and recurring events.
- Test calendar navigation (next/previous month/week).
- Test opening event details.
- Test offline viewing functionality and the display of the offline indicator.

## 9.3.0.0 Test Data Needs

- Test users with various event assignment combinations.
- Events with daily, weekly, and monthly recurrence rules.
- A test user who is a member of multiple teams.

## 9.4.0.0 Testing Tools

- flutter_test for unit and widget tests.
- Firebase Local Emulator Suite for integration testing without hitting live services.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >80% code coverage for new logic
- Integration testing completed for online and offline scenarios
- User interface reviewed and approved by a UX/UI designer
- Performance requirements (load times) verified on a physical test device
- Firestore Security Rules for event data are written and tested
- Documentation for the calendar component and its data flow is created or updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- A decision on the third-party calendar library should be made before the sprint begins.
- The technical risk related to the Firestore query for users in >10 teams needs to be addressed during backlog refinement. A spike may be necessary to validate the data model.

## 11.4.0.0 Release Impact

This is a key feature for the Subordinate role and is essential for providing a complete user experience. Its absence would be a noticeable gap in functionality.

