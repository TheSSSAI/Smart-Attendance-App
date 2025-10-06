# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-076 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User is prompted to grant location permissions bef... |
| As A User Story | As a first-time user of the mobile application, I ... |
| User Persona | Any first-time user (Subordinate, Supervisor, or A... |
| Business Value | Ensures compliance with platform policies (Apple A... |
| Functional Area | User Onboarding & Permissions |
| Story Theme | Core Application Functionality |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: User grants 'While Using the App' permission on first attempt

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A user has logged into the application for the first time and has not yet been asked for location permissions

### 3.1.5 When

The user taps a UI element that requires location data (e.g., the 'Check-In' button)

### 3.1.6 Then

The native OS location permission dialog is displayed, showing the app's custom usage description.

### 3.1.7 And

The dialog is dismissed, and the application proceeds with the location-dependent action (e.g., fetching GPS coordinates).

### 3.1.8 Validation Notes

Verify on both iOS and Android. Check that the correct usage description from Info.plist/AndroidManifest.xml is displayed in the prompt.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Error Condition: User denies location permission

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

The native OS location permission dialog is displayed

### 3.2.5 When

The user selects the 'Deny' (or equivalent) option

### 3.2.6 Then

The native dialog is dismissed.

### 3.2.7 And

The location-dependent action (e.g., 'Check-In') is blocked from proceeding.

### 3.2.8 Validation Notes

Verify the in-app message is clear and the 'Open Settings' button correctly navigates the user to the right screen.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Edge Case: User attempts to use feature after previously denying permission

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

A user has previously denied location permission for the app (including 'Don't Ask Again' on Android)

### 3.3.5 When

The user taps the 'Check-In' button again

### 3.3.6 Then

The native OS permission dialog is NOT shown.

### 3.3.7 And

The in-app message explaining the requirement and providing a link to the OS settings is displayed immediately.

### 3.3.8 Validation Notes

Test this by first denying permission, closing the app, reopening, and trying the action again.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Edge Case: User grants only 'Approximate' location on a compatible OS

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

A user is on an OS that supports precise vs. approximate location (e.g., iOS 14+, Android 12+)

### 3.4.5 When

The user grants only 'Approximate' location permission

### 3.4.6 And

The message provides a button to open the device's app settings to upgrade the permission.

### 3.4.7 Then

The system detects the permission is not precise.

### 3.4.8 Validation Notes

This must be tested on devices or emulators running compatible OS versions.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Alternative Flow: User grants permission, revokes it from settings, and tries again

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

A user has previously granted location permission

### 3.5.5 When

The user manually navigates to the device OS settings and revokes the app's location permission

### 3.5.6 And

The user returns to the app and taps the 'Check-In' button

### 3.5.7 Then

The system correctly identifies that permission is now missing and triggers the flow described in AC-003.

### 3.5.8 Validation Notes

This tests the app's ability to re-check permissions on every use, not just the first time.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Native OS permission dialog (system-controlled)
- In-app dialog/snackbar/message area to display permission-denied information
- A button within the in-app message labeled 'Open Settings' or similar.

## 4.2.0 User Interactions

- The app must request permission contextually, i.e., when the feature is first invoked, not on app launch.
- The 'Open Settings' button must deep-link directly to the app's permission settings in the OS, not just the general settings menu.

## 4.3.0 Display Requirements

- The reason for the permission request must be clearly stated in the native configuration files (e.g., `NSLocationWhenInUseUsageDescription` in Info.plist for iOS).

## 4.4.0 Accessibility Needs

- The in-app message for denied permissions must be accessible to screen readers (VoiceOver/TalkBack).
- The 'Open Settings' button must have a clear, accessible label.

# 5.0.0 Business Rules

- {'rule_id': 'BR-PERM-001', 'rule_description': "Location permission must be granted for 'While Using the App' and must be 'Precise' for any attendance marking action to proceed.", 'enforcement_point': "Client-side, before attempting to access the device's GPS hardware.", 'violation_handling': 'The action is blocked, and the user is presented with a clear, actionable message guiding them to resolve the permission issue in the device settings.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-021', 'dependency_reason': "User must be logged in and see a role-specific dashboard that contains the UI element (e.g., 'Check-In' button) that will trigger this permission request."}

## 6.2.0 Technical Dependencies

- A Flutter package for managing cross-platform permissions (e.g., 'permission_handler').
- Configuration of native project files (Info.plist for iOS, AndroidManifest.xml for Android) with appropriate permission declarations and usage descriptions.

## 6.3.0 Data Dependencies

*No items available*

## 6.4.0 External Dependencies

- Apple App Store and Google Play Store review guidelines regarding permission requests.

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The permission status check should be performed asynchronously and not block the UI thread.
- The display of the permission prompt or the in-app message should feel instantaneous to the user (<200ms).

## 7.2.0 Security

- The application MUST only request 'When In Use' location permissions. It MUST NOT request 'Always Allow' or background location access.
- The usage description string provided to the OS must be truthful and accurately reflect why the data is needed.

## 7.3.0 Usability

- The permission request should not be triggered on the initial app launch, but rather when the user first attempts to use the feature, providing context for the request.
- The language used in the denial message must be simple, non-technical, and guide the user to a solution.

## 7.4.0 Accessibility

- The system must adhere to WCAG 2.1 Level AA standards for any custom UI elements related to this flow.

## 7.5.0 Compatibility

- The implementation must correctly handle permission model differences between recent and older versions of iOS (e.g., iOS 12 vs 15+) and Android (e.g., API 23+ vs API 31+).

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Medium

## 8.2.0 Complexity Factors

- Handling the various permission states (granted, denied, permanently denied, restricted, limited/approximate) across both iOS and Android.
- Implementing a robust and user-friendly flow for guiding users to the OS settings.
- Platform-specific configuration and potential for rejection during app store review if not implemented correctly.

## 8.3.0 Technical Risks

- Future OS updates may change permission APIs, requiring maintenance.
- Incorrectly configured native project files (Info.plist, AndroidManifest.xml) will lead to crashes or app store rejection.
- Bugs or inconsistencies in third-party permission handling packages.

## 8.4.0 Integration Points

- Device Operating System (for native dialogs and settings deep-linking).
- Any module or service within the app that initiates a location request.

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Widget
- Integration
- E2E

## 9.2.0 Test Scenarios

- First-time install and permission grant.
- First-time install and permission denial.
- Denying, then attempting the action again.
- Granting, then revoking from OS settings, then attempting the action.
- Granting 'Approximate' location on a compatible OS.
- Verifying the 'Open Settings' button navigates correctly on both platforms.

## 9.3.0 Test Data Needs

- Requires test devices or emulators running a range of target OS versions for both iOS and Android.

## 9.4.0 Testing Tools

- Flutter's `integration_test` framework for automated E2E testing of the permission flows.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing on target iOS and Android versions.
- Code reviewed and approved by team.
- Unit and widget tests implemented for permission logic and custom UI, with >80% coverage.
- E2E integration tests for all major permission flows are implemented and passing.
- User interface for the 'denied' state reviewed and approved by UX/Product.
- Native project files (Info.plist, AndroidManifest.xml) are correctly configured with usage descriptions.
- Story successfully tested and verified on physical devices for both platforms.
- Documentation for developers on how to trigger and test permission flows is created.

# 11.0.0 Planning Information

## 11.1.0 Story Points

3

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This story is a blocker for all core attendance features. It must be completed in an early sprint.
- Requires access to physical devices or well-configured emulators for thorough testing.

## 11.4.0 Release Impact

Critical for the first release. The application cannot function or be approved by app stores without this implementation.

