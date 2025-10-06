# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-066 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin authorizes Google Drive/Sheets access via OA... |
| As A User Story | As an Admin, I want to initiate a secure OAuth 2.0... |
| User Persona | Admin: The primary user responsible for tenant-lev... |
| Business Value | Enables the core functionality of automated data e... |
| Functional Area | Reporting and Data Export |
| Story Theme | Google Services Integration |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Successful Authorization Flow

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

The Admin is logged into the web dashboard and is on the 'Data Export' configuration page where the Google Sheets integration is shown as 'Not Connected'.

### 3.1.5 When

The Admin clicks the 'Connect to Google Sheets' button, is redirected to Google, authenticates, and grants the requested permissions.

### 3.1.6 Then

The Admin is redirected back to the 'Data Export' page, a success notification is displayed, the UI updates to show 'Connected' status along with the authorized Google account's email address, and a 'Disconnect' button becomes visible.

### 3.1.7 Validation Notes

Verify that a refresh token is securely stored in the `/linkedSheets/{adminUserId}` collection in Firestore, associated with the correct tenant and user.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

User Denies Permission

### 3.2.3 Scenario Type

Alternative_Flow

### 3.2.4 Given

The Admin is on the Google OAuth consent screen after initiating the connection.

### 3.2.5 When

The Admin clicks 'Deny' or closes the window without granting permission.

### 3.2.6 Then

The Admin is redirected back to the 'Data Export' page, an informational message like 'Authorization was cancelled' is displayed, and the connection status remains 'Not Connected'.

### 3.2.7 Validation Notes

Verify that no token is stored in Firestore for this user.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User Revokes Authorization from App

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

The Admin's Google account is already connected, and the UI shows a 'Connected' status.

### 3.3.5 When

The Admin clicks the 'Disconnect' button and confirms the action in a confirmation dialog.

### 3.3.6 Then

The application makes a server-side call to revoke the token with Google, deletes the stored refresh token from Firestore, and the UI reverts to the 'Not Connected' state.

### 3.3.7 Validation Notes

Check Firestore to confirm the token document has been deleted. Manually check the user's Google Account settings under 'Third-party apps with account access' to confirm the app's access has been removed.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

OAuth Flow Error Handling

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

The Admin attempts to connect to Google Sheets.

### 3.4.5 When

An error occurs during the OAuth flow (e.g., invalid redirect_uri, Google API is unavailable).

### 3.4.6 Then

The Admin is redirected back to the 'Data Export' page with a user-friendly error message (e.g., 'Could not connect to Google. Please try again later.') and the status remains 'Not Connected'.

### 3.4.7 Validation Notes

Simulate an error by misconfiguring the OAuth client ID or redirect URI in a test environment. The backend function should log the specific technical error from Google's API response.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Secure Token Exchange

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

The Admin has granted permission and been redirected back to the application with an authorization code in the URL.

### 3.5.5 When

The client-side application sends the authorization code to a secure backend Cloud Function.

### 3.5.6 Then

The Cloud Function successfully exchanges the code for an access token and a refresh token, and securely stores ONLY the refresh token in Firestore.

### 3.5.7 Validation Notes

The OAuth client secret must never be exposed on the client. Verify through code review that the token exchange happens exclusively in the Cloud Function.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A 'Connect to Google Sheets' button (when not connected).
- A status indicator displaying 'Connected' or 'Not Connected'.
- Display text for the connected Google account email address.
- A 'Disconnect' button (when connected).
- A confirmation modal for the 'Disconnect' action.
- Snackbar/toast notifications for success, info, and error messages.

## 4.2.0 User Interactions

- Clicking 'Connect' redirects the user to an external Google page in the same browser tab.
- After the Google flow, the user is automatically redirected back to the application.
- Clicking 'Disconnect' prompts the user for confirmation before proceeding.

## 4.3.0 Display Requirements

- The requested permissions must be clearly defined in the Google Cloud Console's OAuth consent screen configuration.
- Error messages should be user-friendly and avoid technical jargon.

## 4.4.0 Accessibility Needs

- All buttons and interactive elements must be keyboard-navigable and have appropriate ARIA labels.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Only one Google account can be linked per Admin user for the purpose of data export.

### 5.1.3 Enforcement Point

Application logic before initiating a new OAuth flow.

### 5.1.4 Violation Handling

