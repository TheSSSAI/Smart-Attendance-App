# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-028 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate checks in for attendance |
| As A User Story | As a Subordinate, I want to tap a 'Check-In' butto... |
| User Persona | Subordinate: The primary end-user of the mobile ap... |
| Business Value | Provides a verifiable, time-stamped, and geo-locat... |
| Functional Area | Attendance Management |
| Story Theme | Core Attendance Workflow |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful check-in with an active internet connection

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a logged-in Subordinate on the main dashboard, I have granted location permissions, and I have not checked in for the current calendar day

### 3.1.5 When

I tap the 'Check-In' button

### 3.1.6 Then

The system captures my current client timestamp and GPS coordinates, a new attendance record is created in Firestore with status 'pending', and the UI updates to show a success message and my check-in time, and the 'Check-In' button is disabled.

### 3.1.7 Validation Notes

Verify a new document in the `/attendance` collection with the correct `userId`, `checkInTime`, `checkInGps`, and `status`. The `checkOutTime` should be null.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Check-in attempt without location permissions

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

I am a logged-in Subordinate and I have previously denied or not yet granted location permissions

### 3.2.5 When

I tap the 'Check-In' button

### 3.2.6 Then

The system prompts me to grant location permissions. If I grant them, the check-in proceeds. If I deny them, the check-in fails and an error message is displayed stating that location is required.

### 3.2.7 Validation Notes

Test the full permission request lifecycle on both iOS and Android. Verify that check-in cannot be completed without permission.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Check-in attempt with no GPS signal

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

I am a logged-in Subordinate with location permissions granted, but my device cannot acquire a GPS signal

### 3.3.5 When

I tap the 'Check-In' button

### 3.3.6 Then

The app displays a loading indicator for up to 10 seconds. If a signal is not acquired, the process fails and an error message is displayed, such as 'Could not get location. Please move to an open area and try again.'

### 3.3.7 Validation Notes

Use device emulators or developer tools to simulate a scenario with no GPS fix. Verify the timeout and error message.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Successful check-in while the device is offline

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

I am a logged-in Subordinate and my device has no internet connectivity

### 3.4.5 When

I tap the 'Check-In' button

### 3.4.6 Then

The attendance record is created in the local Firestore cache with an `isOfflineEntry` flag set to true. The UI updates immediately to show I am checked in. The data will sync automatically when connectivity is restored.

### 3.4.7 Validation Notes

Enable airplane mode on a device. Perform check-in. Verify UI update. Disable airplane mode. Verify the record appears in the Firestore backend with the `isOfflineEntry` flag.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Attempting to check in more than once in a day

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am a logged-in Subordinate and I have already successfully checked in for the current calendar day

### 3.5.5 When

I view the main dashboard

### 3.5.6 Then

The 'Check-In' button is disabled or hidden, preventing me from creating a duplicate check-in record for the same day.

### 3.5.7 Validation Notes

After a successful check-in, close and reopen the app. Verify the 'Check-In' button remains disabled.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Server-side validation of client timestamp

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

A check-in record is successfully synced to Firestore

### 3.6.5 When

The record is created in the database

### 3.6.6 Then

A Cloud Function trigger compares the `clientTimestamp` with the `serverTimestamp`. If the discrepancy is greater than 5 minutes, the record is flagged with `clock_discrepancy`.

### 3.6.7 Validation Notes

Manually create a test record in Firestore with a client timestamp 6 minutes in the past. Verify the Cloud Function adds the `clock_discrepancy` flag to the record's `flags` array.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Check-in with assigned events for the day

### 3.7.3 Scenario Type

Alternative_Flow

### 3.7.4 Given

I am a logged-in Subordinate and I have one or more events assigned to me for the current day

### 3.7.5 When

I tap the 'Check-In' button and after location is captured

### 3.7.6 Then

I am presented with a list of my events for the day and can optionally select one to link to my attendance record. The selected `eventId` is stored in the attendance record.

### 3.7.7 Validation Notes

Create an event for a test user. Log in as that user and check in. Verify the event selection UI appears and that selecting an event correctly populates the `eventId` field in the Firestore document.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A prominent 'Check-In' button on the main dashboard.
- A status display area on the dashboard to show 'Checked In at HH:MM' or 'Not Checked In'.
- A loading indicator/spinner to show when the system is processing the check-in.
- Toast/Snackbar for success and error messages.
- System dialog for requesting location permissions.

## 4.2.0 User Interactions

- Tapping the 'Check-In' button initiates the workflow.
- After a successful check-in, the 'Check-In' button must be disabled, and the 'Check-Out' button (from US-029) must be enabled.
- The app must provide immediate visual feedback for the action's outcome (success, loading, failure).

## 4.3.0 Display Requirements

