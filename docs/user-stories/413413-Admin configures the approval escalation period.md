# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-071 |
| Elaboration Date | 2025-01-24 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures the approval escalation period |
| As A User Story | As an Admin, I want to configure the approval esca... |
| User Persona | Admin: The user responsible for setting organizati... |
| Business Value | Improves operational efficiency by preventing bott... |
| Functional Area | Administration |
| Story Theme | Tenant Configuration Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully sets a valid escalation period

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

The Admin is logged into the web dashboard and is viewing the 'Tenant Settings' page

### 3.1.5 When

The Admin enters a positive integer (e.g., '3') into the 'Approval Escalation Period' input field and clicks 'Save'

### 3.1.6 Then

The system displays a success notification (e.g., 'Settings saved successfully') and the value '3' is persisted in the tenant's configuration document in Firestore.

### 3.1.7 Validation Notes

Verify by reloading the page and confirming the input field displays '3'. Also, check the Firestore document `/tenants/{tenantId}/config/settings` for the field `approvalEscalationDays` with the value `3`.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin attempts to save a non-numeric value

### 3.2.3 Scenario Type

Error_Condition

### 3.2.4 Given

The Admin is on the 'Tenant Settings' page

### 3.2.5 When

The Admin enters a non-numeric string (e.g., 'five') into the 'Approval Escalation Period' field and attempts to save

### 3.2.6 Then

The system prevents the save operation and displays an inline validation error message, such as 'Please enter a valid number.'

### 3.2.7 Validation Notes

The 'Save' button might be disabled, or a validation message should appear upon clicking it. The value in Firestore must not change.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin attempts to save a value less than one

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

The Admin is on the 'Tenant Settings' page

### 3.3.5 When

The Admin enters '0' or a negative number (e.g., '-1') into the 'Approval Escalation Period' field and attempts to save

### 3.3.6 Then

The system prevents the save operation and displays an inline validation error message, such as 'Value must be 1 or greater.'

### 3.3.7 Validation Notes

Verify for both '0' and negative integers. The value in Firestore must not change.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin attempts to save a non-integer value

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

The Admin is on the 'Tenant Settings' page

### 3.4.5 When

The Admin enters a decimal value (e.g., '2.5') into the 'Approval Escalation Period' field and attempts to save

### 3.4.6 Then

The system prevents the save operation and displays an inline validation error message, such as 'Value must be a whole number.'

### 3.4.7 Validation Notes

The value in Firestore must not change.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Non-Admin user attempts to access the tenant settings

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

A user with a 'Supervisor' or 'Subordinate' role is logged in

### 3.5.5 When

The user attempts to navigate to the URL for the 'Tenant Settings' page

### 3.5.6 Then

The system denies access and either redirects them to their own dashboard or displays an 'Access Denied' message.

### 3.5.7 Validation Notes

This should be enforced by both UI logic and Firestore Security Rules on the configuration document.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Setting is correctly loaded on page visit

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

The 'Approval Escalation Period' has been previously set to '7'

### 3.6.5 When

The Admin navigates to the 'Tenant Settings' page

### 3.6.6 Then

The input field for 'Approval Escalation Period' is pre-populated with the value '7'.

### 3.6.7 Validation Notes

Verify that the application correctly fetches and displays the existing configuration from Firestore upon page load.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A numeric input field labeled 'Approval Escalation Period (days)'.
- A 'Save' or 'Update Settings' button.
- Helper text below the input field explaining its purpose: 'Set the number of days a pending approval can remain with a supervisor before being automatically escalated.'
- A toast or snackbar component for success/error notifications.

## 4.2.0 User Interactions

- The 'Save' button should be disabled by default and only become enabled when a change is made to the form.
- Inline validation messages should appear next to the input field upon invalid input.
- The system must provide clear visual feedback (e.g., a loading spinner on the button) during the save operation.

## 4.3.0 Display Requirements

- The current saved value for the escalation period must be displayed when the page loads.

## 4.4.0 Accessibility Needs

- The input field must have a corresponding `<label>` for screen reader compatibility.
- Validation error messages must be programmatically associated with the input field (e.g., using `aria-describedby`).
- All UI elements must meet WCAG 2.1 AA color contrast standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

