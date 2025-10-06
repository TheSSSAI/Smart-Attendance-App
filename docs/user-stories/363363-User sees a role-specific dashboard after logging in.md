# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-021 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User sees a role-specific dashboard after logging ... |
| As A User Story | As an authenticated user (Admin, Supervisor, or Su... |
| User Persona | Any authenticated user of the system (Admin, Super... |
| Business Value | Improves user efficiency and satisfaction by provi... |
| Functional Area | Authentication and Authorization |
| Story Theme | User Onboarding and Access Control |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Admin successfully logs into the web application

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a registered user exists with the role 'Admin'

### 3.1.5 When

the user successfully authenticates on the web-based login page

### 3.1.6 Then

the system must redirect them to the main Admin Web Dashboard.

### 3.1.7 Validation Notes

Verify the URL changes to the admin dashboard route and the primary admin dashboard UI is rendered.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Supervisor successfully logs into the mobile application

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a registered user exists with the role 'Supervisor'

### 3.2.5 When

the user successfully authenticates on the mobile application

### 3.2.6 Then

the system must navigate them to the Supervisor Mobile Dashboard.

### 3.2.7 Validation Notes

Verify the Supervisor dashboard screen is displayed, showing elements like the list of pending subordinate approvals.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Subordinate successfully logs into the mobile application

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

a registered user exists with the role 'Subordinate'

### 3.3.5 When

the user successfully authenticates on the mobile application

### 3.3.6 Then

the system must navigate them to the Subordinate Mobile Dashboard.

### 3.3.7 Validation Notes

Verify the Subordinate dashboard screen is displayed, showing elements like the 'Check-In' button and their own attendance status.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Non-Admin user attempts to log into the web application

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given

a registered user exists with the role 'Supervisor' or 'Subordinate'

### 3.4.5 When

the user successfully authenticates on the web-based login page

### 3.4.6 Then

the system must display a page informing them that the web dashboard is for administrative access only and they should use the mobile application.

### 3.4.7 Validation Notes

Verify that the user is not redirected to the admin dashboard and that the informational message is clear and user-friendly.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Authenticated user has a missing or invalid role

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

a user has successfully authenticated via Firebase Auth

### 3.5.5 When

the system checks their authorization token and finds the 'role' custom claim is missing, null, or invalid

### 3.5.6 Then

the user must be shown a generic error screen with a message like 'Your account is not configured correctly. Please contact your administrator.' and then be automatically logged out.

### 3.5.7 Validation Notes

This can be tested by manually creating a user in Firebase Auth without setting the custom claim and attempting to log in.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

User sees a loading indicator during redirection

### 3.6.3 Scenario Type

Happy_Path

### 3.6.4 Given

any valid user is on the login screen

### 3.6.5 When

they submit valid credentials and the system is processing the login

### 3.6.6 Then

a clear loading indicator must be displayed until the role-specific dashboard is rendered.

### 3.6.7 Validation Notes

Verify the loading state is visually present and prevents user interaction until the redirection is complete.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Loading indicator/spinner overlay
- Informational page for non-admins on the web platform

## 4.2.0 User Interactions

- User is automatically redirected after login without any required action.
- The transition from login to dashboard should be seamless.

## 4.3.0 Display Requirements

- The error message for a misconfigured account must be clear and provide guidance (e.g., 'contact admin').
- The message for non-admins on the web platform must clearly state why they cannot proceed and direct them to the mobile app.

## 4.4.0 Accessibility Needs

- The loading indicator should be accessible to screen readers, announcing that the page is loading.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A user's role determines their initial landing page after authentication.

### 5.1.3 Enforcement Point

Immediately after successful authentication, before rendering any application UI.

### 5.1.4 Violation Handling

If a role cannot be determined, the user session is terminated (logged out) and an error is displayed.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The web dashboard is exclusively for users with the 'Admin' role.

### 5.2.3 Enforcement Point

During the post-authentication routing logic on the web platform.

### 5.2.4 Violation Handling

Non-Admin users are redirected to an informational page and their access to web dashboard routes is blocked.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-017

#### 6.1.1.2 Dependency Reason

A functional login system must exist before post-login routing can be implemented.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-001

#### 6.1.2.2 Dependency Reason

The tenant and initial Admin user creation process must be complete to test the Admin role path.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-004

#### 6.1.3.2 Dependency Reason

The user invitation flow must be implemented to create Supervisor and Subordinate users for testing.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication service for handling user login.
- Firebase Auth Custom Claims for securely storing and retrieving the user's role.
- A client-side routing solution (e.g., Flutter GoRouter) capable of handling conditional redirection based on application state.

## 6.3.0.0 Data Dependencies

- User records in Firebase Auth must have a 'role' custom claim set to 'Admin', 'Supervisor', or 'Subordinate'.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The time from successful authentication to the role-specific dashboard being interactive should be less than 2 seconds on a stable 4G/WiFi connection.

## 7.2.0.0 Security

- The user's role must be read from the secure Firebase Auth ID token (custom claims) on the client. The client must not determine the role from any other, less secure source.
- Client-side routes for other roles must be protected. A Supervisor should not be able to manually navigate to an Admin-only route.

## 7.3.0.0 Usability

- The post-login transition should feel instantaneous and logical to the user.

## 7.4.0.0 Accessibility

- The application must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The web routing logic must be compatible with the latest stable versions of Chrome, Firefox, Safari, and Edge.
- The mobile routing logic must be compatible with the specified target versions of iOS and Android (iOS 12.0+ and Android 6.0+).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Requires a central authentication state listener at the root of the application widget tree.
- Involves platform-specific logic (web vs. mobile) for redirection.
- Requires careful management of the loading state between authentication and dashboard rendering.

## 8.3.0.0 Technical Risks

- Potential for a race condition if the UI attempts to render before the user's auth token and custom claims are fully loaded. This must be handled with a proper loading state.
- Incorrect implementation of the auth state listener could lead to infinite redirect loops.

## 8.4.0.0 Integration Points

- Firebase Authentication SDK for listening to auth state changes.
- Application's navigation/routing package.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Successful login and redirection for an Admin on the web.
- Successful login and redirection for a Supervisor on mobile.
- Successful login and redirection for a Subordinate on mobile.
- Attempted login by a Supervisor on the web results in the correct informational message.
- Login attempt with a user account missing the 'role' custom claim results in an error and logout.

## 9.3.0.0 Test Data Needs

- Test user accounts for each role: Admin, Supervisor, Subordinate.
- A test user account in Firebase Auth with no 'role' custom claim set.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite to mock authentication.
- Flutter's `flutter_test` and `integration_test` packages.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented for the routing logic with >80% coverage
- E2E integration testing completed successfully for all roles and platforms
- User interface for loading and error states reviewed and approved
- Performance requirement for redirection time is met and verified
- Security requirements for using custom claims are validated via code review
- Documentation for the core auth flow is updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This is a foundational story that unblocks UI development for all role-specific dashboards.
- Requires placeholder/skeleton pages for each dashboard to exist before this can be fully tested.

## 11.4.0.0 Release Impact

Critical path for the initial application release. The app is unusable without this core routing logic.

