# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-033 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate marks attendance while offline |
| As A User Story | As a Subordinate, I want to be able to check in an... |
| User Persona | Subordinate user who may work in areas with poor o... |
| Business Value | Ensures data integrity and accuracy by capturing a... |
| Functional Area | Attendance Management |
| Story Theme | Offline Capabilities |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

User performs a check-in while the device is offline

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

The user is logged into the application and their device has no internet connectivity

### 3.1.5 When

The user taps the 'Check-In' button

### 3.1.6 Then

The application successfully captures the current device timestamp and GPS coordinates, and a new attendance record is created in the local Firestore cache with a flag 'isOfflineEntry' set to true, and the UI updates to show a 'Checked In' status with a visual indicator that the record is pending synchronization.

### 3.1.7 Validation Notes

Verify by checking the local device state using debugging tools. The UI must immediately reflect the checked-in state. The 'Check-Out' button should become enabled.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

User performs a check-out while the device is offline

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

The user has an active check-in record for the day (created either online or offline) and their device has no internet connectivity

### 3.2.5 When

The user taps the 'Check-Out' button

### 3.2.6 Then

The application successfully captures the current device timestamp and GPS coordinates, and the existing local attendance record is updated with the check-out details, and the UI updates to show a 'Checked Out' status with a visual indicator that the record is pending synchronization.

### 3.2.7 Validation Notes

Verify by checking the local device state. The UI should reflect that the workday is complete for that record.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Offline records are automatically synchronized when connectivity is restored

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

The user has one or more attendance records stored in the local cache from offline actions

### 3.3.5 When

The device regains a stable internet connection

### 3.3.6 Then

The Firestore SDK automatically syncs the local records to the server, and the 'isOfflineEntry' flag is preserved on the server-side record, and the 'pending synchronization' visual indicator is removed from the UI for the successfully synced records.

### 3.3.7 Validation Notes

Verify the record appears in the Firestore backend with the correct data and the 'isOfflineEntry' flag. The mobile UI should update to remove the pending icon.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User attempts to check-in/out offline without a GPS signal

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

The user is offline and the device cannot acquire a GPS signal

### 3.4.5 When

The user taps the 'Check-In' or 'Check-Out' button

### 3.4.6 Then

The action is blocked, and the application displays a clear, non-dismissible error message to the user, such as 'GPS signal required. Please move to an open area.'

### 3.4.7 Validation Notes

Test using an emulator's location settings to simulate no GPS signal or by testing in a location known to block GPS (e.g., deep indoors).

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Application is closed before offline data can be synced

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

The user has performed an offline check-in/out and then terminates the application before regaining connectivity

### 3.5.5 When

The user later re-launches the application with an active internet connection

### 3.5.6 Then

The application's startup process ensures the Firestore SDK initiates the synchronization of any pending offline data.

### 3.5.7 Validation Notes

Perform an offline action, force-quit the app, re-establish network, re-launch the app, and verify the data syncs to the backend.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A persistent, non-intrusive visual indicator (e.g., a small cloud icon with a slash) on the main attendance screen when in offline mode.
- A 'pending sync' icon next to individual attendance records in the history view that have not yet been synced.

## 4.2.0 User Interactions

- The check-in/out buttons must remain responsive and provide immediate feedback even when offline.
- Tapping the offline indicator may optionally show a count of pending records (e.g., '3 records waiting to sync').

## 4.3.0 Display Requirements

- The UI must immediately reflect the state change (e.g., from 'Checked Out' to 'Checked In') after an offline action.
- Error messages for missing GPS must be clear and actionable.

## 4.4.0 Accessibility Needs

- The 'pending sync' visual indicator must have an appropriate content description for screen readers, such as 'Record pending synchronization'.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-ATT-001

### 5.1.2 Rule Description

A valid GPS coordinate is mandatory for both check-in and check-out actions, regardless of network status.

### 5.1.3 Enforcement Point

Client-side, before writing the record to the local cache.

### 5.1.4 Violation Handling

The action is blocked, and the user is shown an error message explaining the requirement.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-ATT-002

### 5.2.2 Rule Description

All attendance records created while the device is offline must be flagged with 'isOfflineEntry: true' to allow for auditing and special handling in reports and supervisor views.

### 5.2.3 Enforcement Point

Client-side, during the creation of the attendance record data model.

### 5.2.4 Violation Handling

This is a system logic rule; failure to apply the flag is a bug.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

The core online check-in functionality must exist before offline capabilities can be added.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-029

#### 6.1.2.2 Dependency Reason

The core online check-out functionality must exist before offline capabilities can be added.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore SDK configured with offline persistence enabled for the mobile client.
- Device's native location services (GPS).
- A reliable connectivity status detection library (e.g., Flutter's connectivity_plus).

## 6.3.0.0 Data Dependencies

- The attendance data model must include a boolean field such as 'isOfflineEntry'.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The local write operation for an offline attendance record must complete in under 200ms to ensure a responsive UI.

## 7.2.0.0 Security

- Locally cached data must be stored within the application's secure, sandboxed storage provided by the mobile OS. Firestore's offline persistence meets this requirement.

## 7.3.0.0 Usability

- The user should not need to take any special action to enable or use offline mode; it should be seamless.

## 7.4.0.0 Accessibility

- All UI elements related to offline status must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The offline functionality must be fully supported on all target OS versions (Android 6.0+ and iOS 12.0+).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires robust UI state management to reflect the pending sync status accurately and dynamically.
- Thorough testing is complex, requiring simulation of various network loss and recovery scenarios.
- Handling the interplay between offline actions and potential server-side data changes (e.g., by an Admin) requires careful design, although Firestore's model simplifies this.

## 8.3.0.0 Technical Risks

- Firestore's offline cache has size limits; while unlikely to be an issue for this use case, it's a known constraint.
- Inconsistent behavior of connectivity status APIs across different OS versions or device manufacturers.

## 8.4.0.0 Integration Points

- Integrates with the device's GPS hardware via a location plugin.
- Directly leverages the Firebase Firestore SDK's offline persistence feature.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- E2E: User goes offline, checks in, checks out, goes back online, and verifies data is correct in the backend.
- E2E: User goes offline, checks in, force-quits the app, reconnects to the network, relaunches the app, and verifies data syncs.
- Integration: Test the data repository layer to confirm it correctly writes to the local cache when the network is disabled.
- Unit: Test the state management logic to ensure it correctly identifies a record as 'pending sync'.

## 9.3.0.0 Test Data Needs

- Test accounts for the 'Subordinate' role.

## 9.4.0.0 Testing Tools

- Flutter's integration_test framework.
- Device emulators/simulators with network and GPS control capabilities.
- Firebase Local Emulator Suite to test Firestore rules and sync logic locally.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- E2E integration tests for all offline scenarios are implemented and passing
- User interface reviewed and approved by the product owner
- Performance of local write operations verified
- Accessibility labels for offline UI elements are implemented and verified
- Documentation for the offline data model and flags is updated
- Story deployed and verified in the staging environment on both Android and iOS physical devices

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational feature for mobile reliability and should be prioritized early. It is a prerequisite for handling sync failures (US-035) and for supervisor review of offline entries (US-038).

## 11.4.0.0 Release Impact

- Significantly improves the application's reliability and usability for field users, making it a key feature for the initial public release.

