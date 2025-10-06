# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-068 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin re-authorizes Google Sheets sync after a fai... |
| As A User Story | As an Admin, I want to be prompted with clear acti... |
| User Persona | Admin: The user responsible for managing tenant-le... |
| Business Value | Ensures the reliability and continuity of the auto... |
| Functional Area | Reporting and Data Export |
| Story Theme | Integration Management and Reliability |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully re-authenticates after a token revocation failure

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin is logged into the web dashboard and the Google Sheets sync status is 'error' with a reason of 'AUTH_ERROR'

### 3.1.5 When

the Admin navigates to the Integrations page and clicks the 'Re-authenticate' button, then successfully completes the Google OAuth 2.0 flow

### 3.1.6 Then

the system securely updates the stored OAuth refresh token, the sync status in Firestore for the integration is updated to 'active', and the error alert on the dashboard is replaced with a success message.

### 3.1.7 Validation Notes

Verify in Firestore that the `/linkedSheets/{adminUserId}` document status is 'active'. Verify a subsequent sync job runs successfully.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Admin successfully links a new sheet after the original was deleted

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

an Admin is logged into the web dashboard and the Google Sheets sync status is 'error' with a reason of 'SHEET_NOT_FOUND'

### 3.2.5 When

the Admin clicks the 'Link New Sheet' button, provides a valid URL for a new Google Sheet they have edit access to, and confirms

### 3.2.6 Then

the system updates the stored target `sheetId`, validates write access to the new sheet, updates the sync status to 'active', and the error alert is replaced with a success message.

### 3.2.7 Validation Notes

Verify in Firestore that the `sheetId` has been updated. Verify that the next sync job writes data to the *new* sheet.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

System triggers a catch-up sync after successful recovery

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

the Google Sheets sync has been successfully restored after a failure and there are attendance records that previously failed to sync

### 3.3.5 When

the next scheduled sync job runs

### 3.3.6 Then

the system exports all previously failed (queued) records to the Google Sheet without creating duplicates.

### 3.3.7 Validation Notes

Manually create several 'approved' attendance records while the sync is broken. After fixing the sync, confirm these records appear in the Google Sheet.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Admin cancels the re-authentication flow

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

an Admin has clicked the 'Re-authenticate' button and is in the middle of the Google OAuth flow

### 3.4.5 When

the Admin closes the Google authentication window or clicks 'Cancel'

### 3.4.6 Then

the Admin is returned to the application dashboard, the sync status remains 'error', and a message is displayed indicating that authentication was not completed.

### 3.4.7 Validation Notes

Start the OAuth flow and cancel it. Verify the UI state in the application has not changed and the error alert persists.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin attempts to link an invalid or inaccessible sheet

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

an Admin is on the 'Link New Sheet' interface

### 3.5.5 When

the Admin provides a URL to a Google Sheet for which they only have 'Viewer' permissions and clicks 'Save'

### 3.5.6 Then

the system rejects the change, the sync status remains 'error', and an inline error message is displayed stating 'Permission denied. Please select a sheet where you have editor access.'

### 3.5.7 Validation Notes

Use a test Google account to create a sheet and share it with the Admin's test account with 'View only' permissions. Attempt to link this sheet.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Admin attempts to link a sheet with a mismatched schema

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

an Admin is on the 'Link New Sheet' interface

### 3.6.5 When

the Admin provides a URL to a valid Google Sheet, but the header row does not match the required export format

### 3.6.6 Then

the system rejects the change, the sync status remains 'error', and an inline error message is displayed stating 'Invalid sheet format. Please ensure the header row matches the required template.'

### 3.6.7 Validation Notes

Create a new Google Sheet and manually change the column headers. Attempt to link this sheet.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A persistent, non-dismissible alert banner on the Admin dashboard when sync status is 'error'.
- A 'Re-authenticate' button, visible only when the error type is related to authentication.
- A 'Link New Sheet' button, visible for errors like 'sheet not found' or 'permission denied'.
- An input field or file picker interface for providing the new Google Sheet URL/ID.
- Success and error toast notifications to provide immediate feedback on actions.

## 4.2.0 User Interactions

- Clicking 'Re-authenticate' initiates the Google OAuth 2.0 popup/redirect flow.
- Clicking 'Link New Sheet' opens a modal or navigates to a dedicated page for updating the sheet link.
- Upon successful resolution, the error banner should be removed and replaced by a temporary success message.

## 4.3.0 Display Requirements

