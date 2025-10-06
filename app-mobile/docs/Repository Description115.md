# 1 Id

REPO-APP-MOBILE-010

# 2 Name

app-mobile

# 3 Description

This repository contains the main Flutter application targeted for iOS and Android mobile devices. It was the primary mobile-facing part of the original 'attendance-app-client'. This repository assembles the various shared client libraries (data access, UI) to build the complete user-facing application for Subordinate and Supervisor roles. It contains all the role-specific screens, feature-level state management (using Riverpod), navigation logic, and device-specific integrations like GPS and push notifications. It is responsible for delivering the core mobile experience: attendance marking, viewing event calendars, and the supervisor approval dashboard. Its focus is purely on presentation and user interaction for the mobile platform.

# 4 Type

🔹 Business Logic

# 5 Namespace

com.attendance-app.client.mobile

# 6 Output Path

apps/mobile

# 7 Framework

Flutter

# 8 Language

Dart

# 9 Technology

Flutter, Riverpod, Firebase SDK

# 10 Thirdparty Libraries

- geolocator
- firebase_messaging

# 11 Layer Ids

- presentation-layer

# 12 Dependencies

- REPO-LIB-CLIENT-008
- REPO-LIB-UI-009

# 13 Requirements

## 13.1 Requirement Id

### 13.1.1 Requirement Id

REQ-1-004

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-1-009

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-FUN-007

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

- REQ-1-004
- REQ-1-009
- REQ-FUN-007

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-CLIENT-001

## 20.3.0 Decomposition Reasoning

Separates the mobile application from the web admin dashboard. Mobile apps have a distinct release lifecycle (App Store reviews), different dependencies (GPS, notifications), and a different user focus (Subordinates/Supervisors). This separation allows for an optimized mobile CI/CD pipeline and a codebase focused solely on the mobile experience.

## 20.4.0 Extracted Responsibilities

- Subordinate user flows (check-in/out).
- Supervisor user flows (approvals).
- Mobile navigation and screen layouts.
- Device hardware integrations (GPS).

## 20.5.0 Reusability Scope

- N/A - This is a final, deployable application.

## 20.6.0 Development Benefits

- Focused development on the mobile user experience.
- Independent release schedule from the web app.
- Simplified dependency management for mobile-only packages.

# 21.0.0 Dependency Contracts

## 21.1.0 Repo-Lib-Client-008

### 21.1.1 Required Interfaces

- {'interface': 'IAttendanceRepository', 'methods': [], 'events': [], 'properties': []}

### 21.1.2 Integration Pattern

Library Import / Dependency Injection

### 21.1.3 Communication Protocol

N/A

# 22.0.0 Exposed Contracts

## 22.1.0 Public Interfaces

*No items available*

# 23.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | Uses Riverpod to provide repository implementation... |
| Event Communication | Subscribes to streams from the data access layer t... |
| Data Flow | UI triggers actions -> State Notifiers call Reposi... |
| Error Handling | Displays user-friendly error messages based on exc... |
| Async Patterns | UI shows loading states while waiting for Futures/... |

# 24.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Follow Clean Architecture principles, keeping UI (... |
| Performance Considerations | Optimize for fast startup and smooth 60fps animati... |
| Security Considerations | Do not store sensitive information on the device. ... |
| Testing Approach | Focus on widget tests and integration tests that m... |

# 25.0.0 Scope Boundaries

## 25.1.0 Must Implement

- All features for Subordinate and Supervisor roles on mobile.

## 25.2.0 Must Not Implement

- Admin dashboard features.
- Direct database queries (must use the data access layer).

## 25.3.0 Extension Points

- New mobile-specific features are added here.

## 25.4.0 Validation Rules

- Perform client-side input validation for a better UX, but do not rely on it for security.