- The dashboard must clearly display the user's current attendance status for the day.
- Error messages must be user-friendly and actionable (e.g., 'Please enable location services in your device settings.').

## 4.4.0 Accessibility Needs

- The 'Check-In' button must have a clear, accessible label for screen readers.
- Sufficient color contrast for all UI elements and text.
- Loading indicators should be announced by screen readers.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-002

### 5.1.2 Rule Description

A user can only have one open attendance record per calendar day. A new check-in is not allowed until the previous day's record has been checked out.

### 5.1.3 Enforcement Point

Client-side UI logic and Firestore Security Rules.

### 5.1.4 Violation Handling

The 'Check-In' button is disabled in the UI. Server-side rules will reject any attempt to create a duplicate record.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-003

### 5.2.2 Rule Description

GPS location is mandatory for all check-in records.

### 5.2.3 Enforcement Point

Client-side application logic before sending data.

### 5.2.4 Violation Handling

The check-in process fails with an error if GPS coordinates cannot be obtained.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

User must be authenticated to have a `userId` to associate with the attendance record.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

A role-specific dashboard is required to host the 'Check-In' button and display attendance status.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-076

#### 6.1.3.2 Dependency Reason

The flow for requesting and handling location permissions is a direct prerequisite for capturing GPS data.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication SDK for user identification.
- Firebase Firestore SDK for data persistence and offline capabilities.
- A Flutter location plugin (e.g., 'geolocator') to access device GPS.
- Firebase Cloud Functions for server-side logic (e.g., clock discrepancy check).

## 6.3.0.0 Data Dependencies

- The logged-in user's profile document must exist in Firestore to retrieve their `supervisorId`.

## 6.4.0.0 External Dependencies

- Device Operating System (iOS/Android) for providing location services.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- REQ-NFR-001: GPS lock time shall be less than 10 seconds under normal conditions.
- REQ-NFR-001: Firestore data sync for the check-in operation shall complete in less than 1 second on a stable connection.

## 7.2.0.0 Security

- REQ-NFR-003: All communication with Firebase services must be encrypted via TLS.
- REQ-NFR-003: GPS data must be non-editable by the end-user, enforced via Firestore Security Rules.
- REQ-NFR-003: Users can only create attendance records for themselves, enforced via Firestore Security Rules (`request.auth.uid == resource.data.userId`).

## 7.3.0.0 Usability

- The check-in process should be achievable in a single tap from the main screen (excluding permission prompts).

## 7.4.0.0 Accessibility

- REQ-INT-001: The feature must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- REQ-DEP-001: Must function correctly on Android 6.0+ and iOS 12.0+.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Handling the nuances of location permissions and services across both iOS and Android.
- Implementing a robust offline-first approach, ensuring the UI state is always consistent with the local data cache.
- Coordinating client-side actions with server-side logic in Cloud Functions (e.g., the clock discrepancy flag).

## 8.3.0.0 Technical Risks

- Inaccurate GPS readings in dense urban environments or indoors.
- Changes in OS-level permission handling in future Android/iOS versions could break the location-gathering flow.

## 8.4.0.0 Integration Points

- Integrates with the device's native location services.
- Writes data to the Firebase Firestore database.
- Triggers a Firebase Cloud Function on document creation.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Usability

## 9.2.0.0 Test Scenarios

- Verify successful online check-in.
- Verify successful offline check-in and subsequent sync.
- Verify failure and user guidance when location permissions are denied.
- Verify failure and user guidance when GPS signal is unavailable.
- Verify the 'Check-In' button is disabled after a successful check-in.
- Verify the clock discrepancy flag is correctly applied by the Cloud Function.

## 9.3.0.0 Test Data Needs

- Test users with the 'Subordinate' role.
- Test users with and without assigned events for the current day.

## 9.4.0.0 Testing Tools

- Flutter Test Framework (`flutter_test`) for unit and widget tests.
- Firebase Local Emulator Suite for integration and E2E testing without live data.
- Device emulators and physical devices for manual and automated E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- Integration testing with Firebase Emulators completed successfully
- E2E tests for offline and permission flows are passing
- User interface reviewed and approved by the Product Owner
- Performance requirements for GPS lock and data sync are verified
- Security rules for creating attendance records are deployed and tested
- Documentation for the attendance data model is updated
- Story deployed and verified in the staging environment on both Android and iOS

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story for the application's core functionality and blocks other stories like Check-Out (US-029) and Supervisor Approval (US-037).
- Requires setup and configuration of a location services package and potentially platform-specific code for permissions.
- The associated Cloud Function must be developed and deployed in tandem with the client-side feature.

## 11.4.0.0 Release Impact

This feature is critical for the Minimum Viable Product (MVP) release.

