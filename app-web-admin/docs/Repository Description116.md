# 1 Id

REPO-APP-ADMIN-011

# 2 Name

app-web-admin

# 3 Description

This repository contains the Flutter for Web application that serves as the administrative dashboard. It represents the web-facing part of the original 'attendance-app-client'. This application is exclusively for the 'Admin' user role and provides features for tenant configuration, comprehensive user and team management, viewing detailed reports, and managing the Google Sheets integration. It assembles the shared client libraries (data access, UI) to build a responsive web interface optimized for desktop and tablet viewports. By separating the admin web app, its development and deployment can be iterated on rapidly and independently of the mobile application's release schedule.

# 4 Type

🔹 Business Logic

# 5 Namespace

com.attendance-app.client.admin

# 6 Output Path

apps/web-admin

# 7 Framework

Flutter

# 8 Language

Dart

# 9 Technology

Flutter for Web, Riverpod, Firebase SDK

# 10 Thirdparty Libraries

*No items available*

# 11 Layer Ids

- presentation-layer

# 12 Dependencies

- REPO-LIB-CLIENT-008
- REPO-LIB-UI-009

# 13 Requirements

## 13.1 Requirement Id

### 13.1.1 Requirement Id

REQ-1-018

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-1-061

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-REP-001

# 14.0.0 Generate Tests

✅ Yes

# 15.0.0 Generate Documentation

✅ Yes

# 16.0.0 Architecture Style

Clean Architecture (Presentation Layer)

# 17.0.0 Architecture Map

- cross-platform-client-application-001

# 18.0.0 Components Map

*No items available*

# 19.0.0 Requirements Map

- REQ-1-018
- REQ-1-061
- REQ-REP-001

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-CLIENT-001

## 20.3.0 Decomposition Reasoning

Separates the web-based Admin Dashboard from the mobile application. Web applications have a different deployment model (push to hosting vs. app store submission), different target devices (desktop/tablet), and serve a completely different user role (Admin). This split allows for rapid web deployments and a UX tailored for administrative tasks.

## 20.4.0 Extracted Responsibilities

- Admin-only features.
- User and Team management UIs.
- Reporting dashboards.
- Tenant configuration settings UI.

## 20.5.0 Reusability Scope

- N/A - This is a final, deployable application.

## 20.6.0 Development Benefits

- Enables continuous deployment for the web app.
- UX can be optimized for larger screens.
- Clear ownership for the administrative side of the product.

# 21.0.0 Dependency Contracts

## 21.1.0 Repo-Lib-Client-008

### 21.1.1 Required Interfaces

#### 21.1.1.1 Interface

##### 21.1.1.1.1 Interface

IUserRepository

##### 21.1.1.1.2 Methods

*No items available*

##### 21.1.1.1.3 Events

*No items available*

##### 21.1.1.1.4 Properties

*No items available*

#### 21.1.1.2.0 Interface

##### 21.1.1.2.1 Interface

ITeamRepository

##### 21.1.1.2.2 Methods

*No items available*

##### 21.1.1.2.3 Events

*No items available*

##### 21.1.1.2.4 Properties

*No items available*

### 21.1.2.0.0 Integration Pattern

Library Import / Dependency Injection

### 21.1.3.0.0 Communication Protocol

N/A

# 22.0.0.0.0 Exposed Contracts

## 22.1.0.0.0 Public Interfaces

*No items available*

# 23.0.0.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | Uses Riverpod to provide repository implementation... |
| Event Communication | Subscribes to streams for real-time updates on rep... |
| Data Flow | UI triggers actions -> State Notifiers call Reposi... |
| Error Handling | Displays user-friendly error messages. |
| Async Patterns | Manages loading states for data-heavy reports and ... |

# 24.0.0.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Focus on building a responsive layout that works w... |
| Performance Considerations | Optimize for efficient loading of large datasets f... |
| Security Considerations | Client-side logic should ensure that only users au... |
| Testing Approach | Focus on testing complex data tables, forms, and r... |

# 25.0.0.0.0 Scope Boundaries

## 25.1.0.0.0 Must Implement

- All features for the Admin user role.

## 25.2.0.0.0 Must Not Implement

- Mobile-specific features like GPS attendance marking.
- Supervisor or Subordinate user flows.

## 25.3.0.0.0 Extension Points

- New reports and administrative tools are added here.

## 25.4.0.0.0 Validation Rules

- Extensive client-side validation on all forms for user management and configuration.

