# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-070 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures the auto-checkout time |
| As A User Story | As an Admin, I want to configure a specific time o... |
| User Persona | Admin: The user responsible for managing the entir... |
| Business Value | Improves data integrity by preventing open-ended a... |
| Functional Area | Administration |
| Story Theme | Tenant Configuration Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin enables and sets the auto-checkout time for the first time

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am an Admin logged into the web dashboard and navigating to the 'Tenant Settings' page

### 3.1.5 When

I enable the 'Automatic Check-out' feature using the toggle switch, select '17:30' in the time picker, and click 'Save'

### 3.1.6 Then

I see a success message confirming the settings have been saved.

### 3.1.7 And

When I refresh the page, the toggle remains enabled and the time picker displays '17:30'.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin modifies an existing auto-checkout time

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am an Admin on the 'Tenant Settings' page where the auto-checkout time is already set to '17:30'

### 3.2.5 When

I change the time to '18:00' and click 'Save'

### 3.2.6 Then

I see a success message.

### 3.2.7 And

The page reflects the new time of '18:00' after saving.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin disables the auto-checkout feature

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

I am an Admin on the 'Tenant Settings' page where the 'Automatic Check-out' feature is enabled

### 3.3.5 When

I disable the feature using the toggle switch and click 'Save'

### 3.3.6 Then

I see a success message.

### 3.3.7 And

The time picker component becomes disabled or hidden.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Backend function correctly uses the configured time

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

A tenant has configured their timezone to 'America/New_York' and their auto-checkout time to '17:45'

### 3.4.5 And

The record's `flags` array now contains 'auto-checked-out'.

### 3.4.6 When

The scheduled Cloud Function (from REQ-FUN-005) runs after 17:45 in the 'America/New_York' timezone

### 3.4.7 Then

The user's attendance record is updated with a `checkOutTime` corresponding to 17:45.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Attempting to save settings fails due to a server or network error

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

I am an Admin on the 'Tenant Settings' page

### 3.5.5 When

I change a setting and click 'Save', but the request to the server fails

### 3.5.6 Then

I see a clear and non-technical error message, such as 'Failed to save settings. Please check your connection and try again.'

### 3.5.7 And

The UI state reverts to reflect the last successfully saved configuration.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Non-Admin user attempts to access the tenant settings page

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

I am a user with a 'Supervisor' or 'Subordinate' role

### 3.6.5 When

I attempt to navigate to the URL for the 'Tenant Settings' page

### 3.6.6 Then

I am redirected to my own dashboard or shown an 'Access Denied' page.

### 3.6.7 And

No settings are displayed or can be modified.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A dedicated 'Tenant Settings' or 'Organization Configuration' section in the Admin web dashboard.
- A clear label: 'Automatic Check-out'.
- A toggle switch to enable or disable the feature.
- A standard time picker input field (e.g., HH:MM format).
- A 'Save Changes' button.

## 4.2.0 User Interactions

- Clicking the toggle enables/disables the time picker.
- The 'Save Changes' button is disabled until a change is made.
- After clicking 'Save', a loading indicator is shown, followed by a success or error toast/snackbar message.

## 4.3.0 Display Requirements

- The current saved auto-checkout time must be displayed when the page loads.
- A helper text should explain the feature, e.g., 'Automatically checks out users who have not checked out by the specified time, based on the organization's timezone.'

## 4.4.0 Accessibility Needs

- All form elements (toggle, time picker, button) must have `aria-label` attributes for screen readers.
- The UI must adhere to WCAG 2.1 Level AA for color contrast and keyboard navigation.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-070-01

### 5.1.2 Rule Description

The auto-checkout time must be applied based on the tenant's configured timezone.

### 5.1.3 Enforcement Point

Backend (Scheduled Cloud Function)

### 5.1.4 Violation Handling

The function must fail gracefully and log an error if the tenant's timezone is not set or invalid.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-070-02

### 5.2.2 Rule Description

Only users with the 'Admin' role can view or modify the auto-checkout configuration.

### 5.2.3 Enforcement Point

Frontend (UI visibility) and Backend (Firestore Security Rules)

### 5.2.4 Violation Handling

The UI for the setting will not be rendered for non-Admins. Any direct API call to modify the setting from a non-Admin user will be rejected by security rules.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-069

#### 6.1.1.2 Dependency Reason

The auto-checkout time is dependent on the organization's timezone setting to function correctly. The timezone must be configurable before this setting can be reliably used.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

The Admin must be able to log in and access a role-specific web dashboard where this setting will be located.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role-based access control.
- Firestore database for storing the tenant configuration.
- Firestore Security Rules for enforcing access control.
- Flutter for Web framework for the Admin dashboard UI.

## 6.3.0.0 Data Dependencies

- Requires access to the tenant's configuration document in Firestore, which stores the timezone.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The settings page must load in under 2 seconds.
- Saving the configuration change must complete within 500ms on a stable connection.

## 7.2.0.0 Security

- Access to modify the configuration document in Firestore must be strictly limited to authenticated users with an 'Admin' role custom claim for the correct `tenantId`.
- All communication must be over HTTPS.

## 7.3.0.0 Usability

- The setting should be easy to find within a clearly marked 'Settings' or 'Configuration' area.
- The purpose of the setting should be self-explanatory with minimal helper text.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- The UI component is a standard form with simple state management.
- The backend logic involves a simple write operation to a known Firestore document path.
- The primary complexity lies in the consuming Cloud Function (covered in US-032), not in the configuration itself.

## 8.3.0.0 Technical Risks

- None for this specific story. The risk is in the consuming scheduled function correctly interpreting timezone data, which is part of a different story (US-032).

## 8.4.0.0 Integration Points

- The UI integrates with Firestore to read and write the configuration.
- The saved configuration data will be read by the scheduled Cloud Function responsible for auto-checkout (REQ-FUN-005).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Verify an Admin can set, update, and disable the auto-checkout time.
- Verify the changes are correctly persisted in Firestore.
- Verify a non-Admin user cannot see or access the setting.
- Verify the UI handles save failures gracefully.
- An integration test should confirm the scheduled function (developed for US-032) correctly reads the value set by this story's functionality.

## 9.3.0.0 Test Data Needs

- Test accounts with 'Admin', 'Supervisor', and 'Subordinate' roles.
- A test tenant with a pre-configured timezone.

## 9.4.0.0 Testing Tools

- Flutter's `flutter_test` for unit and widget tests.
- Firebase Local Emulator Suite for integration testing of the UI and Firestore rules.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage and passing
- Integration testing with the Firebase Emulator completed successfully
- User interface reviewed for usability and accessibility (WCAG 2.1 AA)
- Firestore security rules are implemented and tested to restrict access to Admins
- Documentation for the feature is updated in the Admin Guide
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This story is a prerequisite for US-032 ('Subordinate's attendance is automatically checked out'). It should be prioritized in a sprint before or alongside US-032.
- Depends on the completion of US-069 ('Admin configures the organization's timezone').

## 11.4.0.0 Release Impact

This feature is a key part of the automation and data integrity value proposition. It should be included in any release that contains the core attendance functionality.

