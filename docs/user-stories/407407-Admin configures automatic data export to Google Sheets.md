# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-065 |
| Elaboration Date | 2025-01-20 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin configures automatic data export to Google S... |
| As A User Story | As an Admin, I want to configure a secure, automat... |
| User Persona | Admin: Responsible for tenant-wide configuration, ... |
| Business Value | Automates the data export process, reducing manual... |
| Functional Area | Reporting and Data Export |
| Story Theme | Integrations |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Admin successfully configures a new daily export

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

The Admin is logged into the web dashboard and is on the 'Integrations' settings page.

### 3.1.5 When

The Admin clicks 'Connect to Google Sheets', successfully completes the Google OAuth 2.0 authorization flow, provides a name for a new Google Sheet, selects a 'Daily' export schedule, and saves the configuration.

### 3.1.6 Then

The system securely stores the OAuth refresh token. A new Google Sheet with the specified name and correct headers is created in the Admin's Google Drive. The UI on the 'Integrations' page updates to show the status as 'Active', displaying the name of the linked sheet and an initial 'Last Sync' status of 'Pending'.

### 3.1.7 Validation Notes

Verify the OAuth token is stored in Google Secret Manager. Check the Admin's Google Drive for the newly created sheet. Verify the UI state change in the web dashboard.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Scheduled export function runs successfully

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

The Google Sheets export is configured and active.

### 3.2.5 And

There are new 'approved' attendance records since the last successful export.

### 3.2.6 When

The scheduled Cloud Function for data export is triggered.

### 3.2.7 Then

The function retrieves all new 'approved' attendance records. The records are appended as new rows to the linked Google Sheet in the predefined format. The 'Last Sync' timestamp in the Admin dashboard is updated to the current time.

### 3.2.8 Validation Notes

Trigger the function manually or wait for the schedule. Verify the new rows appear in the Google Sheet with correct data. Check the Firestore document for the updated 'lastExportedTimestamp' and verify the UI reflects this.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin denies permission during OAuth flow

### 3.3.3 Scenario Type

Error_Condition

### 3.3.4 Given

The Admin is on the 'Integrations' page and initiates the connection process.

### 3.3.5 When

The Admin is redirected to the Google consent screen and chooses to 'Deny' access.

### 3.3.6 Then

The Admin is redirected back to the application's 'Integrations' page. A non-intrusive error message is displayed, stating 'Permission was denied. The integration cannot be enabled without your consent.' The integration status remains 'Inactive'.

### 3.3.7 Validation Notes

Test the full OAuth flow and click 'Deny'. Verify the redirect and the presence of the specific error message.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Export fails because the target Google Sheet was deleted

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

The Google Sheets export is configured and active.

### 3.4.5 And

The Admin has manually deleted the target Google Sheet from their Google Drive.

### 3.4.6 When

The next scheduled export function runs.

### 3.4.7 Then

The function fails to access the sheet and logs a 'File not found' error. The integration's status in the database is updated to 'Error'. The Admin dashboard displays a prominent alert about the sync failure, as detailed in US-067.

### 3.4.8 Validation Notes

Set up the integration, delete the sheet, trigger the function, and verify the status change and alert in the UI.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Export fails because the Admin manually changed the sheet's headers

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

The Google Sheets export is configured and active.

### 3.5.5 And

The Admin has manually edited the header row in the target Google Sheet.

### 3.5.6 When

The next scheduled export function runs.

### 3.5.7 Then

The function validates the header row, detects a schema mismatch, and aborts the export. The integration's status is updated to 'Error' with a reason of 'Schema Mismatch'. The Admin dashboard displays an alert.

### 3.5.8 Validation Notes

Modify the header of the target sheet (e.g., delete 'User Email' column). Trigger the function and verify the error state.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin disconnects the Google Sheets integration

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

The Google Sheets export is configured and active.

### 3.6.5 When

The Admin clicks 'Manage' and then 'Disconnect' on the integration settings, and confirms the action.

### 3.6.6 Then

The system revokes and deletes the stored OAuth refresh token. The integration status is set to 'Inactive'. The UI updates to show the 'Connect to Google Sheets' button again.

### 3.6.7 Validation Notes

Verify the token is removed from Google Secret Manager. Confirm that the scheduled function no longer attempts to run for this tenant.

## 3.7.0 Criteria Id

### 3.7.1 Criteria Id

AC-007

### 3.7.2 Scenario

Scheduled export runs when there is no new data

### 3.7.3 Scenario Type

Edge_Case

### 3.7.4 Given

The Google Sheets export is configured and active.

### 3.7.5 And

There are no new 'approved' attendance records since the last successful export.

### 3.7.6 When

The scheduled export function is triggered.

### 3.7.7 Then

The function checks for new data, finds none, and completes successfully without writing to the Google Sheet. The 'Last Sync' timestamp is updated to reflect the check.

### 3.7.8 Validation Notes

Ensure all records are synced. Trigger the function and verify no new rows are added to the sheet, but the 'Last Sync' time updates in the UI.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A dedicated 'Integrations' or 'Data Export' section in the Admin web dashboard.
- A 'Connect to Google Sheets' button.
- A status indicator showing 'Active', 'Inactive', or 'Error'.
- Display text for the linked Google Sheet's name and the 'Last Sync' timestamp.
- A 'Manage' or 'Disconnect' button for an active integration.
- A configuration modal/page with a dropdown for schedule ('Daily', 'Weekly') and a text input for the new sheet's name.

## 4.2.0 User Interactions

