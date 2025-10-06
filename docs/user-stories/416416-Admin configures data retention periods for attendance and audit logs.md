# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-074 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures data retention periods for attend... |
| As A User Story | As an Admin, I want to configure specific retentio... |
| User Persona | Admin |
| Business Value | Enables compliance with data protection regulation... |
| Functional Area | Administration |
| Story Theme | Tenant Configuration and Compliance |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin views the current data retention settings

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

the user is logged in as an Admin and has navigated to the 'Tenant Settings' section of the web dashboard

### 3.1.5 When

the Admin clicks on the 'Data Retention' or 'Data Management' sub-section

### 3.1.6 Then

the UI displays the current retention period settings for 'Attendance Records' and 'Audit Logs', showing the numerical value and time unit (e.g., '2 Years').

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin successfully updates and saves a retention period

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

the Admin is viewing the 'Data Retention' settings page

### 3.2.5 When

the Admin changes the retention period for 'Attendance Records' from '2' to '3' years and clicks the 'Save Changes' button

### 3.2.6 Then

the system displays a success notification (e.g., 'Settings saved successfully').

### 3.2.7 Validation Notes

Verify that the new value ('3 years') is displayed on the page and the corresponding field in the `/tenants/{tenantId}/config/singletonDoc` document in Firestore is updated.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin attempts to save an invalid (non-positive) retention period

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

the Admin is viewing the 'Data Retention' settings page

### 3.3.5 When

the Admin enters '-1' or '0' into a retention period input field and clicks 'Save Changes'

### 3.3.6 Then

a validation error message is displayed next to the field (e.g., 'Value must be greater than 0').

### 3.3.7 Validation Notes

Verify that the save operation is prevented and the configuration in Firestore is not updated.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin attempts to save a non-numeric value

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

the Admin is viewing the 'Data Retention' settings page

### 3.4.5 When

the Admin enters 'abc' into a retention period input field

### 3.4.6 Then

the input field should either prevent the entry of non-numeric characters or display a validation error upon attempting to save.

### 3.4.7 Validation Notes

Verify that the save operation is prevented.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin navigates away with unsaved changes

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

the Admin has modified a retention period value but has not clicked 'Save Changes'

### 3.5.5 When

the Admin attempts to navigate to a different page within the dashboard

### 3.5.6 Then

the browser displays a confirmation dialog (e.g., 'You have unsaved changes. Are you sure you want to leave?').

### 3.5.7 Validation Notes

Confirming the dialog discards changes and navigates away. Canceling keeps the user on the page with their changes intact.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Non-Admin user attempts to access the data retention settings page

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

a user with a 'Supervisor' or 'Subordinate' role is logged in

### 3.6.5 When

the user attempts to access the URL for the data retention settings page directly

### 3.6.6 Then

the system denies access and redirects them to their default dashboard.

### 3.6.7 Validation Notes

This should be enforced by both frontend routing logic and backend Firestore Security Rules.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A dedicated 'Data Retention' section within the Admin web dashboard.
- Numerical input fields for 'Attendance Records' and 'Audit Logs' retention periods.
- Dropdown selectors for time units (e.g., 'Years', 'Months').
- A 'Save Changes' button, which is disabled by default and enabled only when changes are made.
- Help text or tooltips explaining each setting and any minimum/maximum constraints.

## 4.2.0 User Interactions

- Admin can type numbers into the input fields.
- Admin can select a time unit from the dropdown.
- Clicking 'Save Changes' triggers a save operation with visual feedback (e.g., loading spinner) followed by a success or error message.

## 4.3.0 Display Requirements

- The page must clearly display the current, saved retention policies.
- Validation errors must be displayed inline, next to the relevant input field.

## 4.4.0 Accessibility Needs

- All form elements must have associated labels for screen readers.
- The UI must adhere to WCAG 2.1 Level AA for color contrast and keyboard navigation.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Only users with the 'Admin' role can view or modify data retention settings.

### 5.1.3 Enforcement Point

Frontend routing and Firestore Security Rules on the tenant configuration document.