If an account is already linked, the 'Connect' button should be disabled or hidden, replaced by the 'Disconnect' option.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The OAuth refresh token must be stored server-side and encrypted at rest.

### 5.2.3 Enforcement Point

Cloud Function responsible for token storage.

### 5.2.4 Violation Handling

A security review must fail any implementation that stores tokens unencrypted or on the client-side.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-065

#### 6.1.1.2 Dependency Reason

This story implements the authorization mechanism required by US-065. The UI elements for this story will be located on the configuration page defined in US-065.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-059

#### 6.1.2.2 Dependency Reason

Requires the existence of the Admin web dashboard where the configuration settings will reside.

## 6.2.0.0 Technical Dependencies

- A configured Google Cloud Project with the Google Sheets API and Google Drive API enabled.
- An OAuth 2.0 Client ID created within the GCP project, with authorized JavaScript origins and redirect URIs correctly configured for all environments (local, staging, production).
- A Firebase Cloud Function (HTTP callable) to handle the server-side token exchange.
- Google Secret Manager for securely storing the OAuth client secret.

## 6.3.0.0 Data Dependencies

- Requires the Admin's `userId` and `tenantId` to correctly associate the stored token.

## 6.4.0.0 External Dependencies

- Availability and correct functioning of the Google Identity Platform (OAuth 2.0 services).

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The redirection to and from Google's authentication service should complete within 2 seconds on a stable connection.
- The UI state update upon returning to the application must be immediate (<500ms).

## 7.2.0.0 Security

- The OAuth client secret MUST NOT be exposed in the client-side code.
- All communication with the backend function and Google's servers must use HTTPS/TLS.
- Refresh tokens stored in Firestore must be encrypted at rest.
- The application must request the minimum required OAuth scopes (e.g., `https://www.googleapis.com/auth/spreadsheets`, `https://www.googleapis.com/auth/drive.file`) and not ask for overly broad permissions.

## 7.3.0.0 Usability

- The process should feel seamless and trustworthy to the user, leveraging the familiar Google login experience.

## 7.4.0.0 Accessibility

- The UI elements must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The flow must work correctly on all supported web browsers (Chrome, Firefox, Safari, Edge).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires both frontend (Flutter Web) and backend (Cloud Function) development.
- Correctly and securely handling the multi-step OAuth 2.0 Authorization Code Flow.
- Configuration in Google Cloud Console is sensitive and can be difficult to debug.
- Requires robust error handling for various failure points in the external communication.

## 8.3.0.0 Technical Risks

- Misconfiguration of redirect URIs in the Google Cloud Console can block development and testing.
- Improper handling or storage of the refresh token could create a significant security vulnerability.
- Rate limits on Google's APIs could impact functionality under heavy use, though unlikely for this specific flow.

## 8.4.0.0 Integration Points

- Client (Flutter Web) -> Google Identity Platform
- Google Identity Platform -> Client (Flutter Web)
- Client (Flutter Web) -> Backend (Firebase Cloud Function)
- Backend (Firebase Cloud Function) -> Google Identity Platform (for token exchange)
- Backend (Firebase Cloud Function) -> Firestore (for token storage)

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Successful connection and token storage.
- User denies permission on the consent screen.
- User successfully disconnects/revokes access.
- Handling of invalid authorization code sent to the backend.
- UI state correctly reflects connection status at all times.

## 9.3.0.0 Test Data Needs

- A dedicated Google test account for automated and manual testing.
- Test accounts for each user role (Admin) in the application.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local testing of the Cloud Function and Firestore rules.
- Flutter's `integration_test` framework for E2E testing of the web dashboard flow.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team, with special attention to security practices
- Unit tests implemented for the Cloud Function logic with >80% coverage
- Integration testing of the full OAuth flow completed successfully
- User interface reviewed and approved by the product owner
- Security requirements validated, including secure storage of secrets and tokens
- Documentation updated for setting up the OAuth client in new environments
- Story deployed and verified in the staging environment using a test Google account

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a technical enabler and blocker for the automated export feature (US-065). It should be prioritized early in the development of the reporting epic.
- The developer assigned will require permissions in the Google Cloud Project to configure the OAuth 2.0 client.

## 11.4.0.0 Release Impact

- This is a foundational component for the Google Sheets integration, a key feature for paid tiers.

