# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-APP-MOBILE-010 |
| Extraction Timestamp | 2024-07-28T12:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 99% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-004

#### 1.2.1.2 Requirement Text

The system's mobile application shall allow users to mark their attendance by performing 'check-in' and 'check-out' actions. Each action must capture the user's precise GPS coordinates (latitude and longitude) at the time of the action.

#### 1.2.1.3 Validation Criteria

- Verify that the 'Check-In' button successfully captures and stores the user's current timestamp and GPS coordinates.
- Verify that the 'Check-Out' button successfully captures and stores the user's current timestamp and GPS coordinates.
- Confirm that the application requests and handles location permissions correctly.

#### 1.2.1.4 Implementation Implications

- The application must integrate a device location service (e.g., the 'geolocator' package) to fetch GPS data.
- It must include UI elements for check-in and check-out actions, managed by the user's current attendance state.
- Logic is required to handle OS-level location permission requests and denials, as specified in US-076 and US-077.

#### 1.2.1.5 Extraction Reasoning

This requirement defines the primary function of the mobile application and is directly mapped in the repository's description. The repository's technology stack ('geolocator') confirms its responsibility for implementing this.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-009

#### 1.2.2.2 Requirement Text

The mobile application must support core functions, specifically attendance marking (check-in/check-out), while the user's device is offline. Data captured offline must be stored locally and synced automatically upon restoration of network connectivity. If locally stored data fails to sync to the server after a predefined period (e.g., 24 hours), the user must receive a persistent in-app notification about the sync failure.

#### 1.2.2.3 Validation Criteria

- With the device in airplane mode, verify a user can perform a check-in and check-out.
- Verify that after reconnecting to the network, the offline data is automatically synchronized with the server without user intervention.
- Simulate a persistent sync failure and verify that a clear, non-dismissible notification appears in the app UI after 24 hours.

#### 1.2.2.4 Implementation Implications

- The application must be configured to use the Firebase SDK's offline persistence feature via the data access layer.
- UI must be developed to display 'pending sync' status on local records.
- A client-side service is required to track the age of unsynced records and trigger a persistent UI banner for sync failures, as detailed in US-035.

#### 1.2.2.5 Extraction Reasoning

This requirement is explicitly mapped and defines a critical non-functional aspect of the mobile application's core feature set. The responsibility for handling offline UI and notifications resides in this presentation-layer repository.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-017

#### 1.2.3.2 Requirement Text

The system shall implement a 'Supervisor' role with permissions focused on team management. These permissions must include: 1) Viewing and managing the profiles and attendance records of their direct subordinates only. 2) Creating events and assigning them to their team members. 3) Approving or rejecting attendance records and correction requests submitted by their subordinates. 4) Adding or removing members from the specific teams they are assigned to supervise.

#### 1.2.3.3 Validation Criteria

- Log in as a Supervisor and verify they can only see attendance records for users who report directly to them.
- Verify a Supervisor can create an event and assign it to their team.
- Verify a Supervisor has an interface to approve/reject pending attendance records.

#### 1.2.3.4 Implementation Implications

- The application must include a specific dashboard or set of screens for the Supervisor role.
- A key screen will be the 'Approval Queue' which lists pending attendance and correction records from subordinates.
- The application will contain forms for event creation and team member management.

#### 1.2.3.5 Extraction Reasoning

The repository description explicitly mentions implementing the 'supervisor approval dashboard' and 'Supervisor user flows.' This requirement details the exact features that constitute those flows, making it directly relevant for defining the repository's scope.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-019

#### 1.2.4.2 Requirement Text

The system shall implement a 'Subordinate' role with the most restricted permissions, limited to self-service actions. These permissions must include: 1) Viewing their own user profile and historical attendance data. 2) Marking their own attendance via check-in and check-out. 3) Initiating a correction request for their own attendance records. 4) Viewing a calendar of events that have been assigned to them.

#### 1.2.4.3 Validation Criteria

- Log in as a Subordinate and verify they can view their own attendance history but not that of other users.
- Verify a Subordinate can successfully check-in and check-out.
- Verify a Subordinate can see events assigned to them on a calendar view.

#### 1.2.4.4 Implementation Implications

- The application must include a primary dashboard for the Subordinate role, centered around the check-in/out action.
- Screens for viewing personal attendance history and an event calendar must be implemented.
- A form for initiating an attendance correction request is required.

#### 1.2.4.5 Extraction Reasoning

The repository description explicitly states it is responsible for 'Subordinate user flows' and 'delivering the core mobile experience: attendance marking.' This requirement comprehensively defines the scope of features for the Subordinate role that this repository must build.

### 1.2.5.0 Requirement Id

