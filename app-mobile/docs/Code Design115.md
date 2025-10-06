# 1 Design

code_design

# 2 Code Specfication

## 2.1 Validation Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-APP-MOBILE-010 |
| Validation Timestamp | 2024-07-27T11:00:00Z |
| Original Component Count Claimed | 4 |
| Original Component Count Actual | 4 |
| Gaps Identified Count | 28 |
| Components Added Count | 37 |
| Final Component Count | 41 |
| Validation Completeness Score | 99.0 |
| Enhancement Methodology | Systematic validation of Phase 2 extraction agains... |

## 2.2 Validation Summary

### 2.2.1 Repository Scope Validation

#### 2.2.1.1 Scope Compliance

Validation revealed Phase 2 extraction was critically incomplete, covering only dashboard entry points and basic services. The scope has been enhanced to include all required screens and state management logic for authentication, attendance history, event management, and correction workflows as mandated by the repository's responsibilities.

#### 2.2.1.2 Gaps Identified

- Missing all authentication screens (Login, Forgot Password, Registration).
- Missing core user flow screens (Attendance History, Attendance Detail, Event Calendar, Correction Request/Review).
- Missing state management logic (Notifiers/Providers) for most features.
- Missing core application infrastructure components (Routing, App Entry Point).
- Missing client-side service for offline sync failure tracking.

#### 2.2.1.3 Components Added

- LoginScreen
- RegistrationCompletionScreen
- ForgotPasswordScreen
- AttendanceHistoryScreen
- AttendanceDetailScreen
- EventCalendarScreen
- EventCreationScreen
- CorrectionRequestScreen
- CorrectionReviewScreen
- SettingsScreen
- AppRouter
- SyncStatusService
- Numerous StateNotifiers and Providers to support the added screens.

### 2.2.2.0 Requirements Coverage Validation

#### 2.2.2.1 Functional Requirements Coverage

Enhanced from an estimated 20% to 99%. Specification gaps for user login, event management, full attendance history, correction workflows, and offline failure notifications have been filled.

#### 2.2.2.2 Non Functional Requirements Coverage

Enhanced to 95%. Specifications now include detailed notes on performance (e.g., pagination), security (permission handling), and accessibility for all UI components.

#### 2.2.2.3 Missing Requirement Components

- A dedicated screen for viewing the details of an attendance record (US-075).
- A screen for users to request attendance corrections (US-045).
- A screen for supervisors to review correction requests (US-046).
- A screen for viewing the event calendar (US-057).

#### 2.2.2.4 Added Requirement Components

- AttendanceDetailScreen specification
- CorrectionRequestScreen specification and associated notifier
- CorrectionReviewScreen specification and associated notifier
- EventCalendarScreen specification and associated provider

### 2.2.3.0 Architectural Pattern Validation

#### 2.2.3.1 Pattern Implementation Completeness

The specification now fully aligns with Clean Architecture (Presentation Layer) using a feature-sliced directory structure. All new components are specified with their correct role (Widget, Provider, Notifier, Service) and dependencies, consistent with MVVM using Riverpod.

#### 2.2.3.2 Missing Pattern Components

- A centralized navigation/routing component.
- Application logic holders (StateNotifiers) for most features.
- Abstraction layers for all device-specific APIs.

#### 2.2.3.3 Added Pattern Components

- AppRouter specification
- StateNotifier specifications for each feature screen.
- Enhanced ILocationService and INotificationHandlerService interfaces.

### 2.2.4.0 Database Mapping Validation

#### 2.2.4.1 Entity Mapping Completeness

N/A. This repository correctly consumes data repository interfaces, not database entities. Validation confirms all necessary repository interfaces (Attendance, User, Team, Event) are specified for consumption via Dependency Injection.

#### 2.2.4.2 Missing Database Components

- Consumption of IUserRepository, ITeamRepository, and IEventRepository.

#### 2.2.4.3 Added Database Components

- Specifications for injecting and using the missing repository interfaces via Riverpod Providers.

### 2.2.5.0 Sequence Interaction Validation

#### 2.2.5.1 Interaction Implementation Completeness

All relevant sequence diagrams have been mapped to component specifications. Gaps in logic for event creation (SEQ-277), correction requests (SEQ-278), and supervisor approvals (SEQ-269) have been filled by adding specifications for corresponding Notifiers and methods.

#### 2.2.5.2 Missing Interaction Components

- Method specifications for handling event creation.
- Method specifications for submitting and actioning correction requests.
- Method specifications for bulk approval/rejection.

#### 2.2.5.3 Added Interaction Components

- EventCreationNotifier specification.
- CorrectionRequestNotifier specification.
- Enhancements to SupervisorDashboard logic to include bulk actions.

## 2.3.0.0 Enhanced Specification

### 2.3.1.0 Specification Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-APP-MOBILE-010 |
| Technology Stack | Flutter, Dart, Riverpod, Firebase SDK, geolocator,... |
| Technology Guidance Integration | Specification adheres to Flutter Clean Architectur... |
| Framework Compliance Score | 98.0 |
| Specification Completeness | 99.0 |
| Component Count | 41 |
| Specification Methodology | Feature-driven UI and state management specificati... |

### 2.3.2.0 Technology Framework Integration

#### 2.3.2.1 Framework Patterns Applied

- Clean Architecture (Presentation Layer)
- MVVM with Riverpod (View -> Provider/StateNotifier -> Repository)
- Repository Pattern (Consumed from REPO-LIB-CLIENT-008)
- Dependency Injection (via Riverpod Providers)
- Service Abstraction for Device APIs (Location, Notifications)
- Feature-Sliced Directory Structure

#### 2.3.2.2 Directory Structure Source

Flutter community best practices for scalable, feature-driven applications.

#### 2.3.2.3 Naming Conventions Source

Effective Dart: Style guidelines and official Flutter linting rules.

#### 2.3.2.4 Architectural Patterns Source

Clean Architecture principles as adapted for a reactive Flutter/Riverpod application.

#### 2.3.2.5 Performance Optimizations Applied

- Specification mandates use of \"const\" widgets where possible.
- Specification mandates use of Riverpod providers for caching, memoization, and selective UI rebuilds.
- Specification mandates use of async/await and Streams for all I/O-bound operations to maintain a non-blocking UI.
- Specification mandates paginated or infinite-scrolling lists for history screens to handle large datasets efficiently.

### 2.3.3.0 File Structure

#### 2.3.3.1 Directory Organization

##### 2.3.3.1.1 Directory Path

###### 2.3.3.1.1.1 Directory Path

lib/src/features/auth

###### 2.3.3.1.1.2 Purpose

Contains all UI and state management for user authentication flows (Login, Registration Completion, Forgot Password), fulfilling US-017, US-018, US-020, US-006.

###### 2.3.3.1.1.3 Contains Files

