# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-058 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate receives a push notification for a new... |
| As A User Story | As a Subordinate, I want to receive a real-time pu... |
| User Persona | Subordinate |
| Business Value | Improves timely communication of work assignments,... |
| Functional Area | Event Management & Notifications |
| Story Theme | User Engagement and Communication |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Notification for direct event assignment

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Subordinate is logged into the mobile app and has granted notification permissions

### 3.1.5 When

a Supervisor creates a new event and assigns it directly to that Subordinate

### 3.1.6 Then

the Subordinate's device receives a push notification containing the event title within 30 seconds.

### 3.1.7 Validation Notes

Verify on a physical or emulated device that the notification is received. The trigger is the creation of the event document in Firestore.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Notification for team-based event assignment

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Subordinate is an active member of a team and has granted notification permissions

### 3.2.5 When

a Supervisor creates a new event and assigns it to that team

### 3.2.6 Then

the Subordinate's device receives a push notification containing the event title.

### 3.2.7 Validation Notes

Ensure the backend logic correctly resolves team members and sends notifications to all of them.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Tapping notification opens the event calendar

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Subordinate has received a new event notification and the app is either in the background or closed

### 3.3.5 When

the Subordinate taps the notification

### 3.3.6 Then

the application launches and navigates directly to the user's event calendar view.

### 3.3.7 Validation Notes

Test this from both a 'terminated' and 'backgrounded' app state on both iOS and Android.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

No duplicate notifications for multiple assignment paths

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

a Subordinate is a member of 'Team A' and has granted notification permissions

### 3.4.5 When

a Supervisor creates a single event and assigns it to the Subordinate directly AND to 'Team A' in the same action

### 3.4.6 Then

the Subordinate receives only one push notification for that event.

### 3.4.7 Validation Notes

The backend Cloud Function must de-duplicate the list of recipient user IDs before sending notifications.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Deactivated users do not receive notifications

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

a user's account status is set to 'deactivated'

### 3.5.5 When

an event is assigned to a team of which the user was a member

### 3.5.6 Then

the deactivated user does not receive a push notification.

### 3.5.7 Validation Notes

The backend logic must check the user's 'status' field before attempting to send a notification.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

User has notifications disabled at the OS level

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

a Subordinate has disabled notifications for the application in their device's OS settings

### 3.6.5 When

a Supervisor assigns a new event to them

### 3.6.6 Then

the backend sends the notification without error, and the user's device silently discards it as expected.

### 3.6.7 Validation Notes

This is to ensure the backend process does not fail if FCM reports that the user cannot receive the message. No client-side validation is possible.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Standard OS push notification banner/alert

## 4.2.0 User Interactions

- Tapping the notification to open the app.

## 4.3.0 Display Requirements

- Notification must display the application name/icon.
- Notification title should be clear (e.g., 'New Event Assigned').
- Notification body must contain the title of the newly assigned event.

## 4.4.0 Accessibility Needs

- Notification text must be compatible with OS-level screen readers (standard functionality).

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Notifications are only sent for the creation of new events.

### 5.1.3 Enforcement Point

Backend Cloud Function triggered by Firestore 'onCreate' event.

### 5.1.4 Violation Handling

Updates or deletions of events will not trigger this notification.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Only users with an 'active' status are eligible to receive notifications.

### 5.2.3 Enforcement Point

Backend Cloud Function, before sending the notification payload.

### 5.2.4 Violation Handling

The function will filter out any users who are not 'active' from the recipient list.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-052

#### 6.1.1.2 Dependency Reason

The event creation functionality must exist before notifications can be triggered.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-054

#### 6.1.2.2 Dependency Reason

The ability to assign events to individuals is required for direct assignment notifications.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-055

#### 6.1.3.2 Dependency Reason

The ability to assign events to teams is required for team assignment notifications.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-057

#### 6.1.4.2 Dependency Reason

The event calendar view must exist to serve as the deep-link target for the notification.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Messaging (FCM) SDK integrated into the Flutter client.
- Firebase Admin SDK configured in the Cloud Functions environment.
- User's FCM device token must be captured and stored in their Firestore user document.

## 6.3.0.0 Data Dependencies

- Requires access to the `/events`, `/teams`, and `/users` collections in Firestore.
- The `/users` collection documents must contain a field for storing FCM device tokens (e.g., `fcmTokens`).

## 6.4.0.0 External Dependencies

- Apple Push Notification Service (APNs) for iOS devices.
- Firebase Cloud Messaging service for Android devices.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The end-to-end latency from event creation to notification delivery should be under 30 seconds under normal network conditions.

## 7.2.0.0 Security

- The notification payload must not contain any Personally Identifiable Information (PII) beyond what is necessary (e.g., event title).
- The Cloud Function that sends notifications must be secured to prevent unauthorized invocation.

## 7.3.0.0 Usability

- The notification content should be concise and immediately understandable.

## 7.4.0.0 Accessibility

- Compliant with WCAG 2.1 Level AA for any in-app UI related to notification settings.

## 7.5.0.0 Compatibility

- Notification functionality must be supported on all target iOS (12.0+) and Android (6.0+) versions.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both backend (Cloud Function) and frontend (Flutter client) development.
- Handling notification permissions and states (foreground, background, terminated) in Flutter.
- Implementing robust deep-linking logic.
- Backend logic to efficiently resolve all users from direct and team assignments and de-duplicate them.

## 8.3.0.0 Technical Risks

- Delays in notification delivery due to platform-specific (APNs/FCM) issues.
- Complexity in testing the full end-to-end flow across different device states.

## 8.4.0.0 Integration Points

- Firestore `onCreate` trigger for the `/events` collection.
- Firebase Cloud Messaging (FCM) API.
- Flutter application's navigation/routing system for deep-linking.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Verify notification on direct assignment.
- Verify notification on team assignment.
- Verify no notification for deactivated user.
- Verify deep-linking from terminated app state.
- Verify deep-linking from background app state.
- Verify correct in-app behavior if notification is tapped while app is in foreground.

## 9.3.0.0 Test Data Needs

- Test accounts for Supervisor and Subordinate roles.
- A test team with the Subordinate as a member.
- At least one physical iOS and one physical Android device for E2E testing.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for backend function testing.
- Flutter Driver or `integration_test` for automated E2E tests if feasible.
- Manual testing on physical devices is mandatory.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing on both iOS and Android.
- Cloud Function code is peer-reviewed, merged, and deployed.
- Flutter client code for handling notifications and deep-linking is peer-reviewed and merged.
- Unit tests for the Cloud Function's user resolution and de-duplication logic achieve >80% coverage.
- Manual E2E tests confirm correct behavior for all scenarios.
- The user's FCM token is successfully stored/updated in their Firestore document upon login.
- Story deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- Requires coordinated work between backend and mobile developers.
- Access to physical devices for testing is crucial.
- Ensure FCM is configured correctly in all Firebase environments (Dev, Staging, Prod) before starting development.

## 11.4.0.0 Release Impact

This is a key user-facing feature that significantly enhances the product's value proposition. It should be included in a major feature release.