#### 1.2.5.1 Requirement Id

REQ-1-056

#### 1.2.5.2 Requirement Text

The mobile application must include a calendar view for Subordinates that displays all events they have been assigned to in a read-only format. When a Supervisor creates a new event and assigns it to a user, the system must trigger a Firebase Cloud Messaging (FCM) push notification to be sent to that user's registered device(s) to inform them of the new event.

#### 1.2.5.3 Validation Criteria

- As a Subordinate, navigate to the calendar and verify assigned events are displayed.
- Verify the Subordinate's device receives a push notification about the new event.

#### 1.2.5.4 Implementation Implications

- The mobile application must integrate the 'firebase_messaging' library.
- A client-side service must be implemented to request notification permissions from the user.
- Logic is required to handle incoming notifications when the app is in the foreground, background, or terminated, including navigation logic (deep-linking).

#### 1.2.5.5 Extraction Reasoning

This repository's description lists 'device-specific integrations like... push notifications' as a core responsibility. The requirement for the calendar view and receiving notifications falls squarely within this repository's scope.

## 1.3.0.0 Relevant Components

### 1.3.1.0 Component Name

#### 1.3.1.1 Component Name

Subordinate Dashboard Screen

#### 1.3.1.2 Component Specification

The primary user interface for users with the 'Subordinate' role. It displays the current attendance status, provides the main 'Check-In' and 'Check-Out' actions, and serves as the entry point to other features like history and calendar.

#### 1.3.1.3 Implementation Requirements

- Display current check-in/out status from the data layer.
- Enable/disable Check-In and Check-Out buttons based on the user's current status (US-030).
- Initiate location capture and call the attendance repository upon user action.
- Display a persistent banner for offline sync failures (US-035).

#### 1.3.1.4 Architectural Context

A primary screen (Widget) within the Presentation Layer, managed by a Riverpod StateNotifierProvider.

#### 1.3.1.5 Extraction Reasoning

Synthesized from the repository's description of 'Subordinate user flows' and the detailed requirements in REQ-1-019.

### 1.3.2.0 Component Name

#### 1.3.2.1 Component Name

Supervisor Dashboard Screen

#### 1.3.2.2 Component Specification

The primary user interface for users with the 'Supervisor' role. Its main purpose is to display a real-time list of pending attendance and correction requests from direct subordinates, enabling single and bulk approval/rejection actions.

#### 1.3.2.3 Implementation Requirements

- Subscribe to a stream of pending records from the attendance repository.
- Display records in a list, including subordinate name, date, time, and any exception flags (e.g., 'isOfflineEntry' as per US-038).
- Provide UI controls for approving or rejecting records, triggering calls to the repository.
- Implement multi-select functionality for bulk actions (US-041, US-042).

#### 1.3.2.4 Architectural Context

A primary screen (Widget) within the Presentation Layer, managed by a Riverpod StateNotifierProvider that consumes data streams.

#### 1.3.2.5 Extraction Reasoning

Directly derived from the repository's responsibility to build the 'supervisor approval dashboard' and the feature list in REQ-1-017.

### 1.3.3.0 Component Name

#### 1.3.3.1 Component Name

Event Calendar Screen

#### 1.3.3.2 Component Specification

A screen for both Subordinates and Supervisors to view scheduled events. For Subordinates, it is a read-only calendar. For Supervisors, it includes functionality to create and edit events.

#### 1.3.3.3 Implementation Requirements

- Fetch and display events assigned to the user individually or via their team.
- Provide navigation to view different months/weeks.
- For Supervisors, include a floating action button or similar UI element to initiate the event creation flow (US-052).
- For Subordinates, tapping an event shows read-only details (US-057).

#### 1.3.3.4 Architectural Context

A feature screen within the Presentation Layer, consuming data from the IEventRepository.

#### 1.3.3.5 Extraction Reasoning

This component is explicitly required by REQ-1-007 and REQ-1-056 and is a core part of the mobile experience for both primary roles.

### 1.3.4.0 Component Name

#### 1.3.4.1 Component Name

Notification Handler Service

#### 1.3.4.2 Component Specification

A client-side service responsible for initializing the 'firebase_messaging' library, handling token registration and refresh, and processing incoming push notifications for all application states (foreground, background, terminated).

#### 1.3.4.3 Implementation Requirements

- Request notification permissions from the user on iOS and Android.
- Listen for new FCM tokens and update the user's profile via the data layer.
- Define handlers for displaying foreground notifications.
- Define handlers for user taps on notifications, triggering navigation (deep-linking) to relevant screens (e.g., Event Calendar, Attendance Detail).

#### 1.3.4.4 Architectural Context

