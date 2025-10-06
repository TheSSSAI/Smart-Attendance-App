# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-029 |
| Elaboration Date | 2025-01-17 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate checks out from attendance |
| As A User Story | As a Subordinate, I want to check out at the end o... |
| User Persona | Subordinate - The primary end-user of the mobile a... |
| Business Value | Completes the daily attendance data loop, enabling... |
| Functional Area | Attendance Management |
| Story Theme | Core Attendance Workflow |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful check-out on an active attendance record

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Subordinate user is logged in and has an active check-in record for the current calendar day (a record with a 'checkInTime' but null 'checkOutTime')

### 3.1.5 When

the user taps the 'Check-Out' button

### 3.1.6 Then

the system must capture the current client timestamp and GPS coordinates, update the existing attendance record with a 'checkOutTime' and 'checkOutGps', and display a success message like 'Checked out successfully at HH:MM'.

### 3.1.7 Validation Notes

Verify in Firestore that the correct attendance document is updated with non-null 'checkOutTime' and 'checkOutGps' fields. The UI should transition to a state indicating the workday is complete.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Check-out action updates the correct daily record

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Subordinate user has an active check-in record for the current day

### 3.2.5 When

the user performs the check-out action

### 3.2.6 Then

the system must update the *same* attendance document that was created during check-in for that day, and must not create a new document.

### 3.2.7 Validation Notes

Query Firestore for attendance records for the user on the current day. Confirm that only one record exists and that its 'checkOutTime' has been populated.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User performs a check-out while the device is offline

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

a Subordinate user has an active check-in and their device is offline

### 3.3.5 When

the user taps the 'Check-Out' button

### 3.3.6 Then

the system must capture the time and GPS, save the check-out data to the local Firestore cache with an 'isOfflineEntry' flag, and display a message indicating the record is saved locally and will sync when connectivity is restored.

### 3.3.7 Validation Notes

With the device in airplane mode, perform a check-out. Verify the UI updates. Then, restore connectivity and confirm the data syncs to the backend Firestore database.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

System cannot acquire a GPS signal during check-out

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

a Subordinate user attempts to check out

### 3.4.5 When

the device is unable to get a GPS lock within the 10-second timeout (e.g., user is deep indoors)

### 3.4.6 Then

the system must prevent the check-out, display a clear error message (e.g., 'Could not get your location. Please try again with a clearer view of the sky.'), and the attendance record must not be updated.

### 3.4.7 Validation Notes

Use a location mocking tool or test in an area with no GPS signal to verify the error message is shown and no data is written to Firestore.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

User has denied location permissions

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

a Subordinate user has previously denied or revoked location permissions for the app

### 3.5.5 When

the user taps the 'Check-Out' button

### 3.5.6 Then

the system must not proceed with the check-out and must display a message guiding the user to their device settings to enable location permissions.

### 3.5.7 Validation Notes

In the OS settings, revoke location permission for the app. Attempt to check out and verify the guidance prompt is displayed.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

UI state updates after successful check-out

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

a Subordinate user has successfully checked out for the day

### 3.6.5 When

they view the main attendance screen

### 3.6.6 Then

the 'Check-Out' button must be disabled or hidden, and the UI must clearly indicate that they are checked out for the day.

### 3.6.7 Validation Notes

After a successful check-out, confirm the button's state changes and the status text updates (e.g., 'Workday complete').

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A clearly labeled 'Check-Out' button on the main attendance screen.
- A loading indicator or spinner displayed while capturing GPS.
- A success message (e.g., Toast or Snackbar) upon successful check-out.
- An error message display area for failures (e.g., GPS unavailable).

## 4.2.0 User Interactions

- Tapping the 'Check-Out' button initiates the process.
- The 'Check-Out' button must be disabled after a successful check-in and enabled only after a check-in.
- The 'Check-Out' button must be disabled after a successful check-out for the day.

## 4.3.0 Display Requirements

- The main screen must display the user's current attendance status (e.g., 'Checked In', 'Checked Out').
- The success message should include the time of check-out.

