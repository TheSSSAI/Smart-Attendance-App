# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-049 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate is notified of a correction request's ... |
| As A User Story | As a Subordinate, I want to receive a push notific... |
| User Persona | Subordinate - The primary end-user who marks atten... |
| Business Value | Improves user experience by providing timely, proa... |
| Functional Area | Approval Workflows |
| Story Theme | Attendance Correction Workflow |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Notification for an approved correction request

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Subordinate has submitted an attendance correction request for a specific date

### 3.1.5 When

their Supervisor approves the correction request

### 3.1.6 Then

the Subordinate's device receives a push notification via Firebase Cloud Messaging (FCM)

### 3.1.7 And

the notification body is 'Your attendance correction for [Date] has been approved.'

### 3.1.8 Validation Notes

Verify using a test device that the notification is received. The trigger can be simulated by updating the attendance record's status to 'approved' in Firestore.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Notification for a rejected correction request

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Subordinate has submitted an attendance correction request for a specific date

### 3.2.5 When

their Supervisor rejects the correction request

### 3.2.6 Then

the Subordinate's device receives a push notification via FCM

### 3.2.7 And

the notification body is 'Your attendance correction for [Date] has been rejected.'

### 3.2.8 Validation Notes

Verify using a test device that the notification is received. The trigger can be simulated by updating the attendance record's status back to its previous state and logging the rejection.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Tapping notification deep-links into the app

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Subordinate has received a notification for a correction request outcome

### 3.3.5 When

the Subordinate taps on the notification

### 3.3.6 Then

the mobile application opens or is brought to the foreground

### 3.3.7 And

the user is navigated directly to the details screen for the specific attendance record corresponding to the notification.

### 3.3.8 Validation Notes

Test this with the app in three states: foreground, background, and terminated. The notification payload must contain the necessary identifier (e.g., attendance record ID) to facilitate navigation.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Tapping notification when logged out

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

the Subordinate has received a notification but is currently logged out of the app

### 3.4.5 When

the Subordinate taps on the notification

### 3.4.6 Then

the mobile application opens to the login screen

### 3.4.7 And

after a successful login, the user is automatically redirected to the details screen for the specific attendance record.

### 3.4.8 Validation Notes

The app must be able to store the deep link intent, execute the login flow, and then resume the navigation to the intended destination.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Notification delivery when user is offline

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

a Supervisor approves or rejects a correction request while the Subordinate's device is offline

### 3.5.5 When

the Subordinate's device reconnects to the internet

### 3.5.6 Then

the queued push notification is delivered by FCM, subject to FCM's Time-To-Live (TTL) policy.

### 3.5.7 Validation Notes

This is standard FCM behavior but should be verified. Put a device in airplane mode, trigger the event, then turn airplane mode off.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Standard OS-level push notification banner/alert

## 4.2.0 User Interactions

- User taps the notification to open the app and navigate to the relevant content.

## 4.3.0 Display Requirements

- Notification must display the app icon, a clear title (Approved/Rejected), and a concise body message identifying the relevant attendance date.

## 4.4.0 Accessibility Needs

- Notification text must be compatible with OS-level screen readers (e.g., VoiceOver, TalkBack).

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'Notifications are only sent for the final outcomes (approved/rejected) of a correction request, not for intermediate status changes.', 'enforcement_point': 'The backend Cloud Function that triggers on Firestore writes to the attendance collection.', 'violation_handling': "The function should not trigger a notification if the status change is not to a final 'approved' state or a reversion due to rejection."}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-045

#### 6.1.1.2 Dependency Reason

A correction request must be submittable before its outcome can be notified.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-047

#### 6.1.2.2 Dependency Reason

The 'approve' action is a necessary trigger for the 'approved' notification.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-048

#### 6.1.3.2 Dependency Reason

The 'reject' action is a necessary trigger for the 'rejected' notification.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Messaging (FCM) must be configured for the project.
- A Cloud Function triggered by Firestore document updates is required.
- The mobile client must have the FCM SDK integrated and configured to handle incoming messages and deep links.
- User documents in Firestore must have a field to store the user's current FCM device token.

## 6.3.0.0 Data Dependencies

- The attendance record must have a clear status field that changes upon approval or rejection.
- The user's profile must contain a valid and current FCM token.

## 6.4.0.0 External Dependencies

- Relies on the availability and delivery guarantees of Apple Push Notification service (APNs) and Google's Firebase Cloud Messaging service.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The Cloud Function execution time should be under 500ms.
- The notification should be sent from the server within 2 seconds of the supervisor's action.

## 7.2.0.0 Security

- The notification payload should not contain sensitive Personally Identifiable Information (PII). It should only contain the necessary data for display and deep linking (e.g., record ID, date).
- The deep link handler in the app must ensure the user is authenticated and authorized to view the target record before displaying it.

## 7.3.0.0 Usability

- The notification text must be clear, unambiguous, and easily understandable by the user.

## 7.4.0.0 Accessibility

- WCAG 2.1 Level AA standards apply to any in-app screens the user is directed to.

## 7.5.0.0 Compatibility

- Push notifications must function correctly on supported versions of iOS (12.0+) and Android (6.0+).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both backend (Cloud Function) and frontend (Flutter client) development.
- Implementing robust deep linking that works when the app is in foreground, background, or terminated can be complex.
- Managing FCM device tokens, including registration, updates, and removal of stale tokens, adds overhead.
- Requires careful state management in the client app after a deep link to ensure correct navigation.

## 8.3.0.0 Technical Risks

- Users may have notifications disabled at the OS level, preventing delivery. The app should handle this gracefully.
- FCM token invalidation can lead to failed sends. The backend function needs robust error handling to manage this.
- Platform-specific differences in handling notifications and deep links between iOS and Android.

## 8.4.0.0 Integration Points

- Firestore: A Cloud Function will listen for updates on the `/attendance` collection.
- Firebase Cloud Messaging (FCM): The Cloud Function will use the FCM Admin SDK to send messages.
- Flutter Client: The client app will receive messages and handle navigation.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Verify 'approved' notification is sent and received.
- Verify 'rejected' notification is sent and received.
- Verify deep link works when app is in the foreground.
- Verify deep link works when app is in the background.
- Verify deep link works when app is terminated.
- Verify deep link flow when user is logged out.
- Verify no notification is sent for other status changes on the attendance record.

## 9.3.0.0 Test Data Needs

- Test accounts for a Subordinate and their corresponding Supervisor.
- An attendance record with a pending correction request.
- A physical or emulated device with the app installed and configured to receive notifications.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for testing Cloud Function logic locally.
- Jest for Cloud Function unit tests.
- flutter_test for client-side unit/widget tests.
- integration_test for E2E testing on a device/emulator.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing on both iOS and Android.
- Cloud Function code is written in TypeScript, unit tested with Jest, and deployed.
- Flutter client code for handling notifications and deep linking is implemented and reviewed.
- Unit and widget tests for Flutter client logic are implemented and passing.
- E2E tests confirming the entire flow from supervisor action to subordinate notification are passing.
- Code reviewed and approved by at least one other developer.
- Performance of the Cloud Function is verified to be within acceptable limits.
- Story deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story provides a critical feedback loop for the user, significantly improving the correction workflow experience. It should be prioritized soon after the core correction functionality is complete.
- Requires coordinated effort between backend and mobile developers.

## 11.4.0.0 Release Impact

Completes a key user-facing workflow. Its absence would make the correction feature feel incomplete and less user-friendly.