A singleton service class within the Presentation Layer, initialized at application startup and provided via Riverpod.

#### 1.3.4.5 Extraction Reasoning

Synthesized based on the repository's explicit dependency on 'firebase_messaging' and requirements for push notifications like REQ-1-056 and US-049.

## 1.4.0.0 Architectural Layers

- {'layer_name': 'Presentation Layer (Flutter Clients)', 'layer_responsibilities': 'Render user interfaces for Mobile (iOS/Android). Manage UI state and user interactions. Handle user authentication flows. Capture user input for attendance, correction requests, etc. Display data such as attendance history, events, and reports. Handle device-specific features like GPS location capture and push notifications (FCM). Implement offline data caching and synchronization UI notifications.', 'layer_constraints': ['Must not contain business logic or direct data access code; this is delegated to the Application and Data layers.', 'UI must be decoupled from state management (e.g., using Riverpod) and data access (using Repository interfaces).', 'Must adhere to platform-specific UI guidelines (Material/Cupertino) as defined in REQ-1-062.'], 'implementation_patterns': ['Clean Architecture', 'MVVM (Model-View-ViewModel) with Riverpod', 'Repository Pattern (as a consumer)', 'Dependency Injection'], 'extraction_reasoning': "The repository is explicitly mapped to this layer. The layer's responsibilities, technology stack, and patterns perfectly match the definition and purpose of the 'app-mobile' repository as a consumer of shared data and UI libraries."}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

Data Access Library

#### 1.5.1.2 Source Repository

REPO-LIB-CLIENT-008

#### 1.5.1.3 Method Contracts

##### 1.5.1.3.1 Method Name

###### 1.5.1.3.1.1 Method Name

IAuthRepository

###### 1.5.1.3.1.2 Method Signature

interface

###### 1.5.1.3.1.3 Method Purpose

Provides methods for user authentication, such as signInWithEmail, signOut, forgotPassword, and a stream of authentication state changes.

###### 1.5.1.3.1.4 Integration Context

Consumed by the application's authentication-related state management (notifiers) to handle all user login, logout, and session management.

##### 1.5.1.3.2.0 Method Name

###### 1.5.1.3.2.1 Method Name

IAttendanceRepository

###### 1.5.1.3.2.2 Method Signature

interface

###### 1.5.1.3.2.3 Method Purpose

Provides a comprehensive API for all attendance-related data operations, including check-in/out, fetching history, watching pending records, and submitting correction requests.

###### 1.5.1.3.2.4 Integration Context

Consumed by the Subordinate and Supervisor dashboard notifiers to perform core attendance actions and display relevant data streams.

##### 1.5.1.3.3.0 Method Name

###### 1.5.1.3.3.1 Method Name

IUserRepository

###### 1.5.1.3.3.2 Method Signature

interface

###### 1.5.1.3.3.3 Method Purpose

Provides methods to fetch user profile data and update non-critical information like the user's FCM token.

###### 1.5.1.3.3.4 Integration Context

Consumed by the Notification Handler Service to keep the user's device token up to date on the backend.

##### 1.5.1.3.4.0 Method Name

###### 1.5.1.3.4.1 Method Name

ITeamRepository

###### 1.5.1.3.4.2 Method Signature

interface

###### 1.5.1.3.4.3 Method Purpose

Provides methods for Supervisors to manage their teams, such as fetching a list of their managed teams and adding/removing members.

###### 1.5.1.3.4.4 Integration Context

Consumed by team management screens available to the Supervisor role.

##### 1.5.1.3.5.0 Method Name

###### 1.5.1.3.5.1 Method Name

IEventRepository

###### 1.5.1.3.5.2 Method Signature

interface

###### 1.5.1.3.5.3 Method Purpose

Provides methods to create, read, and update events, as well as fetch event lists for the calendar view.

###### 1.5.1.3.5.4 Integration Context

Consumed by the Supervisor's event creation forms and the calendar screens for all roles.

#### 1.5.1.4.0.0 Integration Pattern

Library Import & Dependency Injection

#### 1.5.1.5.0.0 Communication Protocol

In-process Dart method calls

#### 1.5.1.6.0.0 Extraction Reasoning

This is the primary dependency as defined in the repository's `sds`. It aligns with the Clean Architecture pattern, where the Presentation Layer (`app-mobile`) depends on abstractions provided by the Data Layer (`client-data-access`). This interface defines the complete data contract required to build all mobile features.

### 1.5.2.0.0.0 Interface Name

#### 1.5.2.1.0.0 Interface Name

Shared UI Component Library

#### 1.5.2.2.0.0 Source Repository

REPO-LIB-UI-009