- Clicking 'Connect' initiates the server-side OAuth 2.0 flow, redirecting the user to Google's consent screen.
- After authorization, the user is redirected back to the application.
- Saving the configuration provides immediate visual feedback (e.g., a toast notification).
- Error states should be clearly communicated with actionable advice.

## 4.3.0 Display Requirements

- The predefined format for exported data must be clearly documented for the Admin. The columns are: Record ID, User Name, User Email, Check-In Time, Check-In GPS Latitude, Check-In GPS Longitude, Check-Out Time, Check-Out GPS Latitude, Check-Out GPS Longitude, Status, Notes.
- Error messages must be user-friendly (e.g., 'Sheet not found. Please link a new sheet.' instead of 'API Error 404').

## 4.4.0 Accessibility Needs

- All buttons, inputs, and status indicators must have ARIA labels for screen reader compatibility.
- Ensure sufficient color contrast for status indicators (e.g., green for 'Active', red for 'Error').

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-GEXP-01

### 5.1.2 Rule Description

Only attendance records with a status of 'approved' are eligible for export.

### 5.1.3 Enforcement Point

Server-side Cloud Function query.

### 5.1.4 Violation Handling

Records with any other status ('pending', 'rejected') are filtered out and not included in the export batch.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-GEXP-02

### 5.2.2 Rule Description

Each tenant can only have one active Google Sheets export configuration at a time.

### 5.2.3 Enforcement Point

UI and Firestore Security Rules.

### 5.2.4 Violation Handling

The UI will only allow creating a new configuration if one does not already exist. The 'Connect' button is replaced by a 'Manage' button.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-021

#### 6.1.1.2 Dependency Reason

Requires the existence of a role-specific Admin web dashboard to host the configuration UI.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-039

#### 6.1.2.2 Dependency Reason

Requires the Supervisor approval workflow to be in place, as only 'approved' records are exported.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-066

#### 6.1.3.2 Dependency Reason

This story is the user-facing part of the integration; US-066 represents the core technical implementation of the OAuth 2.0 flow, which is a direct dependency.

## 6.2.0.0 Technical Dependencies

- Google Cloud project with billing enabled for Cloud Functions and Secret Manager.
- Firebase project configured.
- Google APIs Node.js Client Library (`googleapis`).

## 6.3.0.0 Data Dependencies

- Requires the existence of the `/attendance` collection with records that can be marked as 'approved'.

## 6.4.0.0 External Dependencies

- Availability of the Google Sheets API and Google Identity Platform (for OAuth 2.0).

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The scheduled export function must complete within the Cloud Function timeout limit (e.g., 540 seconds), even when processing thousands of records.
- The function must use batch write operations to the Google Sheets API to minimize API calls and improve throughput.

## 7.2.0.0 Security

- OAuth 2.0 refresh tokens MUST be stored in Google Secret Manager, not in Firestore.
- The scope of requested Google API permissions must be the minimum required (e.g., `https://www.googleapis.com/auth/drive.file`).
- The Cloud Function must validate that the request is for a legitimate, scheduled run and not an unauthorized invocation.

## 7.3.0.0 Usability

- The setup process should be straightforward and guided, requiring minimal technical knowledge from the Admin.
- Feedback on the integration's status must be clear and timely.

## 7.4.0.0 Accessibility

- The configuration UI must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard interface for this feature must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

High

## 8.2.0.0 Complexity Factors

- Implementing a secure, server-side OAuth 2.0 flow with token management.
- Robust error handling for various external API failure modes (permissions revoked, file not found, quota limits).
- State management to prevent duplicate data exports (tracking `lastExportedTimestamp`).
- Requires both frontend (Flutter for Web) and backend (TypeScript Cloud Function) development.

## 8.3.0.0 Technical Risks

- Changes in the Google Sheets API could break the integration.
- Hitting Google API rate limits or quotas for tenants with very high data volume.
- Incorrectly handling OAuth token refresh logic could lead to persistent failures.

## 8.4.0.0 Integration Points

- Firebase Authentication (for user identity in Cloud Function).
- Firestore (for reading attendance data and storing configuration).
- Google Secret Manager (for storing OAuth tokens).
- Google Sheets API (for writing data).
- Google Drive API (for creating the initial sheet).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Full E2E test of the setup flow from the UI.
- Integration test of the Cloud Function, verifying data appears correctly in a real Google Sheet.
- Test cases for all failure modes: revoked permissions, deleted sheet, schema mismatch, API quota exceeded.
- Security review of the token storage and retrieval mechanism.

## 9.3.0.0 Test Data Needs

- A test Firebase project.
- A dedicated Google account for testing the OAuth flow.
- A set of sample attendance records in Firestore with 'approved', 'pending', and 'rejected' statuses.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development.
- Jest for TypeScript Cloud Function unit tests.
- `flutter_test` and `integration_test` for the web dashboard UI.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing in a staging environment.
- Code for both frontend and backend is peer-reviewed and merged.
- Unit tests for the Cloud Function achieve >80% coverage.
- Successful end-to-end integration test has been performed.
- Security review of the OAuth token handling process is complete and approved.
- UI is responsive and meets accessibility standards.
- Relevant documentation in the Admin Guide is created or updated.
- The feature is deployed and verified in the staging environment.

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

13

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a large story that may need to be broken into smaller technical tasks (UI, OAuth Backend, Export Function) within a sprint.
- Requires a developer with experience in both frontend (Flutter) and backend (Node.js/TypeScript) as well as third-party API integrations.
- Blocker for any further reporting automation features.

## 11.4.0.0 Release Impact

This is a key feature for paid tiers, enabling organizations to integrate the system's data into their broader business intelligence and operational workflows.

