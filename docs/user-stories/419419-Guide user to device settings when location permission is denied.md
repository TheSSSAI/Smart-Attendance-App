# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-077 |
| Elaboration Date | 2025-01-17 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Guide user to device settings when location permis... |
| As A User Story | As a mobile app user, I want to be shown a helpful... |
| User Persona | Any mobile app user (Subordinate, Supervisor, or A... |
| Business Value | Improves usability and user retention by providing... |
| Functional Area | User Experience & Onboarding |
| Story Theme | Core Application Usability |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

User attempts a location-based action with permissions permanently denied

### 3.1.3 Scenario Type

Alternative_Flow

### 3.1.4 Given

The user has previously denied location permissions for the app (e.g., selected 'Deny & Don't Ask Again')

### 3.1.5 When

The user taps a button that requires location services, such as 'Check-In' or 'Check-Out'

### 3.1.6 Then

A modal dialog or bottom sheet is displayed, preventing the action from proceeding.

### 3.1.7 Validation Notes

Verify on both iOS and Android. The trigger action is defined in US-028 and US-029.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Guidance dialog provides clear context and actions

### 3.2.3 Scenario Type

Alternative_Flow

### 3.2.4 Given

The permission guidance dialog is displayed

### 3.2.5 When

The user views the dialog

### 3.2.6 Then

The dialog text clearly explains why location permission is necessary for the feature (e.g., 'Location is required to record your attendance').

### 3.2.7 And

The dialog presents two clear actions: a primary action to resolve the issue (e.g., 'Open Settings') and a secondary action to dismiss (e.g., 'Cancel').

### 3.2.8 Validation Notes

Review the dialog copy for clarity and conciseness. Ensure buttons are clearly labeled.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User is successfully navigated to the OS app settings screen

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

The permission guidance dialog is displayed

### 3.3.5 When

The user taps the 'Open Settings' button

### 3.3.6 Then

The application deep-links the user directly to the app's specific settings page within the device's operating system (iOS or Android).

### 3.3.7 Validation Notes

This must be tested on physical devices for both platforms to ensure the deep link is correct and functional.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

User enables permission and returns to the app

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

The user has been navigated to the OS app settings screen

### 3.4.5 When

The user grants the location permission and then manually navigates back to the attendance app

### 3.4.6 Then

The permission guidance dialog is no longer visible.

### 3.4.7 And

The user can now successfully initiate the location-based action (e.g., check-in).

### 3.4.8 Validation Notes

Test the app's behavior upon returning to the foreground. The permission state should be re-checked.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

User returns to the app without enabling permission

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

The user has been navigated to the OS app settings screen

### 3.5.5 When

The user navigates back to the attendance app without granting the location permission

### 3.5.6 Then

The permission guidance dialog is dismissed.

### 3.5.7 And

If the user attempts the location-based action again, the guidance dialog is re-displayed.

### 3.5.8 Validation Notes

Ensure the app does not get stuck in a loop and gracefully handles the user's choice not to grant permission.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

User dismisses the guidance dialog

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

The permission guidance dialog is displayed

### 3.6.5 When

The user taps the 'Cancel' button

### 3.6.6 Then

The dialog is dismissed.

### 3.6.7 And

The user is returned to the previous screen, and the location-based action is not performed.

### 3.6.8 Validation Notes

Verify that dismissing the dialog does not crash the app or lead to an unexpected state.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Modal Dialog or Bottom Sheet component
- Primary Button ('Open Settings')
- Secondary/Text Button ('Cancel')

## 4.2.0 User Interactions

- Tapping the 'Open Settings' button should trigger a deep link to the OS settings.
- Tapping 'Cancel' or the background scrim (if applicable) should dismiss the dialog.

## 4.3.0 Display Requirements

- The dialog must clearly state the name of the permission required (Location).
- The dialog must provide a brief, user-friendly reason for needing the permission.

## 4.4.0 Accessibility Needs

- Dialog and its contents must be compliant with WCAG 2.1 Level AA standards.
- All text must be readable by screen readers.
- Buttons must have accessible labels and sufficient tap target size.

# 5.0.0 Business Rules

*No items available*

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-076

#### 6.1.1.2 Dependency Reason

This story handles the recovery flow after the initial permission request in US-076 is denied.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-028

#### 6.1.2.2 Dependency Reason

The check-in feature is the primary trigger for this permission guidance flow.

## 6.2.0.0 Technical Dependencies

- A Flutter package capable of checking permission status and opening OS-level app settings (e.g., 'permission_handler').

## 6.3.0.0 Data Dependencies

*No items available*

## 6.4.0.0 External Dependencies

- Relies on the device's operating system (iOS/Android) to provide a stable API for deep-linking to app-specific settings.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The permission check and dialog display must occur in under 200ms from the user's action.

## 7.2.0.0 Security

*No items available*

## 7.3.0.0 Usability

- The guidance flow must be intuitive and require minimal user effort to resolve the permission issue.

## 7.4.0.0 Accessibility

- Must meet WCAG 2.1 Level AA standards as per REQ-INT-001.

## 7.5.0.0 Compatibility

- The functionality must be verified on all supported OS versions: Android 6.0+ and iOS 12.0+.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Platform-specific implementation for deep-linking to settings on iOS and Android.
- Handling different states of permission denial (e.g., denied once vs. permanently denied).
- Managing the app's state when it returns from the background after the user has been in the OS settings.

## 8.3.0.0 Technical Risks

- Potential for OS updates to break the deep-linking mechanism.
- Inconsistent behavior of permission handling across different Android manufacturer skins.

## 8.4.0.0 Integration Points

- Integrates with the device's native OS for permission management and settings navigation.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Manual E2E

## 9.2.0.0 Test Scenarios

- Verify flow on Android after selecting 'Deny'.
- Verify flow on Android after selecting 'Deny & don't ask again'.
- Verify flow on iOS after denying permission.
- Verify successful check-in after granting permission via settings on both platforms.
- Verify app behavior when returning from settings without granting permission.

## 9.3.0.0 Test Data Needs

- Test devices/emulators must be configured to have location permissions for the app in a 'denied' state.

## 9.4.0.0 Testing Tools

- Flutter Driver or `integration_test` for automated E2E tests.
- Physical devices for manual verification of OS integration.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing on supported iOS and Android versions.
- Code reviewed and approved by team, adhering to Flutter best practices.
- Unit and widget tests implemented with >80% coverage for the new logic.
- Manual end-to-end testing completed successfully on physical devices.
- User interface reviewed and approved for clarity and usability.
- Accessibility requirements (WCAG 2.1 AA) have been validated.
- No regressions introduced to the initial permission request flow (US-076).
- Story deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

3

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a critical usability feature for the core app functionality. It should be prioritized early in the development cycle.
- Requires access to physical test devices for both iOS and Android to ensure reliability.

## 11.4.0.0 Release Impact

Essential for the first public release to ensure a smooth user experience and prevent user drop-off.