#### 1.5.2.3.0.0 Method Contracts

##### 1.5.2.3.1.0 Method Name

###### 1.5.2.3.1.1 Method Name

PrimaryButton

###### 1.5.2.3.1.2 Method Signature

Widget

###### 1.5.2.3.1.3 Method Purpose

Provides a consistently styled primary action button used for all major actions like 'Check-In', 'Save', 'Submit'.

###### 1.5.2.3.1.4 Integration Context

Used in all forms and dashboards throughout the application.

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

TextInputField

###### 1.5.2.3.2.2 Method Signature

Widget

###### 1.5.2.3.2.3 Method Purpose

Provides a themed text input field for forms, including variants for passwords and multi-line text.

###### 1.5.2.3.2.4 Integration Context

Used in login forms, event creation, and correction request justification fields.

##### 1.5.2.3.3.0 Method Name

###### 1.5.2.3.3.1 Method Name

AlertBanner

###### 1.5.2.3.3.2 Method Signature

Widget

###### 1.5.2.3.3.3 Method Purpose

Displays a prominent, styled banner for providing contextual feedback (info, success, warning, error), such as the persistent sync failure notification (US-035).

###### 1.5.2.3.3.4 Integration Context

Used globally to display critical application-wide alerts.

##### 1.5.2.3.4.0 Method Name

###### 1.5.2.3.4.1 Method Name

AttendanceListItem

###### 1.5.2.3.4.2 Method Signature

Widget

###### 1.5.2.3.4.3 Method Purpose

Renders a complex list item for an attendance record, adapting its view based on the user's role and displaying status flags (US-038).

###### 1.5.2.3.4.4 Integration Context

Used in the Supervisor's approval queue and the Subordinate's attendance history screen.

#### 1.5.2.4.0.0 Integration Pattern

Library Import & Widget Composition

#### 1.5.2.5.0.0 Communication Protocol

N/A (Compile-time dependency)

#### 1.5.2.6.0.0 Extraction Reasoning

This repository assembles UI screens and is dependent on a shared library of reusable UI widgets to maintain consistency (REQ-1-062) and accelerate development. The dependency is confirmed in the `code_design` specification.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

Push Notification Service

#### 1.5.3.2.0.0 Source Repository

REPO-SVC-TEAM-005, REPO-SVC-ATTENDANCE-004

#### 1.5.3.3.0.0 Method Contracts

- {'method_name': 'FCM Data Message', 'method_signature': '{ type: string, targetId: string, title: string, body: string }', 'method_purpose': "Defines the contract for data payloads sent via FCM. `type` indicates the event (e.g., 'NEW_EVENT_ASSIGNMENT', 'CORRECTION_APPROVED') and `targetId` provides the relevant entity ID for deep-linking.", 'integration_context': 'Received by the `NotificationHandlerService` in the mobile app, which uses the `type` and `targetId` to navigate the user to the correct screen (e.g., the specific event detail or attendance record).'}

#### 1.5.3.4.0.0 Integration Pattern

Event-Driven (Push Notification)

#### 1.5.3.5.0.0 Communication Protocol

Firebase Cloud Messaging (FCM)

#### 1.5.3.6.0.0 Extraction Reasoning

The mobile app is a consumer of push notifications sent from various backend services (e.g., for new events as per REQ-1-056, or correction outcomes as per US-049). This defines the inbound integration contract for those notifications, which was missing from the initial analysis.

## 1.6.0.0.0.0 Exposed Interfaces

*No items available*

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

The application must be built using the Flutter framework and Dart language. State management must be implemented using the Riverpod package.

### 1.7.2.0.0.0 Integration Technologies

- Firebase SDK for Flutter: For authentication, session management, receiving push notifications (FCM), and interacting with the data layer.
- geolocator: For accessing native device GPS services to fulfill REQ-1-004.
- google_maps_flutter: For displaying map visualizations of attendance locations as per REQ-1-014.

### 1.7.3.0.0.0 Performance Constraints

The application must maintain 60fps for all animations and scrolling, and achieve a cold start time of < 3 seconds, as per REQ-1-067. UI must be built to handle real-time data streams and paginated lists without performance degradation.

### 1.7.4.0.0.0 Security Requirements

The application must not store any sensitive data or credentials on the device. It relies on secure tokens provided by the Firebase Auth SDK for session management. All communication with Firebase services is automatically handled by the SDK over a secure TLS channel.

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The repository's dependencies have been fully mapp... |
| Cross Reference Validation | All mappings have been cross-referenced. The requi... |
| Implementation Readiness Assessment | Readiness is High. The repository has a defined fr... |
| Quality Assurance Confirmation | The extraction process was performed systematicall... |

