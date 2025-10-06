# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-079 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User adjusts the application's text size based on ... |
| As A User Story | As a user, particularly one with visual impairment... |
| User Persona | Any user (Subordinate, Supervisor, Admin) on the m... |
| Business Value | Improves application accessibility and usability, ... |
| Functional Area | User Interface & Accessibility |
| Story Theme | Core Usability and Accessibility |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Text scales up when device font size is increased

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

The user has the application open and is viewing any screen with text

### 3.1.5 When

the user navigates to their device's system settings and increases the font size

### 3.1.6 And

the UI layout reflows gracefully to accommodate the larger text without horizontal scrolling or critical content being truncated.

### 3.1.7 Then

all text within the application (buttons, labels, input fields, list items) renders at the new, larger size

### 3.1.8 Validation Notes

Test on both iOS and Android. Verify that UI containers like cards or list items expand vertically as needed. The change should be visible without an app restart.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Text scales down when device font size is decreased

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

The user has the application open with a larger-than-default font size set

### 3.2.5 When

the user navigates to their device's system settings and decreases the font size

### 3.2.6 And

the UI layout adjusts correctly.

### 3.2.7 Then

all text within the application renders at the new, smaller size

### 3.2.8 Validation Notes

Test on both iOS and Android. Verify that the change is visible without an app restart.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Layout remains usable at maximum accessibility font size

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

The user has the application open

### 3.3.5 When

the user sets their device's font size to the maximum accessibility setting available

### 3.3.6 And

all interactive elements like buttons and links remain visible and tappable.

### 3.3.7 Then

no text overlaps with other text or UI elements

### 3.3.8 Validation Notes

This is a critical accessibility test. Check for Flutter 'overflow' errors. Content that is too long for the screen should be accessible via vertical scrolling.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Touch targets remain usable at minimum font size

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

The user has the application open

### 3.4.5 When

the user sets their device's font size to the minimum setting available

### 3.4.6 Then

all interactive elements (buttons, tabs, list items) maintain a minimum tappable area compliant with platform guidelines (e.g., 44x44 pts for iOS, 48x48 dp for Android), even if the text within them is very small.

### 3.4.7 Validation Notes

Verify that buttons do not shrink below the minimum recommended touch target size, which would make them difficult to use.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Web dashboard text scales with browser zoom

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

An Admin user is viewing the web dashboard in a supported browser

### 3.5.5 When

the user zooms the browser view in or out (up to 200%)

### 3.5.6 Then

all text scales accordingly and the responsive layout adjusts without introducing horizontal scrollbars or breaking the UI.

### 3.5.7 Validation Notes

This ensures the web component also meets WCAG 1.4.4. Test on Chrome, Firefox, Safari, and Edge.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- All text-based widgets (Text, TextFields, Button labels, etc.)

## 4.2.0 User Interactions

- The application must automatically react to OS-level font size changes without requiring user interaction within the app.

## 4.3.0 Display Requirements

- There should be no in-app setting for font size; the app must exclusively inherit this setting from the operating system.
- Layouts must be built using responsive widgets (e.g., Flexible, Expanded, Wrap, LayoutBuilder) to prevent overflow errors.

## 4.4.0 Accessibility Needs

- The implementation must satisfy WCAG 2.1 Success Criterion 1.4.4 (Resize text), which requires that text can be resized up to 200 percent without loss of content or functionality.

# 5.0.0 Business Rules

*No items available*

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-021', 'dependency_reason': 'Requires at least one primary screen (e.g., the role-specific dashboard) to exist to test the text scaling functionality.'}

## 6.2.0 Technical Dependencies

- Flutter framework's support for `MediaQuery.textScaleFactor`.
- Consistent use of responsive layout widgets across the entire application codebase.

## 6.3.0 Data Dependencies

*No items available*

## 6.4.0 External Dependencies

*No items available*

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The UI must not exhibit noticeable lag or jank when re-rendering after a font size change.

## 7.2.0 Security

*No items available*

## 7.3.0 Usability

- The experience of changing font size should be seamless, reflecting OS settings automatically to meet user expectations.

## 7.4.0 Accessibility

- Must comply with WCAG 2.1 Level AA, specifically criterion 1.4.4.

## 7.5.0 Compatibility

- The feature must be fully functional on all supported OS versions: Android 6.0+ and iOS 12.0+.
- Web dashboard scaling must work on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Medium

## 8.2.0 Complexity Factors

- Requires a disciplined, app-wide approach to UI development rather than a single, isolated change.
- Retrofitting this into existing, non-responsive layouts can be time-consuming.
- Extensive manual testing is required across numerous screens, devices, and font size settings to ensure no UI breakages.

## 8.3.0 Technical Risks

- Risk of visual regressions (pixel overflows, overlapping elements) on complex screens if not built with responsive widgets.
- Inconsistent behavior if some custom widgets do not correctly implement text scaling.

## 8.4.0 Integration Points

*No items available*

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Widget
- Manual E2E
- Accessibility

## 9.2.0 Test Scenarios

- Verify text scaling on all major application screens (Login, Dashboard, Lists, Detail Views, Forms, Settings).
- Test with the four key font sizes: minimum, default, a large setting, and the maximum accessibility setting.
- Confirm that layouts reflow correctly in both portrait and landscape orientations with scaled text.
- Use Flutter's debug tools to ensure no overflow errors are logged during testing.

## 9.3.0 Test Data Needs

- Test user accounts for each role (Admin, Supervisor, Subordinate) to access all relevant screens.

## 9.4.0 Testing Tools

- Physical devices for both iOS and Android are highly recommended over emulators to accurately test accessibility settings.
- Platform-native accessibility inspectors (Accessibility Inspector for iOS, Accessibility Scanner for Android).

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing on both iOS and Android
- Code reviewed and approved, with a focus on the use of responsive layout widgets
- Widget tests implemented for key UI components to verify they handle `textScaleFactor` correctly
- Manual end-to-end testing completed for all primary user flows at minimum, default, and maximum font sizes with no layout overflows or usability issues
- Accessibility requirements (WCAG 1.4.4) verified
- Documentation updated to include text scaling as a standard for all new UI development
- Story deployed and verified in the staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

5

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This is a foundational story. It should be implemented early in the project to establish a baseline for all future UI work.
- All subsequent UI stories must be tested against the standards set by this story.

## 11.4.0 Release Impact

- Critical for the first public release to ensure the application is accessible and usable for the widest possible audience.