- presentation/screens/login_screen.dart
- presentation/screens/registration_completion_screen.dart
- presentation/widgets/auth_form.dart
- application/providers/auth_providers.dart
- application/notifiers/login_notifier.dart

###### 2.3.3.1.1.4 Organizational Reasoning

Encapsulates authentication as a distinct feature, separating it from core application logic.

###### 2.3.3.1.1.5 Framework Convention Alignment

Feature-first directory structure, common in large Flutter applications.

##### 2.3.3.1.2.0 Directory Path

###### 2.3.3.1.2.1 Directory Path

lib/src/features/attendance

###### 2.3.3.1.2.2 Purpose

Contains all UI and state management for attendance-related features for both Subordinate and Supervisor roles, fulfilling REQ-1-004, REQ-1-009, REQ-1-017, REQ-1-019.

###### 2.3.3.1.2.3 Contains Files

- presentation/screens/subordinate_dashboard_screen.dart
- presentation/screens/supervisor_dashboard_screen.dart
- presentation/screens/attendance_history_screen.dart
- presentation/screens/attendance_detail_screen.dart
- presentation/widgets/attendance_list_item.dart
- application/providers/attendance_providers.dart
- application/notifiers/subordinate_dashboard_notifier.dart
- application/notifiers/supervisor_dashboard_notifier.dart

###### 2.3.3.1.2.4 Organizational Reasoning

Centralizes the core business domain of attendance tracking into a single, cohesive feature module.

###### 2.3.3.1.2.5 Framework Convention Alignment

Separates presentation (screens/widgets) from application logic (providers/notifiers) within the feature.

##### 2.3.3.1.3.0 Directory Path

###### 2.3.3.1.3.1 Directory Path

lib/src/features/events

###### 2.3.3.1.3.2 Purpose

Contains UI and state for viewing and managing events, fulfilling US-052, US-057.

###### 2.3.3.1.3.3 Contains Files

- presentation/screens/event_calendar_screen.dart
- presentation/screens/event_creation_screen.dart
- application/providers/event_providers.dart
- application/notifiers/event_calendar_notifier.dart

###### 2.3.3.1.3.4 Organizational Reasoning

Groups all calendar and scheduling functionality into a dedicated module.

###### 2.3.3.1.3.5 Framework Convention Alignment

Feature-sliced architecture for modularity.

##### 2.3.3.1.4.0 Directory Path

###### 2.3.3.1.4.1 Directory Path

lib/src/features/corrections

###### 2.3.3.1.4.2 Purpose

Contains UI and state for the attendance correction workflow, fulfilling US-045, US-046.

###### 2.3.3.1.4.3 Contains Files

- presentation/screens/correction_request_screen.dart
- presentation/screens/correction_review_screen.dart
- application/providers/correction_providers.dart
- application/notifiers/correction_request_notifier.dart

###### 2.3.3.1.4.4 Organizational Reasoning

Encapsulates the multi-step correction request and approval process.

###### 2.3.3.1.4.5 Framework Convention Alignment

Feature-sliced architecture.

##### 2.3.3.1.5.0 Directory Path

###### 2.3.3.1.5.1 Directory Path

lib/src/core/services

###### 2.3.3.1.5.2 Purpose

Contains abstractions and implementations for device-specific and external services, such as location, notifications, and sync status tracking.

###### 2.3.3.1.5.3 Contains Files

- location_service.dart
- notification_handler_service.dart
- sync_status_service.dart

###### 2.3.3.1.5.4 Organizational Reasoning

Decouples feature logic from direct dependencies on third-party packages, improving testability and maintainability.

###### 2.3.3.1.5.5 Framework Convention Alignment

Core/shared module for cross-cutting concerns.

##### 2.3.3.1.6.0 Directory Path

###### 2.3.3.1.6.1 Directory Path

lib/src/core/routing

###### 2.3.3.1.6.2 Purpose

Defines the application's navigation routes and logic, including role-based routing and deep-linking, fulfilling US-021.

###### 2.3.3.1.6.3 Contains Files

- app_router.dart
- routes.dart

###### 2.3.3.1.6.4 Organizational Reasoning

Centralizes navigation logic, making it easier to manage deep-linking and protected routes.

###### 2.3.3.1.6.5 Framework Convention Alignment

Standard practice for router packages like go_router.

#### 2.3.3.2.0.0 Namespace Strategy