### 5.1.4 Violation Handling

Access is denied, and the user is redirected. Write operations to the config document are rejected by Firestore.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Retention periods must be positive, whole numbers.

### 5.2.3 Enforcement Point

Client-side UI validation and server-side validation within the Cloud Function that processes the update.

### 5.2.4 Violation Handling

The UI prevents saving and shows an error. The server-side function rejects the invalid update.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

A minimum retention period may be enforced for compliance (e.g., Audit Logs minimum 1 year).

### 5.3.3 Enforcement Point

Client-side UI validation and server-side validation.

### 5.3.4 Violation Handling

The UI displays an error message indicating the minimum required value and prevents saving.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-001

#### 6.1.1.2 Dependency Reason

A tenant and its configuration document structure must exist before settings can be saved to it.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-021

#### 6.1.2.2 Dependency Reason

The Admin web dashboard must exist to provide a location for the settings UI.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for role verification.
- Firestore for storing the tenant configuration.
- Flutter for Web for the Admin dashboard UI.
- A scheduled Firebase Cloud Function is required to act upon these settings (the creation of this function is part of this story, but its full, robust implementation may be a separate technical task).

## 6.3.0.0 Data Dependencies

- The tenant configuration data model must be defined, likely as a singleton document within a `/tenants/{tenantId}/config` subcollection.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- Saving the configuration should complete within 2 seconds.
- The scheduled function that reads this configuration must be designed to process data in batches to avoid timeouts and excessive memory usage.

## 7.2.0.0 Security

- Access to the configuration settings UI and the underlying Firestore document must be strictly limited to Admins of the specific tenant using Firestore Security Rules based on the `tenantId` and `role` custom claims.

## 7.3.0.0 Usability

- The purpose and impact of changing each setting should be clearly explained in the UI to prevent accidental misconfiguration.

## 7.4.0.0 Accessibility

- The settings page must be fully compliant with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- The UI component is low complexity.
- The primary complexity lies in the backend implementation of the scheduled Cloud Function that will perform the data purging/anonymization. This function must be scalable, idempotent, and thoroughly tested.
- Defining and enforcing minimum/maximum retention limits requires careful consideration of compliance needs.

## 8.3.0.0 Technical Risks

- The data processing function, if not designed correctly, could be costly or time out on tenants with large data volumes. It must use cursors and batching.
- Accidentally deleting the wrong data due to a bug in the function is a high-impact risk, mandating rigorous testing with the Firebase Emulator Suite.

## 8.4.0.0 Integration Points

- The UI integrates with Firestore to read/write the tenant configuration.
- A scheduled Cloud Function will read from the same Firestore configuration document to determine its processing logic.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Security

## 9.2.0.0 Test Scenarios

- Verify an Admin can update settings.
- Verify a Supervisor cannot access the settings page.
- Verify invalid inputs are rejected by the UI.
- Using the Firebase Emulator Suite, manually trigger the scheduled function and verify it correctly queries for documents based on the configured retention period.

## 9.3.0.0 Test Data Needs

- A test tenant with an Admin user.
- In the emulator, pre-populate Firestore with attendance and audit log records with timestamps older than a test retention period.

## 9.4.0.0 Testing Tools

- flutter_test
- Firebase Local Emulator Suite
- Jest for Cloud Function unit tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented for the UI with >80% coverage
- Unit tests implemented for the Cloud Function logic
- Integration testing completed successfully using the Firebase Emulator Suite
- User interface reviewed and approved for usability and accessibility
- Security requirements validated (Firestore rules tested)
- Documentation for the configuration settings and the scheduled function is created
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This story provides the configuration UI and the basic structure for the data processing function. A separate, more complex technical story may be needed to fully implement and optimize the data purging/anonymization logic for large-scale production use.
- Requires collaboration between a frontend (Flutter Web) and backend (Cloud Functions) developer.

## 11.4.0.0 Release Impact

This is a key feature for enterprise customers and organizations with strict data compliance requirements. It is not required for an initial MVP but should be prioritized for early follow-on releases.