The approval escalation period must be a positive integer greater than or equal to 1.

### 5.1.3 Enforcement Point

Client-side validation in the Admin web dashboard and server-side via Firestore Security Rules on the configuration document.

### 5.1.4 Violation Handling

The save operation is rejected, and the user is shown an informative error message.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

Only users with the 'Admin' role can modify the tenant configuration.

### 5.2.3 Enforcement Point

Firestore Security Rules on the `/tenants/{tenantId}/config/{docId}` path.

### 5.2.4 Violation Handling

Any write attempt from a non-Admin user is rejected by Firestore with a 'Permission Denied' error.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

- {'story_id': 'US-021', 'dependency_reason': 'The Admin web dashboard must exist and be accessible to the Admin role before this configuration setting can be added to it.'}

## 6.2.0 Technical Dependencies

- Firebase Authentication for role-based access control.
- Firestore database for storing the configuration value.
- Flutter for Web framework for the Admin dashboard UI.

## 6.3.0 Data Dependencies

- Requires the existence of a tenant configuration document in Firestore (e.g., `/tenants/{tenantId}/config/settings`) where the value will be stored.

## 6.4.0 External Dependencies

*No items available*

# 7.0.0 Non Functional Requirements

## 7.1.0 Performance

- The save operation for the setting should complete in under 500ms on a stable internet connection.

## 7.2.0 Security

- Access to view and modify this setting must be strictly limited to users with the 'Admin' role for the specific tenant, enforced by Firestore Security Rules using custom claims (`tenantId`, `role`).

## 7.3.0 Usability

- The purpose of the setting should be immediately clear to the Admin through proper labeling and helper text.

## 7.4.0 Accessibility

- The configuration form must be fully keyboard-navigable and compliant with WCAG 2.1 Level AA standards.

## 7.5.0 Compatibility

- The Admin web dashboard must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0 Implementation Considerations

## 8.1.0 Complexity Assessment

Low

## 8.2.0 Complexity Factors

- Involves adding a single field to an existing settings form.
- Client-side validation logic is simple.
- Backend change is limited to updating a Firestore document and its security rules.
- The more complex logic that *uses* this value is handled in a separate story (US-044).

## 8.3.0 Technical Risks

- Minimal risk. The primary risk is ensuring the Firestore Security Rule is correctly written to prevent unauthorized access.

## 8.4.0 Integration Points

- The value stored from this story will be read by the scheduled Cloud Function responsible for handling approval escalations (as defined in US-044).

# 9.0.0 Testing Requirements

## 9.1.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Security

## 9.2.0 Test Scenarios

- Verify an Admin can set and save a valid number.
- Verify saving is blocked for invalid inputs (0, negative, decimal, non-numeric).
- Verify that a non-Admin user (Supervisor/Subordinate) cannot access the settings page.
- Verify Firestore Security Rules reject write attempts from non-Admins.
- Verify the saved value is correctly displayed upon page reload.

## 9.3.0 Test Data Needs

- Test user accounts with 'Admin', 'Supervisor', and 'Subordinate' roles within the same tenant.

## 9.4.0 Testing Tools

- Firebase Local Emulator Suite for local development and integration testing.
- flutter_test for unit and widget tests.
- Jest for testing Firestore Security Rules.

# 10.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented for the UI component with >80% coverage
- Integration testing for the save functionality and security rules completed successfully
- User interface reviewed and approved for usability and accessibility
- Security requirements validated, specifically the Firestore Security Rules
- Documentation for the tenant configuration settings is updated
- Story deployed and verified in the staging environment

# 11.0.0 Planning Information

## 11.1.0 Story Points

1

## 11.2.0 Priority

🔴 High

## 11.3.0 Sprint Considerations

- This story is a prerequisite for US-044 ('Pending approval is escalated'). It must be completed in a sprint before or concurrently with US-044 to avoid blocking the implementation of the escalation logic.

## 11.4.0 Release Impact

- Enables a key automation feature for the approval workflow. Without this, the escalation feature cannot be configurable and would need to use a hardcoded value.