- The error banner must display a user-friendly message explaining the cause of the failure (e.g., 'Authentication with Google has expired.', 'The linked Google Sheet could not be found.').
- The current sync status ('Active', 'Error', 'Syncing...') and the name/ID of the linked sheet should be clearly visible on the integration settings page.

## 4.4.0 Accessibility Needs

- The error banner must have an appropriate ARIA role (e.g., 'alert') to be announced by screen readers.
- All buttons and interactive elements must be keyboard-navigable and have clear focus indicators.
- Color contrast for error messages and banners must meet WCAG 2.1 AA standards.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Only users with the 'Admin' role can access the integration settings page and perform recovery actions.

### 5.1.3 Enforcement Point

Server-side (Firestore Security Rules) and client-side (UI routing).

### 5.1.4 Violation Handling

User is shown a 'Permission Denied' page or redirected to their default dashboard.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

A catch-up sync of failed records must be automatically triggered upon successful restoration of the integration.

### 5.2.3 Enforcement Point

Backend Cloud Function after successfully updating the integration status to 'active'.

### 5.2.4 Violation Handling

The failure to trigger the catch-up sync should be logged as a high-priority server error for investigation.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-065

#### 6.1.1.2 Dependency Reason

Establishes the initial configuration of the Google Sheets export feature.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-066

#### 6.1.2.2 Dependency Reason

Implements the initial OAuth 2.0 flow that this story will re-use for re-authentication.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-067

#### 6.1.3.2 Dependency Reason

This story is the recovery mechanism for the failure states detected and flagged by US-067. The error detection must exist first.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user roles.
- Firebase Firestore for storing integration status.
- Firebase Cloud Functions for handling server-side logic.
- Google APIs Client Library for Node.js.

## 6.3.0.0 Data Dependencies

- Requires the existence of a document in the `/linkedSheets/{adminUserId}` collection that holds the integration's state, including `status`, `errorType`, `sheetId`, and the encrypted refresh token.

## 6.4.0.0 External Dependencies

- Availability of the Google Identity Platform (for OAuth 2.0).
- Availability of the Google Sheets API.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The UI response to clicking a recovery action button should be under 200ms.
- The entire re-authentication and status update process should complete within 5 seconds after the user successfully completes the Google OAuth flow.

## 7.2.0.0 Security

- The OAuth refresh token must be stored securely on the server-side (e.g., using Google Secret Manager) and never exposed to the client.
- All communication with Google APIs must use HTTPS.
- The OAuth callback handler must validate the 'state' parameter to prevent CSRF attacks.

## 7.3.0.0 Usability

- Error messages must be clear, concise, and guide the user toward the correct resolution path.
- The recovery process should require the minimum number of clicks possible.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web dashboard interface for this feature must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Interaction with a third-party OAuth 2.0 flow.
- Requires both frontend (Flutter Web) and backend (Cloud Functions) development.
- Careful state management of the integration status in Firestore.
- Robust error handling is needed to differentiate between failure types and guide the user appropriately.

## 8.3.0.0 Technical Risks

- Changes in the Google Sheets API or OAuth 2.0 flow could break the integration.
- Incorrectly handling the queuing and re-syncing of failed records could lead to data loss or duplication.

## 8.4.0.0 Integration Points

- Google Identity Platform (OAuth 2.0).
- Google Sheets API.
- Firebase Firestore (for state).
- Firebase Cloud Functions (for logic).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Simulate a revoked token and test the full re-authentication flow.
- Simulate a deleted sheet and test the 'link new sheet' flow.
- Test linking a sheet with incorrect permissions.
- Test linking a sheet with an invalid schema.
- Verify that queued data is correctly synced after recovery.

## 9.3.0.0 Test Data Needs

- A dedicated Google test account.
- A Google Sheet with the correct schema.
- A Google Sheet with read-only permissions for the test account.
- A Google Sheet with a deliberately incorrect schema.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development.
- Jest for Cloud Functions unit tests.
- `flutter_test` and `integration_test` for the Flutter web client.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for Cloud Functions and Flutter widgets, achieving >80% coverage
- Integration testing for the full recovery flow (failure -> prompt -> action -> success) completed successfully
- User interface reviewed and approved by a UX designer
- Security requirements, especially OAuth token handling, validated
- Documentation for the recovery process is added to the Admin user guide
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is blocked until US-067 is completed and merged.
- Requires coordination between frontend and backend developers.
- Access to a configured GCP project with necessary API credentials is required for development and testing.

## 11.4.0.0 Release Impact

Critical for the long-term reliability of the Google Sheets export feature. Should be included in the same release as the initial feature or the one immediately following.