## 4.4.0 Accessibility Needs

- The 'Check-Out' button must have a proper accessibility label.
- Loading indicators and status changes must be announced by screen readers.

# 5.0.0 Business Rules

- {'rule_id': 'BR-ATT-001', 'rule_description': "A check-out must update the corresponding check-in record for the same calendar day, as defined by the tenant's timezone. A new day requires a new check-in/check-out cycle.", 'enforcement_point': 'Client-side logic and Firestore Security Rules.', 'violation_handling': 'The system should prevent the creation of a new record and instead find and update the existing record for the day. If no check-in record exists, the action is disallowed.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

A user must be able to check in and create an attendance record before they can check out and update it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-030

#### 6.1.2.2 Dependency Reason

This story defines the logic for when the 'Check-Out' button is enabled, which is a direct prerequisite for this story's interaction.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-033

#### 6.1.3.2 Dependency Reason

The offline handling mechanism for attendance marking must be in place for the check-out action to function without connectivity.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-077

#### 6.1.4.2 Dependency Reason

The flow for guiding users to enable denied location permissions is required to handle a key error case.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user identification.
- Firebase Firestore for data storage and offline persistence.
- Device GPS/Location Services API (e.g., via Flutter's geolocator package).

## 6.3.0.0 Data Dependencies

- Requires an existing attendance record in Firestore with a null 'checkOutTime' for the current user and day.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- GPS lock acquisition time shall be less than 10 seconds under normal conditions (REQ-NFR-001).
- UI must remain responsive and maintain 60fps during the location capture process.

## 7.2.0.0 Security

- All communication with Firebase must be over TLS (HTTPS) (REQ-INT-004).
- Firestore Security Rules must enforce that a user can only update their own attendance records (REQ-NFR-003).
- The captured GPS data fields ('checkOutGps') must be non-editable by the user via security rules after initial submission.

## 7.3.0.0 Usability

- The check-out process should be achievable in a single tap from the main screen.
- Feedback to the user (success, loading, error) must be immediate and clear.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards (REQ-INT-001).

## 7.5.0.0 Compatibility

- Must function correctly on supported versions of Android (6.0+) and iOS (12.0+).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Interaction with native device hardware (GPS), which includes handling permissions, accuracy, and failure states.
- Robust state management to correctly reflect the user's check-in/out status and control UI elements accordingly.
- Implementing and testing the offline persistence and sync-on-reconnect logic.

## 8.3.0.0 Technical Risks

- Inconsistent GPS performance across different device models and OS versions.
- Potential race conditions if the user rapidly switches between online/offline states during the check-out process.

## 8.4.0.0 Integration Points

- Updates the `/attendance/{recordId}` document in Firestore.
- Reads user's authentication state from Firebase Auth.
- Interfaces with the mobile OS location services.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Manual

## 9.2.0.0 Test Scenarios

- Verify successful online check-out.
- Verify successful offline check-out and subsequent sync.
- Verify error handling for unavailable GPS.
- Verify error handling for denied location permissions.
- Verify that the check-out button is disabled before check-in and after check-out.

## 9.3.0.0 Test Data Needs

- A test user account with the 'Subordinate' role.
- An existing attendance record in the test database with a 'checkInTime' but null 'checkOutTime'.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for integration testing.
- Flutter's `integration_test` package for E2E tests.
- Device location mocking tools for testing GPS failure scenarios.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented for the check-out logic and UI, achieving >80% coverage
- Integration testing against the Firebase Emulator completed successfully
- End-to-end test scenario for the check-out flow is implemented and passing
- Manual testing confirms correct functionality on target iOS and Android physical devices
- Performance requirements for GPS lock time are verified
- Security rules preventing unauthorized updates are tested and validated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is part of the critical path for the application's core functionality.
- Should be planned in the same sprint as or immediately following US-028 (Check-in) to deliver a complete attendance cycle.

## 11.4.0.0 Release Impact

This is a fundamental feature required for the initial MVP release.