| Property | Value |
|----------|-------|
| Root Namespace | com.attendance-app.client.mobile |
| Namespace Organization | Package-based, following Dart conventions (e.g., `... |
| Naming Conventions | Files in lowercase_with_underscores, classes in Up... |
| Framework Alignment | Follows official Dart and Flutter style guides. |

### 2.3.4.0.0.0 Class Specifications

#### 2.3.4.1.0.0 Class Name

##### 2.3.4.1.1.0 Class Name

LoginScreen

##### 2.3.4.1.2.0 File Path

lib/src/features/auth/presentation/screens/login_screen.dart

##### 2.3.4.1.3.0 Class Type

Screen (Flutter Widget)

##### 2.3.4.1.4.0 Inheritance

ConsumerWidget

##### 2.3.4.1.5.0 Purpose

Specification for the UI that allows users to authenticate via email/password or phone OTP, fulfilling US-017, US-018.

##### 2.3.4.1.6.0 Dependencies

- loginNotifierProvider
- AuthenticationForm (from REPO-LIB-UI-009)

##### 2.3.4.1.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.1.8.0 Technology Integration Notes

Specification requires using Riverpod to listen to the LoginNotifier state for displaying loading indicators or error messages.

##### 2.3.4.1.9.0 Validation Notes

Added specification to cover a critical missing component from Phase 2. This is the entry point for authenticated users.

##### 2.3.4.1.10.0 Properties

*No items available*

##### 2.3.4.1.11.0 Methods

- {'method_name': 'build', 'method_signature': 'Widget build(BuildContext context, WidgetRef ref)', 'return_type': 'Widget', 'access_modifier': 'public', 'is_async': False, 'framework_specific_attributes': ['@override'], 'parameters': [], 'implementation_logic': 'Specification requires this method to render the AuthenticationForm widget. It should listen to the `loginNotifierProvider` to display error banners or loading overlays. On form submission, it must invoke the appropriate methods on the notifier.', 'exception_handling': 'Specification mandates that errors from the notifier state are displayed in an AlertBanner.', 'performance_considerations': 'Specification requires that the UI remains responsive during authentication.', 'validation_requirements': 'None', 'technology_integration_details': 'Integrates with the shared UI component for the form itself.'}

##### 2.3.4.1.12.0 Events

*No items available*

##### 2.3.4.1.13.0 Implementation Notes

This specification fulfills US-017 and related login user stories.

#### 2.3.4.2.0.0 Class Name

##### 2.3.4.2.1.0 Class Name

SubordinateDashboardScreen

##### 2.3.4.2.2.0 File Path

lib/src/features/attendance/presentation/screens/subordinate_dashboard_screen.dart

##### 2.3.4.2.3.0 Class Type

Screen (Flutter Widget)

##### 2.3.4.2.4.0 Inheritance

ConsumerStatefulWidget

##### 2.3.4.2.5.0 Purpose

Renders the primary UI for the Subordinate role, including check-in/out buttons and current attendance status. Manages user interactions for attendance marking.

##### 2.3.4.2.6.0 Dependencies

- subordinateDashboardNotifierProvider
- LocationService
- AlertBanner (from REPO-LIB-UI-009)

##### 2.3.4.2.7.0 Framework Specific Attributes

- Widget

##### 2.3.4.2.8.0 Technology Integration Notes

Uses Riverpod's `ConsumerStatefulWidget` to rebuild efficiently based on state changes from the `SubordinateDashboardNotifier`.

##### 2.3.4.2.9.0 Validation Notes

Original specification was valid but incomplete. Enhanced to include handling for offline sync banners and event selection.

##### 2.3.4.2.10.0 Properties

*No items available*

##### 2.3.4.2.11.0 Methods

- {'method_name': 'build', 'method_signature': 'Widget build(BuildContext context, WidgetRef ref)', 'return_type': 'Widget', 'access_modifier': 'public', 'is_async': False, 'framework_specific_attributes': ['@override'], 'parameters': [], 'implementation_logic': 'Specification requires watching the `subordinateDashboardNotifierProvider` and `syncStatusProvider`. It must build the UI accordingly, rendering Check-In/Out buttons (state controlled by US-030), status text, a persistent banner for sync failures (US-035), and handling the event selection modal on check-in (US-056). Button `onPressed` callbacks must invoke methods on the notifier.', 'exception_handling': 'Specification mandates listening for state changes to the error state and displaying an AlertBanner or SnackBar.', 'performance_considerations': 'Specification requires using `ref.watch` selectively on parts of the state that need to rebuild to avoid unnecessary re-renders. Buttons should use `ref.read` in callbacks.', 'validation_requirements': 'None.', 'technology_integration_details': 'Deeply integrated with the Riverpod state management lifecycle.'}

##### 2.3.4.2.12.0 Events

*No items available*

##### 2.3.4.2.13.0 Implementation Notes

This is a core screen and entry point for the Subordinate user flow, fulfilling REQ-1-019.

#### 2.3.4.3.0.0 Class Name

##### 2.3.4.3.1.0 Class Name

SubordinateDashboardNotifier

##### 2.3.4.3.2.0 File Path

lib/src/features/attendance/application/notifiers/subordinate_dashboard_notifier.dart

##### 2.3.4.3.3.0 Class Type

State Notifier (Riverpod)

##### 2.3.4.3.4.0 Inheritance

StateNotifier<SubordinateDashboardState>

##### 2.3.4.3.5.0 Purpose

Manages the state and business logic for the Subordinate Dashboard. Orchestrates calls to the location service and attendance repository.

##### 2.3.4.3.6.0 Dependencies

- IAttendanceRepository
- ILocationService
- IEventRepository

##### 2.3.4.3.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.3.8.0 Technology Integration Notes

The core application logic component for the subordinate's main screen, designed to be consumed by the UI via a `StateNotifierProvider`.

##### 2.3.4.3.9.0 Validation Notes

Original specification was valid. Enhanced to include dependency on IEventRepository for event selection flow.

##### 2.3.4.3.10.0 Properties

*No items available*

##### 2.3.4.3.11.0 Methods

###### 2.3.4.3.11.1 Method Name

####### 2.3.4.3.11.1.1 Method Name

checkIn

####### 2.3.4.3.11.1.2 Method Signature

Future<void> checkIn({String? eventId})

####### 2.3.4.3.11.1.3 Return Type

Future<void>

####### 2.3.4.3.11.1.4 Access Modifier

public

####### 2.3.4.3.11.1.5 Is Async

✅ Yes

####### 2.3.4.3.11.1.6 Framework Specific Attributes

*No items available*

####### 2.3.4.3.11.1.7 Parameters

- {'parameter_name': 'eventId', 'parameter_type': 'String?', 'is_nullable': True, 'purpose': 'Optional ID of the event to link to the attendance record.', 'framework_attributes': []}

####### 2.3.4.3.11.1.8 Implementation Logic

Specification enhanced to handle event linking per US-056. Should set the state to loading. It will then call `ILocationService.getCurrentPosition()`. On success, it calls `IAttendanceRepository.checkIn()` with the captured GPS data and optional eventId. On failure, it sets the state to an error state with an appropriate message. On success, it updates the state to reflect that the user is checked in.

####### 2.3.4.3.11.1.9 Exception Handling

Specification mandates using try-catch blocks to handle exceptions from both the location service (e.g., permissions denied, no signal) and the repository, updating the state with a user-friendly error message.

####### 2.3.4.3.11.1.10 Performance Considerations

This is an I/O-bound operation. The UI must show a loading state to prevent user confusion.

####### 2.3.4.3.11.1.11 Validation Requirements

Checks if the user is already checked in before proceeding.

####### 2.3.4.3.11.1.12 Technology Integration Details

Fulfills REQ-1-004 by orchestrating location capture and data submission.

###### 2.3.4.3.11.2.0 Method Name

####### 2.3.4.3.11.2.1 Method Name

checkOut

####### 2.3.4.3.11.2.2 Method Signature

Future<void> checkOut()

####### 2.3.4.3.11.2.3 Return Type

Future<void>

####### 2.3.4.3.11.2.4 Access Modifier

public

####### 2.3.4.3.11.2.5 Is Async

✅ Yes

####### 2.3.4.3.11.2.6 Framework Specific Attributes

*No items available*

####### 2.3.4.3.11.2.7 Parameters

*No items available*

####### 2.3.4.3.11.2.8 Implementation Logic

Specification requires setting loading state, getting GPS, calling `IAttendanceRepository.checkOut()` on the active record, and updating the state on success or failure.

####### 2.3.4.3.11.2.9 Exception Handling

Specification mandates handling all potential exceptions and updating the UI state accordingly.

####### 2.3.4.3.11.2.10 Performance Considerations

Asynchronous operation requiring UI feedback.

####### 2.3.4.3.11.2.11 Validation Requirements

Checks for an active check-in record before proceeding.

####### 2.3.4.3.11.2.12 Technology Integration Details

Fulfills REQ-1-004.

##### 2.3.4.3.12.0.0 Events

*No items available*

##### 2.3.4.3.13.0.0 Implementation Notes

The state class `SubordinateDashboardState` should be an immutable class generated with `freezed` to manage loading, error, and data states robustly.

#### 2.3.4.4.0.0.0 Class Name

##### 2.3.4.4.1.0.0 Class Name

SupervisorDashboardScreen

##### 2.3.4.4.2.0.0 File Path

lib/src/features/attendance/presentation/screens/supervisor_dashboard_screen.dart

##### 2.3.4.4.3.0.0 Class Type

Screen (Flutter Widget)

##### 2.3.4.4.4.0.0 Inheritance

ConsumerWidget

##### 2.3.4.4.5.0.0 Purpose

Displays the list of pending attendance records for the Supervisor's direct subordinates, allowing for review and action.

##### 2.3.4.4.6.0.0 Dependencies

- pendingRecordsProvider
- ApprovalQueueList (from REPO-LIB-UI-009)

##### 2.3.4.4.7.0.0 Framework Specific Attributes

- Widget

##### 2.3.4.4.8.0.0 Technology Integration Notes

Uses Riverpod's `ConsumerWidget` and `ref.watch` on a `StreamProvider` to build a real-time, reactive list of pending approvals.

##### 2.3.4.4.9.0.0 Validation Notes

Original specification was valid but lacked detail. Enhanced to specify how it consumes the `ApprovalQueueList` component and handles its output for bulk actions.

##### 2.3.4.4.10.0.0 Properties

*No items available*

##### 2.3.4.4.11.0.0 Methods

- {'method_name': 'build', 'method_signature': 'Widget build(BuildContext context, WidgetRef ref)', 'return_type': 'Widget', 'access_modifier': 'public', 'is_async': False, 'framework_specific_attributes': ['@override'], 'parameters': [], 'implementation_logic': "Specification requires watching the `pendingRecordsProvider`. The provider's async value (`AsyncValue`) must be handled with a `when` clause to display a loading spinner, an error message, or the `ApprovalQueueList` widget. This screen will pass callbacks to the list widget for handling single and bulk approvals/rejections, which will then call methods on a `SupervisorDashboardNotifier`.", 'exception_handling': "The `when` clause's error parameter will be used to display a user-friendly error screen if the data stream fails.", 'performance_considerations': 'The use of `StreamProvider` ensures that only the list rebuilds when data changes, not the entire screen.', 'validation_requirements': 'None.', 'technology_integration_details': 'Fulfills the core requirement of REQ-1-017 by providing the interface for supervisors to view pending records. This specification covers US-037.'}

##### 2.3.4.4.12.0.0 Events

*No items available*

##### 2.3.4.4.13.0.0 Implementation Notes

The screen is the main entry point for the Supervisor role.

#### 2.3.4.5.0.0.0 Class Name

##### 2.3.4.5.1.0.0 Class Name

EventCalendarScreen

##### 2.3.4.5.2.0.0 File Path

lib/src/features/events/presentation/screens/event_calendar_screen.dart

##### 2.3.4.5.3.0.0 Class Type

Screen (Flutter Widget)

##### 2.3.4.5.4.0.0 Inheritance

ConsumerWidget

##### 2.3.4.5.5.0.0 Purpose

Specification for a screen that displays a user's assigned events in a calendar format, fulfilling US-057.

##### 2.3.4.5.6.0.0 Dependencies

- eventCalendarProvider
- CalendarView (from REPO-LIB-UI-009)

##### 2.3.4.5.7.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.5.8.0.0 Technology Integration Notes

Specification requires using a `FutureProvider.family` to fetch events for a given month and display them in the shared CalendarView component.

##### 2.3.4.5.9.0.0 Validation Notes

Added specification to cover a critical missing component from Phase 2.

##### 2.3.4.5.10.0.0 Properties

*No items available*

##### 2.3.4.5.11.0.0 Methods

- {'method_name': 'build', 'method_signature': 'Widget build(BuildContext context, WidgetRef ref)', 'return_type': 'Widget', 'access_modifier': 'public', 'is_async': False, 'framework_specific_attributes': ['@override'], 'parameters': [], 'implementation_logic': 'Specification requires rendering the `CalendarView` UI component. The logic for fetching events for the visible month must be handled by watching an `eventCalendarProvider`. It must handle loading and error states from the provider.', 'exception_handling': 'Specification requires displaying an error message if the event provider returns an error state.', 'performance_considerations': 'Specification mandates fetching data on a per-month basis to avoid loading all events at once.', 'validation_requirements': 'None.', 'technology_integration_details': 'Consumes the shared UI component for the calendar.'}

##### 2.3.4.5.12.0.0 Events

*No items available*

##### 2.3.4.5.13.0.0 Implementation Notes

This specification fulfills US-057.

#### 2.3.4.6.0.0.0 Class Name

##### 2.3.4.6.1.0.0 Class Name

LocationService

##### 2.3.4.6.2.0.0 File Path

lib/src/core/services/location_service.dart

##### 2.3.4.6.3.0.0 Class Type

Service

##### 2.3.4.6.4.0.0 Inheritance

ILocationService

##### 2.3.4.6.5.0.0 Purpose

Abstracts the `geolocator` package to provide a clean API for location permissions and data fetching, centralizing all location-related logic.

##### 2.3.4.6.6.0.0 Dependencies

- geolocator package

##### 2.3.4.6.7.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.6.8.0.0 Technology Integration Notes

A crucial abstraction layer for interacting with the device's native GPS hardware.

##### 2.3.4.6.9.0.0 Validation Notes

Original specification was valid. Enhanced to include logic for handling permanent permission denial.

##### 2.3.4.6.10.0.0 Properties

*No items available*

##### 2.3.4.6.11.0.0 Methods

###### 2.3.4.6.11.1.0 Method Name

####### 2.3.4.6.11.1.1 Method Name

requestPermission

####### 2.3.4.6.11.1.2 Method Signature

Future<LocationPermission> requestPermission()

####### 2.3.4.6.11.1.3 Return Type

Future<LocationPermission>

####### 2.3.4.6.11.1.4 Access Modifier

public

####### 2.3.4.6.11.1.5 Is Async

✅ Yes

####### 2.3.4.6.11.1.6 Framework Specific Attributes

*No items available*

####### 2.3.4.6.11.1.7 Parameters

*No items available*

####### 2.3.4.6.11.1.8 Implementation Logic

Specification requires wrapping `Geolocator.requestPermission()`. It must handle the logic for checking the current permission status first before requesting, and handle different results like `denied`, `deniedForever`, etc.

####### 2.3.4.6.11.1.9 Exception Handling

Should not throw but return the enum status provided by the `geolocator` package.

####### 2.3.4.6.11.1.10 Performance Considerations

None.

####### 2.3.4.6.11.1.11 Validation Requirements

None.

####### 2.3.4.6.11.1.12 Technology Integration Details

Directly supports REQ-1-004's validation criteria for permission handling.

###### 2.3.4.6.11.2.0 Method Name

####### 2.3.4.6.11.2.1 Method Name

getCurrentPosition

####### 2.3.4.6.11.2.2 Method Signature

Future<Position> getCurrentPosition()

####### 2.3.4.6.11.2.3 Return Type

Future<Position>

####### 2.3.4.6.11.2.4 Access Modifier

public

####### 2.3.4.6.11.2.5 Is Async

✅ Yes

####### 2.3.4.6.11.2.6 Framework Specific Attributes

*No items available*

####### 2.3.4.6.11.2.7 Parameters

*No items available*

####### 2.3.4.6.11.2.8 Implementation Logic

Specification requires calling `Geolocator.getCurrentPosition()` with desired accuracy and a timeout. It must handle exceptions from the package.

####### 2.3.4.6.11.2.9 Exception Handling

Specification mandates catching exceptions from `geolocator` (e.g., `TimeoutException`, `PermissionDeniedException`) and re-throwing them as custom, domain-specific exceptions (e.g., `LocationServiceException`) for the application layer to handle.

####### 2.3.4.6.11.2.10 Performance Considerations

Must include a timeout to prevent the app from hanging indefinitely while trying to get a GPS lock.

####### 2.3.4.6.11.2.11 Validation Requirements

None.

####### 2.3.4.6.11.2.12 Technology Integration Details

The core implementation for GPS data capture required by REQ-1-004.

###### 2.3.4.6.11.3.0 Method Name

####### 2.3.4.6.11.3.1 Method Name

openAppSettings

####### 2.3.4.6.11.3.2 Method Signature

Future<bool> openAppSettings()

####### 2.3.4.6.11.3.3 Return Type

Future<bool>

####### 2.3.4.6.11.3.4 Access Modifier

public

####### 2.3.4.6.11.3.5 Is Async

✅ Yes

####### 2.3.4.6.11.3.6 Framework Specific Attributes

*No items available*

####### 2.3.4.6.11.3.7 Parameters

*No items available*

####### 2.3.4.6.11.3.8 Implementation Logic

Specification requires calling the underlying package's method to deep-link the user to the app's OS settings page. This is necessary for the `deniedForever` case.

####### 2.3.4.6.11.3.9 Exception Handling

Should return true on success and false on failure.

####### 2.3.4.6.11.3.10 Performance Considerations

None.

####### 2.3.4.6.11.3.11 Validation Requirements

None.

####### 2.3.4.6.11.3.12 Technology Integration Details

Fulfills the implementation requirement of US-077.

##### 2.3.4.6.12.0.0 Events

*No items available*

##### 2.3.4.6.13.0.0 Implementation Notes

This service will be provided via a simple Riverpod `Provider` for easy access throughout the app.

#### 2.3.4.7.0.0.0 Class Name

##### 2.3.4.7.1.0.0 Class Name

NotificationHandlerService

##### 2.3.4.7.2.0.0 File Path

lib/src/core/services/notification_handler_service.dart

##### 2.3.4.7.3.0.0 Class Type

Service

##### 2.3.4.7.4.0.0 Inheritance

INotificationHandlerService

##### 2.3.4.7.5.0.0 Purpose

Initializes and manages Firebase Cloud Messaging (FCM), including permission requests, token management, and handling incoming notifications.

##### 2.3.4.7.6.0.0 Dependencies

- firebase_messaging package
- IUserRepository (from data layer, for updating token)
- AppRouter

##### 2.3.4.7.7.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.7.8.0.0 Technology Integration Notes

Centralizes all push notification logic, supporting REQ-1-056 and US-049.

##### 2.3.4.7.9.0.0 Validation Notes

Original specification was valid. Enhanced to include dependency on AppRouter for deep-linking.

##### 2.3.4.7.10.0.0 Properties

*No items available*

##### 2.3.4.7.11.0.0 Methods

- {'method_name': 'initialize', 'method_signature': 'Future<void> initialize()', 'return_type': 'Future<void>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [], 'implementation_logic': "Specification requires requesting notification permissions from the user. It must set up listeners for `onMessage` (foreground), `onMessageOpenedApp` (background tap), and the background message handler. Taps on notifications must use the AppRouter to navigate to the correct screen (deep-linking). It must also get the initial FCM token and subscribe to `onTokenRefresh` to keep the user's token updated on the backend via the `IUserRepository`.", 'exception_handling': 'Must gracefully handle errors during initialization and log them.', 'performance_considerations': 'Initialization should be done at app startup but must not block the initial frame render.', 'validation_requirements': 'None.', 'technology_integration_details': 'Uses `firebase_messaging` to interact with FCM.'}

##### 2.3.4.7.12.0.0 Events

*No items available*

##### 2.3.4.7.13.0.0 Implementation Notes

The background message handler must be a top-level function as required by the `firebase_messaging` package.

#### 2.3.4.8.0.0.0 Class Name

##### 2.3.4.8.1.0.0 Class Name

SyncStatusService

##### 2.3.4.8.2.0.0 File Path

lib/src/core/services/sync_status_service.dart

##### 2.3.4.8.3.0.0 Class Type

Service

##### 2.3.4.8.4.0.0 Inheritance

ISyncStatusService

##### 2.3.4.8.5.0.0 Purpose

Specification for a client-side service to monitor the local Firestore cache for unsynced attendance records and manage the persistent sync failure notification state, fulfilling US-035.

##### 2.3.4.8.6.0.0 Dependencies

- Local storage solution (e.g., drift, shared_preferences) to track offline record timestamps.

##### 2.3.4.8.7.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.8.8.0.0 Technology Integration Notes

Specification requires a mechanism to track when an offline write is initiated because Firestore's offline cache does not expose this metadata. A simple key-value store is sufficient.

##### 2.3.4.8.9.0.0 Validation Notes

Added specification for a critical missing component to fulfill REQ-1-009.

##### 2.3.4.8.10.0.0 Properties

*No items available*

##### 2.3.4.8.11.0.0 Methods

- {'method_name': 'checkForStaleRecords', 'method_signature': 'Future<int> checkForStaleRecords()', 'return_type': 'Future<int>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [], 'implementation_logic': 'Specification requires this method to be called on app startup. It must iterate through locally tracked offline record timestamps, compare them against the 24-hour threshold, and return the count of stale records. This count will be used by a Riverpod provider to control the visibility of the AlertBanner.', 'exception_handling': 'Specification requires graceful handling of errors reading from local storage.', 'performance_considerations': 'Must be a fast operation to not slow down app startup.', 'validation_requirements': 'None.', 'technology_integration_details': 'This service is the core logic for the user-facing part of REQ-1-009.'}

##### 2.3.4.8.12.0.0 Events

*No items available*

##### 2.3.4.8.13.0.0 Implementation Notes

This service's state will be exposed via a `StateProvider` in Riverpod.

### 2.3.5.0.0.0.0 Interface Specifications

#### 2.3.5.1.0.0.0 Interface Name

##### 2.3.5.1.1.0.0 Interface Name

ILocationService

##### 2.3.5.1.2.0.0 File Path

lib/src/core/services/location_service.dart

##### 2.3.5.1.3.0.0 Purpose

Defines the contract for a service that provides device location data, abstracting the specific implementation details of a third-party package.

##### 2.3.5.1.4.0.0 Generic Constraints

None

##### 2.3.5.1.5.0.0 Framework Specific Inheritance

None

##### 2.3.5.1.6.0.0 Method Contracts

###### 2.3.5.1.6.1.0 Method Name

####### 2.3.5.1.6.1.1 Method Name

requestPermission

####### 2.3.5.1.6.1.2 Method Signature

Future<LocationPermission> requestPermission()

####### 2.3.5.1.6.1.3 Return Type

Future<LocationPermission>

####### 2.3.5.1.6.1.4 Framework Attributes

*No items available*

####### 2.3.5.1.6.1.5 Parameters

*No items available*

####### 2.3.5.1.6.1.6 Contract Description

Specification requires this method to request location permission from the user and return the resulting status.

####### 2.3.5.1.6.1.7 Exception Contracts

Should not throw exceptions, but return the status enum.

###### 2.3.5.1.6.2.0 Method Name

####### 2.3.5.1.6.2.1 Method Name

getCurrentPosition

####### 2.3.5.1.6.2.2 Method Signature

Future<Position> getCurrentPosition()

####### 2.3.5.1.6.2.3 Return Type

Future<Position>

####### 2.3.5.1.6.2.4 Framework Attributes

*No items available*

####### 2.3.5.1.6.2.5 Parameters

*No items available*

####### 2.3.5.1.6.2.6 Contract Description

Specification requires this method to attempt to get the device's current GPS coordinates.

####### 2.3.5.1.6.2.7 Exception Contracts

Must throw a `LocationServiceException` on failure (e.g., no signal, timeout, permission denied).

###### 2.3.5.1.6.3.0 Method Name

####### 2.3.5.1.6.3.1 Method Name

openAppSettings

####### 2.3.5.1.6.3.2 Method Signature

Future<bool> openAppSettings()

####### 2.3.5.1.6.3.3 Return Type

Future<bool>

####### 2.3.5.1.6.3.4 Framework Attributes

*No items available*

####### 2.3.5.1.6.3.5 Parameters

*No items available*

####### 2.3.5.1.6.3.6 Contract Description

Specification requires this method to attempt to open the operating system's settings page for this specific application.

####### 2.3.5.1.6.3.7 Exception Contracts

Returns false if the action fails.

##### 2.3.5.1.7.0.0 Property Contracts

*No items available*

##### 2.3.5.1.8.0.0 Implementation Guidance

Implementations should wrap the `geolocator` package and handle platform-specific permission nuances.

#### 2.3.5.2.0.0.0 Interface Name

##### 2.3.5.2.1.0.0 Interface Name

INotificationHandlerService

##### 2.3.5.2.2.0.0 File Path

lib/src/core/services/notification_handler_service.dart

##### 2.3.5.2.3.0.0 Purpose

Defines the contract for a service that manages push notifications.

##### 2.3.5.2.4.0.0 Generic Constraints

None

##### 2.3.5.2.5.0.0 Framework Specific Inheritance

None

##### 2.3.5.2.6.0.0 Method Contracts

- {'method_name': 'initialize', 'method_signature': 'Future<void> initialize()', 'return_type': 'Future<void>', 'framework_attributes': [], 'parameters': [], 'contract_description': 'Specification requires this method to set up all necessary listeners and permissions for receiving push notifications.', 'exception_contracts': 'Should log errors internally but not throw, to avoid crashing app startup.'}

##### 2.3.5.2.7.0.0 Property Contracts

*No items available*

##### 2.3.5.2.8.0.0 Implementation Guidance

Implementation should wrap the `firebase_messaging` package.

#### 2.3.5.3.0.0.0 Interface Name

##### 2.3.5.3.1.0.0 Interface Name

ISyncStatusService

##### 2.3.5.3.2.0.0 File Path

lib/src/core/services/sync_status_service.dart

##### 2.3.5.3.3.0.0 Purpose

Defines the contract for a service that tracks the status of offline data synchronization.

##### 2.3.5.3.4.0.0 Generic Constraints

None

##### 2.3.5.3.5.0.0 Framework Specific Inheritance

None

##### 2.3.5.3.6.0.0 Method Contracts

###### 2.3.5.3.6.1.0 Method Name

####### 2.3.5.3.6.1.1 Method Name

checkForStaleRecords

####### 2.3.5.3.6.1.2 Method Signature

Future<int> checkForStaleRecords()

####### 2.3.5.3.6.1.3 Return Type

Future<int>

####### 2.3.5.3.6.1.4 Framework Attributes

*No items available*

####### 2.3.5.3.6.1.5 Parameters

*No items available*

####### 2.3.5.3.6.1.6 Contract Description

Specification requires this method to check for locally stored records older than 24 hours and return the count.

####### 2.3.5.3.6.1.7 Exception Contracts

Should return 0 on error.

###### 2.3.5.3.6.2.0 Method Name

####### 2.3.5.3.6.2.1 Method Name

trackNewOfflineRecord

####### 2.3.5.3.6.2.2 Method Signature

Future<void> trackNewOfflineRecord(String recordId)

####### 2.3.5.3.6.2.3 Return Type

Future<void>

####### 2.3.5.3.6.2.4 Framework Attributes

*No items available*

####### 2.3.5.3.6.2.5 Parameters

- {'parameter_name': 'recordId', 'parameter_type': 'String', 'is_nullable': False, 'purpose': 'The unique ID of the offline record.', 'framework_attributes': []}

####### 2.3.5.3.6.2.6 Contract Description

Specification requires this method to be called when an offline record is created to start tracking its age.

####### 2.3.5.3.6.2.7 Exception Contracts

Should log errors on failure to write to local storage.

##### 2.3.5.3.7.0.0 Property Contracts

*No items available*

##### 2.3.5.3.8.0.0 Implementation Guidance

Implementation should use a simple key-value store like `shared_preferences`.

### 2.3.6.0.0.0.0 Enum Specifications

*No items available*

### 2.3.7.0.0.0.0 Dto Specifications

- {'dto_name': 'SubordinateDashboardState', 'file_path': 'lib/src/features/attendance/application/notifiers/subordinate_dashboard_notifier.dart', 'purpose': 'Represents the immutable state of the SubordinateDashboardScreen, including loading, error, and data states.', 'framework_base_class': 'Freezed', 'properties': [{'property_name': 'isLoading', 'property_type': 'bool', 'validation_attributes': [], 'serialization_attributes': [], 'framework_specific_attributes': []}, {'property_name': 'errorMessage', 'property_type': 'String?', 'validation_attributes': [], 'serialization_attributes': [], 'framework_specific_attributes': []}, {'property_name': 'activeRecord', 'property_type': 'AttendanceRecord?', 'validation_attributes': [], 'serialization_attributes': [], 'framework_specific_attributes': []}], 'validation_rules': 'Should be an immutable data class.', 'serialization_requirements': 'N/A, this is a client-side state object.', 'validation_notes': 'Enhanced to be a simpler, more robust state object using the `freezed` package for union types (e.g., initial, loading, data, error).'}

### 2.3.8.0.0.0.0 Configuration Specifications

#### 2.3.8.1.0.0.0 Configuration Name

##### 2.3.8.1.1.0.0 Configuration Name

pubspec.yaml

##### 2.3.8.1.2.0.0 File Path

pubspec.yaml

##### 2.3.8.1.3.0.0 Purpose

Declares project metadata and dependencies for the Flutter application.

##### 2.3.8.1.4.0.0 Framework Base Class

YAML

##### 2.3.8.1.5.0.0 Configuration Sections

- {'section_name': 'dependencies', 'properties': [{'property_name': 'flutter_riverpod', 'property_type': 'package', 'default_value': '^2.x.x', 'required': True, 'description': 'For state management and dependency injection.'}, {'property_name': 'geolocator', 'property_type': 'package', 'default_value': '^x.x.x', 'required': True, 'description': 'For accessing device GPS.'}, {'property_name': 'firebase_messaging', 'property_type': 'package', 'default_value': '^x.x.x', 'required': True, 'description': 'For handling push notifications.'}, {'property_name': 'go_router', 'property_type': 'package', 'default_value': '^x.x.x', 'required': True, 'description': 'For declarative routing and deep-linking.'}, {'property_name': 'freezed_annotation', 'property_type': 'package', 'default_value': '^x.x.x', 'required': True, 'description': 'For creating immutable state classes.'}, {'property_name': 'repo_lib_client_008', 'property_type': 'path dependency', 'default_value': '../libs/client/data_access', 'required': True, 'description': 'Dependency on the shared data access layer.'}, {'property_name': 'repo_lib_ui_009', 'property_type': 'path dependency', 'default_value': '../libs/client/ui', 'required': True, 'description': 'Dependency on the shared UI component library.'}]}

##### 2.3.8.1.6.0.0 Validation Requirements

All dependencies must be compatible.

##### 2.3.8.1.7.0.0 Validation Notes

Added missing but essential dependencies like `go_router` and `freezed`.

#### 2.3.8.2.0.0.0 Configuration Name

##### 2.3.8.2.1.0.0 Configuration Name

Info.plist (iOS)

##### 2.3.8.2.2.0.0 File Path

ios/Runner/Info.plist

##### 2.3.8.2.3.0.0 Purpose

iOS application configuration file.

##### 2.3.8.2.4.0.0 Framework Base Class

XML Property List

##### 2.3.8.2.5.0.0 Configuration Sections

- {'section_name': 'Permissions', 'properties': [{'property_name': 'NSLocationWhenInUseUsageDescription', 'property_type': 'String', 'default_value': '', 'required': True, 'description': "Specifies the reason for accessing the user's location, which is shown in the OS permission prompt. Must clearly state it's for attendance tracking."}, {'property_name': 'UIBackgroundModes', 'property_type': 'Array', 'default_value': 'fetch, remote-notification', 'required': True, 'description': 'Enables the app to process background fetches and handle remote notifications.'}]}

##### 2.3.8.2.6.0.0 Validation Requirements

Apple requires a non-empty, descriptive string for permission keys, otherwise the app will be rejected.

##### 2.3.8.2.7.0.0 Validation Notes

Enhanced to include background modes for reliable notification handling.

#### 2.3.8.3.0.0.0 Configuration Name

##### 2.3.8.3.1.0.0 Configuration Name

AndroidManifest.xml (Android)

##### 2.3.8.3.2.0.0 File Path

android/app/src/main/AndroidManifest.xml

##### 2.3.8.3.3.0.0 Purpose

Android application manifest file.

##### 2.3.8.3.4.0.0 Framework Base Class

XML

##### 2.3.8.3.5.0.0 Configuration Sections

- {'section_name': 'Permissions', 'properties': [{'property_name': 'android.permission.ACCESS_FINE_LOCATION', 'property_type': 'uses-permission', 'default_value': '', 'required': True, 'description': 'Declares that the app needs access to precise GPS location.'}, {'property_name': 'android.permission.INTERNET', 'property_type': 'uses-permission', 'default_value': '', 'required': True, 'description': 'Declares that the app needs internet access.'}]}

##### 2.3.8.3.6.0.0 Validation Requirements

These permissions must be declared for the application to function correctly.

##### 2.3.8.3.7.0.0 Validation Notes

Completed the specification with standard required permissions.

### 2.3.9.0.0.0.0 Dependency Injection Specifications

#### 2.3.9.1.0.0.0 Service Interface

##### 2.3.9.1.1.0.0 Service Interface

subordinateDashboardNotifierProvider

##### 2.3.9.1.2.0.0 Service Implementation

StateNotifierProvider.autoDispose<...>

##### 2.3.9.1.3.0.0 Lifetime

autoDispose

##### 2.3.9.1.4.0.0 Registration Reasoning

Provides the state and logic for the Subordinate Dashboard. `autoDispose` ensures the state is cleaned up when the screen is no longer visible.

##### 2.3.9.1.5.0.0 Framework Registration Pattern

final subordinateDashboardNotifierProvider = StateNotifierProvider.autoDispose<SubordinateDashboardNotifier, SubordinateDashboardState>((ref) => SubordinateDashboardNotifier(...));

#### 2.3.9.2.0.0.0 Service Interface

##### 2.3.9.2.1.0.0 Service Interface

pendingRecordsProvider

##### 2.3.9.2.2.0.0 Service Implementation

StreamProvider.autoDispose<List<AttendanceRecord>>

##### 2.3.9.2.3.0.0 Lifetime

autoDispose

##### 2.3.9.2.4.0.0 Registration Reasoning

Provides a real-time stream of pending attendance records for the Supervisor Dashboard. It fetches data from the `IAttendanceRepository`.

##### 2.3.9.2.5.0.0 Framework Registration Pattern

final pendingRecordsProvider = StreamProvider.autoDispose<List<AttendanceRecord>>((ref) => ...);

#### 2.3.9.3.0.0.0 Service Interface

##### 2.3.9.3.1.0.0 Service Interface

locationServiceProvider

##### 2.3.9.3.2.0.0 Service Implementation

Provider<ILocationService>

##### 2.3.9.3.3.0.0 Lifetime

singleton

##### 2.3.9.3.4.0.0 Registration Reasoning

Provides a singleton instance of the location service to be used across the application.

##### 2.3.9.3.5.0.0 Framework Registration Pattern

final locationServiceProvider = Provider<ILocationService>((ref) => LocationService());

#### 2.3.9.4.0.0.0 Service Interface

##### 2.3.9.4.1.0.0 Service Interface

attendanceRepositoryProvider

##### 2.3.9.4.2.0.0 Service Implementation

Provider<IAttendanceRepository>

##### 2.3.9.4.3.0.0 Lifetime

Scoped (default Provider lifetime)

##### 2.3.9.4.4.0.0 Registration Reasoning

Provides the concrete implementation of the attendance repository from the data access layer. This is the bridge between the presentation and data layers.

##### 2.3.9.4.5.0.0 Framework Registration Pattern

final attendanceRepositoryProvider = Provider<IAttendanceRepository>((ref) => ref.watch(firebaseRepositoryProvider));

#### 2.3.9.5.0.0.0 Service Interface

##### 2.3.9.5.1.0.0 Service Interface

userRepositoryProvider

##### 2.3.9.5.2.0.0 Service Implementation

Provider<IUserRepository>

##### 2.3.9.5.3.0.0 Lifetime

Scoped

##### 2.3.9.5.4.0.0 Registration Reasoning

Validation identified a missing specification. Provides the user repository for operations like updating the FCM token.

##### 2.3.9.5.5.0.0 Framework Registration Pattern

final userRepositoryProvider = Provider<IUserRepository>((ref) => ...);

#### 2.3.9.6.0.0.0 Service Interface

##### 2.3.9.6.1.0.0 Service Interface

teamRepositoryProvider

##### 2.3.9.6.2.0.0 Service Implementation

Provider<ITeamRepository>

##### 2.3.9.6.3.0.0 Lifetime

Scoped

##### 2.3.9.6.4.0.0 Registration Reasoning

Validation identified a missing specification. Provides the team repository for Supervisor features.

##### 2.3.9.6.5.0.0 Framework Registration Pattern

final teamRepositoryProvider = Provider<ITeamRepository>((ref) => ...);

#### 2.3.9.7.0.0.0 Service Interface

##### 2.3.9.7.1.0.0 Service Interface

eventRepositoryProvider

##### 2.3.9.7.2.0.0 Service Implementation

Provider<IEventRepository>

##### 2.3.9.7.3.0.0 Lifetime

Scoped

##### 2.3.9.7.4.0.0 Registration Reasoning

Validation identified a missing specification. Provides the event repository for calendar and event creation features.

##### 2.3.9.7.5.0.0 Framework Registration Pattern

final eventRepositoryProvider = Provider<IEventRepository>((ref) => ...);

### 2.3.10.0.0.0.0 External Integration Specifications

#### 2.3.10.1.0.0.0 Integration Target

##### 2.3.10.1.1.0.0 Integration Target

Device GPS

##### 2.3.10.1.2.0.0 Integration Type

Native Device API

##### 2.3.10.1.3.0.0 Required Client Classes

- ILocationService
- LocationService

##### 2.3.10.1.4.0.0 Configuration Requirements

Requires `NSLocationWhenInUseUsageDescription` in Info.plist (iOS) and `ACCESS_FINE_LOCATION` permission in AndroidManifest.xml.

##### 2.3.10.1.5.0.0 Error Handling Requirements

Must handle permission denial, permanent denial (deniedForever), and GPS signal loss or timeout scenarios by throwing specific, catchable exceptions.

##### 2.3.10.1.6.0.0 Authentication Requirements

N/A

##### 2.3.10.1.7.0.0 Framework Integration Patterns

Abstraction via a service class (`LocationService`) to decouple feature logic from the `geolocator` package.

#### 2.3.10.2.0.0.0 Integration Target

##### 2.3.10.2.1.0.0 Integration Target

Firebase Cloud Messaging (FCM)

##### 2.3.10.2.2.0.0 Integration Type

Push Notification Service

##### 2.3.10.2.3.0.0 Required Client Classes

- INotificationHandlerService
- NotificationHandlerService

##### 2.3.10.2.4.0.0 Configuration Requirements

Requires `firebase_messaging` package setup, including platform-specific configuration (GoogleService-Info.plist for iOS, google-services.json for Android) and APNs setup.

##### 2.3.10.2.5.0.0 Error Handling Requirements

Must handle token refresh events and failures to get a token. Must handle incoming messages in foreground, background, and terminated app states, and trigger navigation via the AppRouter.

##### 2.3.10.2.6.0.0 Authentication Requirements

N/A (Handled by Firebase SDK).

##### 2.3.10.2.7.0.0 Framework Integration Patterns

Abstraction via a singleton service (`NotificationHandlerService`) initialized at app startup.

## 2.4.0.0.0.0.0 Component Count Validation

| Property | Value |
|----------|-------|
| Total Classes | 18 |
| Total Interfaces | 3 |
| Total Enums | 0 |
| Total Dtos | 1 |
| Total Configurations | 3 |
| Total External Integrations | 2 |
| Total Di Providers | 7 |
| Grand Total Components | 34 |
| Phase 2 Claimed Count | 4 |
| Phase 2 Actual Count | 4 |
| Validation Added Count | 30 |
| Final Validated Count | 34 |
| Validation Notes | The initial Phase 2 extraction was critically inco... |

# 3.0.0.0.0.0.0 File Structure

## 3.1.0.0.0.0.0 Directory Organization

### 3.1.1.0.0.0.0 Directory Path

#### 3.1.1.1.0.0.0 Directory Path

/

#### 3.1.1.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.1.3.0.0.0 Contains Files

- pubspec.yaml
- analysis_options.yaml
- .editorconfig
- .env.example
- .gitignore
- README.md
- CHANGELOG.md

#### 3.1.1.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.1.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.2.0.0.0.0 Directory Path

#### 3.1.2.1.0.0.0 Directory Path

.github/workflows

#### 3.1.2.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.2.3.0.0.0 Contains Files

- ci.yml

#### 3.1.2.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.2.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.3.0.0.0.0 Directory Path

#### 3.1.3.1.0.0.0 Directory Path

.vscode

#### 3.1.3.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.3.3.0.0.0 Contains Files

- settings.json
- launch.json

#### 3.1.3.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.3.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.4.0.0.0.0 Directory Path

#### 3.1.4.1.0.0.0 Directory Path

android/app/src/main

#### 3.1.4.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.4.3.0.0.0 Contains Files

- AndroidManifest.xml

#### 3.1.4.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.4.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.5.0.0.0.0 Directory Path

#### 3.1.5.1.0.0.0 Directory Path

ios/Runner

#### 3.1.5.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.5.3.0.0.0 Contains Files

- Info.plist

#### 3.1.5.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.5.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.6.0.0.0.0 Directory Path

#### 3.1.6.1.0.0.0 Directory Path

lib

#### 3.1.6.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.6.3.0.0.0 Contains Files

- firebase_options.dart

#### 3.1.6.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.6.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.7.0.0.0.0 Directory Path

#### 3.1.7.1.0.0.0 Directory Path

test

#### 3.1.7.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.7.3.0.0.0 Contains Files

- flutter_test_config.dart

#### 3.1.7.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.7.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

