# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-072 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures default working hours for reporti... |
| As A User Story | As an Admin, I want to define default working hour... |
| User Persona | Admin: The primary administrator for an organizati... |
| Business Value | Enables automated exception reporting (lateness, e... |
| Functional Area | Administration |
| Story Theme | Tenant Configuration Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully sets working hours for the first time

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the Admin is logged in and has navigated to the 'Tenant Settings' page

### 3.1.5 When

the Admin enters '09:00' for the start time, '17:30' for the end time, selects Monday through Friday as working days, and clicks 'Save'

### 3.1.6 Then

a success notification is displayed, and the working hours configuration is saved to the tenant's configuration document in Firestore.

### 3.1.7 Validation Notes

Verify by reloading the page and seeing the saved values. Also, check the Firestore document `/tenants/{tenantId}/config/{singletonDoc}` for the new data.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin updates existing working hours

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Admin is on the 'Tenant Settings' page where working hours are already set to '09:00'-'17:30', Mon-Fri

### 3.2.5 When

the Admin changes the end time to '17:00' and deselects 'Friday', then clicks 'Save'

### 3.2.6 Then

a success notification is displayed, and the updated configuration is saved to Firestore.

### 3.2.7 Validation Notes

Verify the updated values are shown on page reload and are correctly stored in the Firestore document.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin attempts to save with end time before start time

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

the Admin is on the 'Tenant Settings' page

### 3.3.5 When

the Admin sets the start time to '17:00' and the end time to '09:00' and clicks 'Save'

### 3.3.6 Then

a validation error message, such as 'End time must be after start time', is displayed, and the data is not saved.

### 3.3.7 Validation Notes

The save button might become disabled, or a toast/inline error should appear. No write operation should occur in Firestore.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin attempts to save without selecting any working days

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

the Admin is on the 'Tenant Settings' page

### 3.4.5 When

the Admin sets a valid start and end time but does not select any working days and clicks 'Save'

### 3.4.6 Then

a validation error message, such as 'Please select at least one working day', is displayed, and the data is not saved.

### 3.4.7 Validation Notes

Verify that the form submission is blocked and no data is written to the database.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin views the configured organization timezone

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

the Admin is on the 'Tenant Settings' page for configuring working hours

### 3.5.5 When

the page loads

### 3.5.6 Then

a non-editable label or helper text is displayed, indicating the organization's currently configured timezone (e.g., 'All times are in UTC-05:00 America/New_York').

### 3.5.7 Validation Notes

This confirms the context for the time inputs. If the timezone is not set, a message prompting the Admin to set it first should appear.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin clears the working hours configuration

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

the Admin is on the 'Tenant Settings' page with working hours already configured

### 3.6.5 When

the Admin clears the start and end time fields (or uses a dedicated 'Clear' button) and clicks 'Save'

### 3.6.6 Then

the working hours configuration is removed from the tenant's settings in Firestore, effectively disabling late/early reporting.

### 3.6.7 Validation Notes

Verify that the relevant fields are removed or nulled in the Firestore document.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Time picker input for 'Default Start Time'
- Time picker input for 'Default End Time'
- A group of checkboxes or a multi-select component for 'Working Days' (e.g., Mon, Tue, Wed, Thu, Fri, Sat, Sun)
- A 'Save' button
- A non-editable text display for the organization's timezone
- Success and error notification components (e.g., toasts or snackbars)

## 4.2.0 User Interactions

- The 'Save' button should be disabled until a change is made to the form.
- Time pickers should present a user-friendly clock interface.
- Validation errors should appear inline, next to the relevant fields, upon attempting to save invalid data.

## 4.3.0 Display Requirements

- The form must pre-populate with the currently saved values when the page loads.
- Helper text should clarify that these settings are for reporting purposes only.

## 4.4.0 Accessibility Needs

- All form inputs must have associated labels for screen readers.
- The interface must be fully navigable using a keyboard.
- Sufficient color contrast must be used for text, inputs, and validation messages.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

The default end time must be chronologically after the default start time.

### 5.1.3 Enforcement Point

Client-side form validation before submission.

### 5.1.4 Violation Handling

Prevent form submission and display an inline error message to the user.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

At least one working day must be selected if start and end times are provided.

### 5.2.3 Enforcement Point

Client-side form validation before submission.

### 5.2.4 Violation Handling

Prevent form submission and display an inline error message.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

Only users with the 'Admin' role can modify the default working hours configuration.

### 5.3.3 Enforcement Point

Firestore Security Rules on the server-side.

### 5.3.4 Violation Handling

The write operation will be denied by Firestore, and the client should handle the permission-denied error gracefully.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-069

#### 6.1.1.2 Dependency Reason

Working hours are relative to the organization's timezone. The timezone must be configurable and available before setting the hours.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

The Admin must be able to log in and access a role-specific dashboard where the settings page can be located.

## 6.2.0.0 Technical Dependencies

- A defined data model for tenant configuration in Firestore (e.g., `/tenants/{tenantId}/config/{singletonDoc}`).
- Firebase Authentication for role-based access control.
- Flutter for Web framework for the Admin dashboard.

## 6.3.0.0 Data Dependencies

- The tenant's configured timezone value must be readable by the settings page.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The settings page should load existing configuration from Firestore in under 1 second.
- The save operation should complete and provide user feedback in under 2 seconds on a stable connection.

## 7.2.0.0 Security

- Access to this configuration page must be restricted to authenticated users with the 'Admin' role.
- Firestore Security Rules must strictly enforce that only an Admin of a given tenant can write to their own tenant's configuration document.

## 7.3.0.0 Usability

- The interface should be intuitive, requiring no special training for an Admin to understand and use.
- Feedback (success, error, loading) must be immediate and clear.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Standard form implementation with basic validation.
- Single document read/write operation in Firestore.
- No complex business logic on the backend.

## 8.3.0.0 Technical Risks

- Potential for timezone-related bugs if not handled carefully. All times should be stored consistently (e.g., as 'HH:mm' strings in 24-hour format) and interpreted in the context of the tenant's timezone setting.

## 8.4.0.0 Integration Points

- Reads from and writes to the tenant configuration document in Firestore.
- The reporting module (specifically for US-061) will read this configuration to perform its calculations.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify successful creation, update, and clearing of working hours.
- Test all validation rules (invalid time range, no days selected).
- Test access control: attempt to access/modify the settings as a 'Supervisor' or 'Subordinate' and verify failure.
- Verify the page correctly displays the tenant's timezone.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user.
- A test tenant with the timezone pre-configured.
- A test tenant without a timezone configured to test the dependency handling.

## 9.4.0.0 Testing Tools

- flutter_test for unit and widget tests.
- Firebase Local Emulator Suite for integration testing.
- integration_test package for E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for the new code
- Integration testing against the Firebase Emulator completed successfully
- User interface reviewed and approved for usability and accessibility
- Firestore security rules updated and tested
- Documentation for the configuration setting is updated in the Admin Guide
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This story is a blocker for US-061 (Late Arrival / Early Departure Report) and should be planned accordingly.
- Confirm that US-069 (Timezone Configuration) is completed before starting this story.

## 11.4.0.0 Release Impact

Enables a key reporting feature. Its absence would delay the availability of automated punctuality reports.

