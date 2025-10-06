### **Software Requirements Specification**

#### **1. Introduction**

##### **1.1 Project Scope (REQ-SCP-001)**
*   The system shall be developed as a cross-platform mobile attendance application with a free tier for small teams and optional paid tiers for larger organizations or advanced features.
*   The system shall be designed for organizations with a hierarchical structure.
*   The system shall implement a multi-tenant architecture where each organization is an isolated tenant.
*   The system shall provide Role-based access control (RBAC) for Admin, Supervisor, and Subordinate user roles.
*   The system shall provide GPS-based attendance marking for check-in and check-out.
*   The system shall include a supervisor approval workflow for attendance records.
*   The system shall include an auditable workflow for attendance corrections.
*   The system shall allow for calendar-based event creation and assignment to individuals and teams.
*   The system shall provide an automated data export feature to Google Sheets for reporting.
*   The system shall provide offline capabilities for core functions.
*   The system shall provide sync-failure notifications for offline data.
*   The system shall include a web-based dashboard for administrative functions.
*   The system shall explicitly exclude payroll processing or integration.
*   The system shall explicitly exclude advanced HR management features beyond user and team management.
*   The system shall explicitly exclude direct integration with third-party systems other than Google Services (Maps, Sheets, Drive) and the SendGrid transactional email provider.
*   The system shall be exclusively cloud-based on Firebase/GCP and shall not support on-premise deployment.

#### **2. Overall Description**

##### **2.1 Product Perspective (REQ-ARC-001)**
*   The system shall be a self-contained, serverless system built on the Google Firebase platform.
*   The system shall consist of a cross-platform mobile client developed using Flutter for all user roles.
*   The system shall leverage Firebase services for backend functionality, including authentication, database, and notifications.
*   The system shall handle server-side logic for reporting and integrations using Firebase Cloud Functions.
*   The system shall interface with the external Google Maps API for mapping functionality.
*   The system shall interface with the external Google Sheets API for data export functionality.

##### **2.2 User Classes and Characteristics (REQ-USR-001)**
*   The system shall define an 'Admin' user role with full access to their tenant's data.
    *   The Admin role shall have permissions to create, invite, and deactivate all users within their tenant.
    *   The Admin role shall have permissions to create, update, and delete teams.
    *   The Admin role shall have permissions to define organizational policies and settings via the Admin dashboard.
    *   The Admin role shall have permissions to view all reports.
    *   The Admin role shall have permissions to manage Google Sheets integration.
    *   The Admin role shall have permissions to perform direct data edits, which shall be audited. Direct edits bypass the standard correction workflow but require mandatory justification.
    *   The Admin role shall have permissions to initiate the tenant offboarding and data deletion process.
*   The system shall define a 'Supervisor' user role for managing a team of subordinates.
    *   The Supervisor role shall have permissions to view and manage the profiles and attendance records of their direct subordinates.
    *   The Supervisor role shall have permissions to create and assign events to their team members.
    *   The Supervisor role shall have permissions to approve or reject attendance and correction requests from their subordinates.
    *   The Supervisor role shall have permissions to manage the membership of teams they supervise.
    *   A user with the Supervisor role may also be a Subordinate to another Supervisor, enabling multi-level hierarchies.
*   The system shall define a 'Subordinate' user role as the primary end-user.
    *   The Subordinate role shall only have permissions to access their own profile and attendance data.
    *   The Subordinate role shall have permissions to mark their own attendance.
    *   The Subordinate role shall have permissions to request corrections to their own attendance records.
    *   The Subordinate role shall have permissions to view events assigned to them.

##### **2.3 Operating Environment (REQ-DEP-001)**
*   The system shall utilize a dedicated Firebase project for development and testing.
*   The system shall utilize a separate Firebase project for Staging/UAT.
*   The system shall utilize a dedicated Firebase project for the live Production environment.
*   The mobile application shall run on Android or iOS smartphones with GPS capabilities.
*   The mobile client shall support Android 6.0 (Marshmallow) or later.
*   The mobile client shall support iOS 12.0 or later.
*   The web dashboard shall be accessible on the latest stable versions of modern web browsers, including Chrome, Firefox, Safari, and Edge.

##### **2.4 Design and Implementation Constraints (REQ-CON-001)**
*   The system shall be built using Flutter for the mobile client.
*   The system shall use the Firebase suite (Authentication, Firestore, Cloud Functions) for the backend.
*   The application shall be free for end-users, with tenant organizations subject to subscription tiers based on usage and features.
*   The system architecture shall be designed to minimize costs by leveraging the free tiers of Firebase/GCP where possible.
*   The system architecture shall be tightly coupled with the Firebase/GCP ecosystem.
*   The application shall have a clear Privacy Policy and Terms of Service regarding the collection and use of location data, designed to comply with target data privacy regulations such as GDPR. User acceptance of these policies shall be a mandatory prerequisite for account activation.
*   All tenant data shall be stored within a specified GCP region to comply with data residency requirements, configurable at the tenant's subscription level.
*   Data segregation between tenants shall be strictly enforced at the database level using Firestore Security Rules based on the user's `tenantId` custom claim.

##### **2.5 Assumptions and Dependencies (REQ-DEP-002)**
*   The system shall assume users have smartphones with reliable GPS functionality.
*   The system shall rely on Firestore's offline persistence for its offline requirements.
*   The system shall be dependent on the availability and terms of service of the Google Maps API.
*   The system shall be dependent on the availability and terms of service of the Google Sheets API.
*   The system shall be dependent on the availability and terms of service of the core Firebase platform.
*   The system deployment shall be dependent on Google Play Store and Apple App Store policies.

##### **2.6 Business Rules and Constraints**
*   **2.6.1 Domain-Specific Logic**
    *   A user cannot be their own supervisor, directly or indirectly in a reporting chain. The system shall prevent the creation of such circular reporting structures.
    *   A check-in and its corresponding check-out must occur on the same calendar day, as defined by the tenant's configured timezone. A new day requires a new check-in.
    *   The `auditLog` collection shall be immutable. Records written to this collection cannot be updated or deleted by any user role, including Admin, via application logic or security rules.
    *   If a Supervisor is deactivated, the system shall require an Admin to reassign all of their direct subordinates to a new Supervisor before the deactivation can be finalized.
*   **2.6.2 Regulatory and Legal Constraints**
    *   The system shall implement user consent flows for data collection in compliance with GDPR.
    *   The system shall provide a Data Processing Addendum (DPA) for all enterprise customers to formalize data handling responsibilities and compliance.
    *   All user-facing communication, including invitation emails and password reset instructions, shall comply with anti-spam legislation.
*   **2.6.3 Organizational Policies**
    *   All direct data edits performed by an Admin must include a justification of at least 20 characters, which is stored in the audit log.
    *   The password policy for all users shall require a minimum of 8 characters, including at least one uppercase letter, one lowercase letter, one number, and one special character. This policy shall be enforced during registration and password reset.

#### **3. System Features (Functional Requirements)**

##### **3.1 Tenant and User Management**
*   **3.1.1 Tenant Creation (REQ-FUN-001)**
    *   The system shall allow an initial Admin user to register their organization, which shall create a new, isolated tenant instance.
    *   The system shall validate that the chosen organization name is globally unique before creating the tenant.
    *   During registration, the system shall capture the tenant's desired primary data residency region from a list of supported GCP regions.
    *   Upon Admin registration with a unique organization name and credentials, the system shall create a new tenant document in Firestore under `/tenants/{tenantId}`.
    *   Upon Admin registration, the system shall create a new user document for the Admin with the 'Admin' role.
    *   Upon Admin registration, the system shall set custom claims (`tenantId`, `role: 'Admin'`) on the user's Firebase Auth token.
    *   Upon successful registration, the system shall log the user in and redirect them to the Admin dashboard.
*   **3.1.2 Tenant Offboarding**
    *   The system shall provide a mechanism in the Admin dashboard for an Admin to request the permanent deletion of their organization's tenant and all associated data.
    *   This action shall require explicit confirmation, including re-authentication, to prevent accidental deletion.
    *   The UI shall clearly state that this action is irreversible and specify the duration of the 30-day grace period before permanent deletion.
    *   Upon confirmation, the tenant shall be marked for deletion, entering a 30-day grace period during which the action can be reversed by the Admin.
    *   After the grace period, a scheduled Cloud Function shall be triggered to systematically and irreversibly delete all data associated with that `tenantId` from all collections, including users, teams, attendance, events, and audit logs.
    *   The offboarding process shall also include the deletion of any associated external data, such as revoking Google Sheets API tokens.
*   **3.1.3 User Invitation and Management (REQ-FUN-002)**
    *   The system shall allow Admins to invite new users (Supervisors, Subordinates) via email.
    *   When an Admin invites a user, the system shall create a new user document with a status of `invited`.
    *   When an Admin invites a user, the system shall send an invitation email with a unique, 24-hour time-limited registration link to the employee, utilizing the SendGrid transactional email service integrated via a Firebase Extension.
    *   When an invited user clicks the registration link and sets their password, their user status shall be updated to `active`.
    *   Upon activation, the system shall allow the new user to log in.
    *   The system shall allow an Admin to deactivate a user.
    *   When an Admin deactivates a user, the user's status shall be set to `deactivated`.
    *   A user with a `deactivated` status shall be prevented from logging in.
*   **3.1.4 Team Management**
    *   The system shall provide an interface in the Admin dashboard for Admins to create, view, update, and delete teams within their tenant.
    *   The team creation process shall allow an Admin to specify a team name and assign a Supervisor to the team.
    *   The interface shall allow Admins and the assigned Supervisor to add or remove Subordinates from a team's member list.
    *   The system shall allow a user to be a member of multiple teams.
    *   The system shall allow a Supervisor to manage multiple teams.
    *   The system shall allow an Admin to edit a team's name or reassign its Supervisor.
*   **3.1.5 Role-Based Login and Password Reset (REQ-FUN-003)**
    *   The system shall allow registered users to log in using their credentials (Email/Password or Phone OTP).
    *   The system shall implement brute-force protection by temporarily locking an account for 15 minutes after 5 failed login attempts.
    *   The login screen shall provide a 'Forgot Password' link.
    *   Upon a user's request, the system shall use Firebase Authentication's built-in functionality to send a password reset link to the user's registered email address.
    *   Upon successful login, the system shall route the user to the appropriate dashboard based on their assigned role (Admin, Supervisor, or Subordinate).
    *   The system shall show an error message to a user who provides invalid credentials.
    *   The system shall show an appropriate message and deny access to any user with a `deactivated` or `invited` status who attempts to log in.

##### **3.2 Attendance Management**
*   **3.2.1 Attendance Capture (REQ-FUN-004)**
    *   The system shall allow users to check-in and check-out to record their attendance.
    *   When a user checks in, the app shall capture the current timestamp from the client device (`clientTimestamp`) and the user's current GPS coordinates, including horizontal accuracy in meters.
    *   Upon check-in, the system shall create a new attendance record in Firestore with a `checkInTime`, `checkInGps`, and a status of `pending`.
    *   When a user checks out, the app shall capture the current timestamp and the user's current GPS coordinates.
    *   Upon check-out, the system shall update the *same* attendance record with a `checkOutTime` and `checkOutGps`.
    *   Upon successful sync of the record to the server, the system shall record a `serverTimestamp` using `FieldValue.serverTimestamp()` to validate when the data was received.
    *   The system shall compare the `clientTimestamp` with the `serverTimestamp`. If a discrepancy greater than 5 minutes is detected, the record shall be flagged as `clock_discrepancy` for administrative review.
    *   The "Check-Out" button shall be disabled until a "Check-In" has been performed for the current record.
    *   The system shall enforce the business rule that a check-out action must update the corresponding check-in record for that day and not create a new record.
*   **3.2.2 Auto-Checkout (REQ-FUN-005)**
    *   The system shall provide a configurable option to automatically check out users who have not checked out manually by a predefined time.
    *   A scheduled Cloud Function shall run at the configured auto-checkout time, respecting the tenant's configured timezone.
    *   The function shall find attendance records with a `checkInTime` but a null `checkOutTime` for that day.
    *   The function shall update those records with a `checkOutTime` equal to the configured end-of-workday time.
    *   The function shall mark the record with a flag `auto-checked-out`.
*   **3.2.3 Offline Attendance Capture (REQ-FUN-006)**
    *   The system shall allow users to mark attendance when their device is offline.
    *   When offline, attendance data shall be written to the local Firestore cache with a flag `isOfflineEntry` set to `true`.
    *   When device connectivity is restored, the Firestore SDK shall automatically sync the local data to the server.
    *   If a record stored offline fails to sync after 24 hours, the system shall show the user a persistent, non-dismissible notification in the app.
    *   Upon sync failure, the system shall prompt the user to manually trigger the sync and provide guidance on resolving the issue.
    *   All sync failure events shall be logged to a dedicated server-side log for administrative monitoring and troubleshooting.

##### **3.3 Approval Workflows**
*   **3.3.1 Supervisor Dashboard and Review (REQ-FUN-007)**
    *   The system shall provide Supervisors with a dashboard to view all pending attendance records from their direct subordinates.
    *   The Supervisor dashboard shall display a list of attendance records where the `supervisorId` matches their `userId` and the `status` is `pending`.
    *   The Supervisor dashboard shall visually distinguish attendance records that were created offline (i.e., have the `isOfflineEntry` flag) or have a `clock_discrepancy` flag to allow for additional scrutiny.
    *   The system shall allow a Supervisor to approve selected records, which changes their status to `approved`.
    *   The system shall allow a Supervisor to reject selected records, which changes their status to `rejected`.
    *   The system shall require a Supervisor to provide a reason when rejecting a record, and this reason shall be stored in the attendance record and be visible to the Subordinate.
    *   The Supervisor dashboard shall support bulk actions, allowing the selection of multiple records to be approved or rejected at once.
*   **3.3.2 Approval Escalation (REQ-FUN-008)**
    *   The system shall support a hierarchical escalation path based on the user's defined `supervisorId` chain.
    *   The system shall allow an approval deadline to be configured in the tenant `config`.
    *   A scheduled Cloud Function shall detect `pending` records that have exceeded the configured deadline for their assigned supervisor.
    *   Upon deadline expiry, the system shall reassign the approval request to the next supervisor in the hierarchy, ensuring the record does not remain un-actioned.
    *   Each escalation event shall be logged in the `auditLog` collection, detailing the record, the original supervisor, and the new supervisor.
*   **3.3.3 Attendance Correction Workflow (REQ-FUN-014)**
    *   The system shall provide a formal, auditable workflow for users to request corrections to their attendance records.
    *   A Subordinate shall be able to initiate a correction request for one of their attendance records.
    *   The user shall provide the corrected time(s) and a mandatory justification for the correction request.
    *   Upon submission of a correction request, the attendance record's status shall be changed to `correction_pending`.
    *   The correction request shall appear in the Supervisor's approval dashboard.
    *   If the Supervisor approves the correction, a Cloud Function shall update the attendance record with the new data.
    *   Approved corrected records shall be marked with a `manually-corrected` flag.
    *   The entire correction action (request, justification, approval, original data, new data) shall be logged immutably in the `auditLog` collection.
    *   If a correction request is rejected, the record shall revert to its previous state, and the user shall be notified via a push notification.
    *   Admins shall have the authority to make direct edits to any record.
    *   All direct edits by an Admin shall be mandatorily logged in the `auditLog` with a justification.

##### **3.4 Event Management**
*   **3.4.1 Event Creation and Assignment (REQ-FUN-009)**
    *   The system shall allow Supervisors to create events (e.g., training, field visit).
    *   The event creation form shall include `title`, `description`, `startTime`, and `endTime`.
    *   The system shall support the creation of recurring events with patterns for daily, weekly, and monthly recurrence.
    *   The system shall allow a Supervisor to assign an event to one or more individuals under their management.
    *   The system shall allow a Supervisor to assign an event to pre-defined teams under their management.
    *   When saved, the event shall be stored in the `events` collection.
*   **3.4.2 Event-Based Attendance (REQ-FUN-010)**
    *   When a user checks in, the system shall present them with a list of events they are assigned to for that day.
    *   The system shall allow the user to optionally select an event to link to their attendance record.
    *   The system shall store the `eventId` in the corresponding attendance record if an event is selected.
*   **3.4.3 User Event Visibility and Notifications (REQ-FUN-011)**
    *   The system shall provide Subordinates with a read-only calendar view of events they are assigned to.
    *   The Subordinate's calendar shall display all events where their `userId` is in `assignedUserIds` or they are a member of a team in `assignedTeamIds`.
    *   When a Supervisor assigns a user to a new event, the system shall send a Firebase Cloud Messaging (FCM) push notification to that user's device.

##### **3.5 Reporting and Data Export**
*   **3.5.1 Admin Reporting Dashboard (REQ-REP-001)**
    *   The system shall provide Admins with an in-app and web dashboard to view attendance summaries and detailed reports.
    *   The Admin dashboard shall provide summary views for daily, weekly, and monthly attendance.
    *   Reports shall be filterable by date range, user, team, and attendance status (`pending`, `approved`, `rejected`).
    *   Reports shall provide a clear visual indicator for attendance records that were created offline or have other flags.
    *   The system shall provide a 'Daily/Weekly/Monthly Attendance Summary' report.
    *   The system shall provide a 'Late Arrival / Early Departure Report' based on configured working hours.
    *   The system shall provide an 'Exception Report' for events like missed check-outs, manually edited records, and offline entries.
    *   The system shall provide an 'Audit Log Report' allowing Admins to view and filter the immutable log of critical system actions.
    *   All reports shall be exportable from the web dashboard in CSV format.
*   **3.5.2 Google Sheets Export (REQ-FUN-012)**
    *   The system shall allow Admins to configure automatic export of attendance data to a designated Google Sheet.
    *   An Admin shall be able to initiate an OAuth 2.0 flow from the web dashboard to grant the application permission to access their Google Drive/Sheets.
    *   The system shall securely store the refresh token and the ID of the target Google Sheet.
    *   A scheduled Cloud Function shall run at a configurable interval (daily or weekly) to perform the export.
    *   The function shall retrieve new, approved attendance records and append them as new rows to the linked Google Sheet in the following predefined format: Record ID, User Name, User Email, Check-In Time, Check-In GPS Latitude, Check-In GPS Longitude, Check-Out Time, Check-Out GPS Latitude, Check-Out GPS Longitude, Status, Notes.
    *   The export function shall validate the target sheet's header row before writing data. If the schema has been altered, the export shall fail, and an error shall be logged and displayed to the Admin.
*   **3.5.3 Google Sheets Export Failure Recovery (REQ-FUN-013)**
    *   The system shall handle failures in the Google Sheets sync process.
    *   Upon detecting an API error (file not found, permission revoked, schema mismatch), the sync function shall set the status of the linked sheet to `error` in Firestore.
    *   The Admin dashboard shall display a prominent alert about the sync failure with details of the error.
    *   The system shall prompt the Admin to re-authenticate and link a new or existing Google Sheet after a failure.
    *   Attendance records that failed to sync shall be queued and exported on the next successful run, ensuring no data is lost and no duplicates are created.

##### **3.6 Administration**
*   **3.6.1 Tenant Configuration Management**
    *   The system shall provide a 'Tenant Settings' or 'Organization Configuration' section in the Admin web dashboard.
    *   This interface shall allow Admins to view and update key-value pairs for system behavior.
    *   Configurable settings shall include, but are not limited to:
        *   Organization Timezone.
        *   Auto-checkout time.
        *   Approval escalation period (in days).
        *   Default working hours for reporting purposes.
        *   Password policy (minimum length, complexity requirements).
        *   Data retention periods for attendance and audit logs.

#### **4. Interface Requirements**

##### **4.1 User Interfaces (REQ-INT-001)**
*   The UI shall be clean, intuitive, and follow Material Design 3 principles for Android and the web dashboard.
*   The UI shall be clean, intuitive, and follow Human Interface Guidelines for iOS.
*   The mobile app UI shall adapt to various screen sizes and orientations.
*   The Admin web dashboard shall be responsive for standard desktop and tablet viewports.
*   The system shall provide immediate visual feedback for user actions, such as loading indicators, success messages, and clear error notifications.
*   The application shall meet WCAG 2.1 Level AA accessibility standards.
*   The application shall include support for screen readers, sufficient color contrast, and scalable text.
*   The application shall be developed with internationalization (i18n) support in its architecture. The initial release shall support English (en-US), and all user-facing strings shall be managed in resource files to facilitate future localization.

##### **4.2 Hardware Interfaces (REQ-INT-002)**
*   The application shall require access to the device's GPS/location services to capture coordinates.
*   The application shall explicitly request permission from the user before accessing location services.
*   The application shall gracefully handle scenarios where location permissions are denied or revoked, guiding the user to the device settings to enable them.

##### **4.3 Software Interfaces (REQ-INT-003)**
*   The system shall integrate with the Google Maps API to display a map preview of check-in/check-out locations.
*   The system shall integrate with the Google Sheets API and Google Drive API for the data export feature.
*   The system shall require Admin authorization via OAuth 2.0 for Google Sheets/Drive integration.
*   The application shall be fundamentally dependent on the Firebase SDKs for all backend interactions.
*   The application shall use the `drift` local database package to manage complex offline data, such as the user's event calendar and pending sync failure notifications, complementing Firestore's built-in offline cache.

##### **4.4 Communication Interfaces (REQ-INT-004)**
*   All communication between the client application and Firebase services shall occur over HTTPS (TLS).
*   Data exchanged with Google services APIs shall use the JSON format.
*   Authentication shall be handled via JSON Web Tokens (JWTs) issued by Firebase Authentication.
*   JWTs shall be sent with every request to Firestore and Cloud Functions for validation.

#### **5. Non-Functional Requirements**

##### **5.1 Performance (REQ-NFR-001)**
*   The mobile application's cold start time shall be less than 3 seconds.
*   The GPS lock time shall be less than 10 seconds under normal conditions.
*   Firestore data sync for typical write operations shall complete in less than 1 second on a stable connection.
*   The 95th percentile (p95) response time for callable Cloud Functions shall be less than 500ms.
*   UI rendering and animations shall maintain a consistent 60 frames per second (fps) to ensure a smooth user experience.

##### **5.2 Security (REQ-NFR-003)**
*   The system shall support multi-factor authentication via Firebase Authentication's Email/Password and Phone OTP methods.
*   The system shall enforce a strict Role-Based Access Control (RBAC) model primarily through Firestore Security Rules.
*   The system shall use custom claims (`tenantId`, `role`) in the user's auth token for authorization.
*   Firestore Security Rules shall be the primary mechanism to ensure users can only access data within their own tenant (`/tenants/{tenantId}`).
*   Firestore Security Rules shall ensure Supervisors can only access data belonging to their direct subordinates.
*   Firestore Security Rules shall ensure Admins have full access within their tenant.
*   Firestore Security Rules shall ensure users can only read/write their own data unless their role grants wider permissions.
*   All communication between the Flutter client and Firebase services shall be encrypted in transit via TLS (HTTPS).
*   All data stored in Firestore and Firebase Storage shall be automatically encrypted at rest by Google Cloud Platform.
*   GPS data shall be secured through platform-level encryption at rest and in transit.
*   GPS data shall be made non-editable by end-users via Firestore Security Rules.
*   All server-side secrets, such as third-party API keys, shall be stored in Google Secret Manager and accessed securely by Cloud Functions at runtime.
*   The system shall implement input validation on both the client-side and server-side (Cloud Functions) to prevent common vulnerabilities like injection attacks.
*   The system shall enforce a session management policy where Firebase Auth ID tokens expire after one hour and are automatically refreshed by the client SDK.

##### **5.3 Reliability and Availability**
*   **5.3.1 Availability (REQ-NFR-004)**
    *   The service shall target 99.9% availability, excluding planned maintenance and the SLA of underlying Google Cloud services.
    *   A formal Service Level Agreement (SLA) document shall be provided for paid subscription tiers.
    *   Planned maintenance windows shall be scheduled during low-traffic hours.
    *   Users shall be communicated to in advance if planned maintenance is expected to cause downtime.
    *   In case of partial system failure, the core attendance marking functionality shall remain operational.
*   **5.3.2 Safety and Recovery (REQ-NFR-002)**
    *   The system shall perform daily automated backups of the Firestore database using the GCP managed export service. This feature shall be available for tenants on a paid subscription tier.
    *   Database backups shall be stored in a separate Google Cloud Storage bucket for disaster recovery.
    *   The Recovery Point Objective (RPO) for the system shall be 24 hours.
    *   The Recovery Time Objective (RTO) for the system shall be 4 hours, representing the target time to restore service from a backup in a disaster scenario.
    *   The disaster recovery plan, including the restoration process from backups, shall be documented and tested on a semi-annual basis to ensure its effectiveness.

##### **5.4 Scalability (REQ-NFR-005)**
*   The serverless architecture shall automatically scale to support thousands of concurrent users per tenant. The cost implications of scaling for large tenants shall be managed through tiered subscription plans.
*   The Firestore data model shall be designed to scale horizontally to accommodate significant data growth without performance degradation.

##### **5.5 Maintainability (REQ-NFR-006)**
*   All new code shall have a minimum of 80% unit and widget test coverage.
*   Code shall be documented following standard Dart and TypeScript conventions.
*   Backend resources, including Firestore indexes and security rules, shall be managed using an Infrastructure as Code (IaC) approach with the Firebase CLI.
*   The Flutter application shall follow a clean architecture pattern to separate business logic from UI and data layers.
*   The development process shall mandate the use of the Firebase Local Emulator Suite for local development and testing to improve developer velocity and reduce costs.
*   The Flutter codebase shall be statically analyzed using the official `lints` package to enforce consistent style and best practices.
*   The TypeScript Cloud Functions codebase shall be statically analyzed and formatted using `ESLint` and `Prettier`.
*   A user-facing and technical changelog shall be maintained for all releases.

##### **5.6 Compliance**
*   The system shall be designed to comply with the General Data Protection Regulation (GDPR).
*   This includes implementing clear user consent flows for data collection, providing mechanisms for users to request or export their personal data, and ensuring the right to erasure through the tenant offboarding process.
*   The system shall provide a Data Processing Addendum (DPA) for enterprise customers to formalize data handling responsibilities.

##### **5.7 Cost Management**
*   The system shall implement a cost management and resource usage policy.
*   This shall include tenant-level soft quotas or limits on Firestore reads/writes, Cloud Function invocations, and data storage to prevent excessive costs.
*   The system shall include monitoring and alerts that notify system administrators when a tenant's usage approaches levels that would incur significant costs.

#### **6. Data Requirements**

##### **6.1 Data Model (REQ-DAT-001)**
*   The system shall use a `/tenants/{tenantId}` collection as the root for all tenant-specific data.
*   The `/users/{userId}` collection shall store user profile data including `email`, `role`, `supervisorId` (nullable for top-level users), `teamIds`, `status`, and `schemaVersion`.
*   The `/teams/{teamId}` collection shall be created to manage teams, including `name`, `supervisorId`, and `memberIds`.
*   The `/attendance/{recordId}` collection shall store attendance data including `userId`, `supervisorId`, `checkInTime`, `checkInGps` (as a Firestore GeoPoint), `checkOutTime`, `checkOutGps` (as a Firestore GeoPoint), `status`, `rejectionReason` (nullable), and `flags` (an array of strings containing any of: `isOfflineEntry`, `auto-checked-out`, `manually-corrected`, `clock_discrepancy`).
*   The `/events/{eventId}` collection shall store event data including `title`, `startTime`, `endTime`, `assignedUserIds`, and `assignedTeamIds`.
*   The `/auditLog/{logId}` collection shall be created to immutably log critical actions, including `timestamp`, `actorUserId`, `actionType`, `targetEntityId`, `details` (a map containing `oldValue` and `newValue` fields), and `justification`.
*   The `/config/{singletonDoc}` collection shall store tenant-wide configurations.
*   The `/linkedSheets/{adminUserId}` collection shall store metadata for Google Sheets integration.
*   All necessary composite indexes for Firestore queries shall be defined in the `firestore.indexes.json` file and deployed as part of the IaC process to ensure query performance.

##### **6.2 Data Retention Policy**
*   The system shall enforce a clear data retention policy for all major data collections.
*   Attendance records shall be retained for a default period of 2 years before being archived or deleted.
*   Audit logs shall be retained for a default period of 7 years.
*   Data for a user whose status is `deactivated` shall be processed after 90 days. The user's personal data (e.g., name, email) shall be deleted. To maintain the integrity of historical records, any reference to their `userId` in other collections, such as `auditLog`, shall be replaced with a non-reversible, anonymized identifier (e.g., 'DeletedUser-XYZ').
*   These retention periods may be configurable at the tenant level where feasible.
*   The data retention process (archival and deletion) shall be automated via scheduled Cloud Functions, and the execution of these functions shall be logged for auditing purposes.

#### **7. Other Requirements**

##### **7.1 Technology Stack (REQ-TEC-001)**
*   **Mobile Application:**
    *   Framework: Flutter 3.x
    *   State Management: Riverpod 2.x
    *   Testing: `flutter_test` for unit/widget tests, `integration_test` for end-to-end tests.
    *   Code Quality: `lints` package.
*   **Backend Platform:** Firebase (Google Cloud Platform)
*   **Authentication:** Firebase Authentication with Email/Password and Phone OTP.
*   **Database:** Firebase Firestore.
*   **Serverless Logic:**
    *   Platform: Firebase Cloud Functions.
    *   Language/Runtime: TypeScript on Node.js 18+.
    *   Testing: `Jest` framework.
    *   Data Validation: `Zod` for schema validation.
    *   Code Quality: `ESLint` and `Prettier`.
*   **File Storage:** Firebase Storage.
*   **Push Notifications:** Firebase Cloud Messaging (FCM).
*   **Admin Web Dashboard:**
    *   Framework: Flutter for Web.
    *   UI: Material 3 component library.
    *   Hosting: Firebase Hosting.
*   **External API Integrations:**
    *   Mapping: Google Maps API.
    *   Spreadsheets: Google Sheets API.
    *   Transactional Email: Firebase Extension for SendGrid.
*   **Development Environment:** Firebase Local Emulator Suite.
*   **Continuous Integration / Continuous Deployment (CI/CD):** GitHub Actions.
*   **Infrastructure as Code (IaC):** Firebase CLI.

##### **7.2 Monitoring & Logging (REQ-REP-002)**
*   The system shall use Firebase Crashlytics for real-time client-side crash reporting.
*   The system shall use Firebase Performance Monitoring to track app performance metrics.
*   The system shall use Google Analytics for Firebase to gather user engagement metrics.
*   The system shall use Google Cloud's Operations Suite (Cloud Logging & Monitoring) for server-side monitoring.
*   All server-side logs generated by Cloud Functions shall be structured in JSON format to facilitate querying and analysis.
*   All security-sensitive events, including failed login attempts, password resets, role changes, and permission changes, shall be logged to the immutable `auditLog` collection in addition to standard application logs.
*   Alerts shall be configured in Google Cloud Monitoring for Cloud Function error rates exceeding 1%.
*   Alerts shall be configured in Google Cloud Monitoring for Cloud Function execution times exceeding 2 seconds.
*   Alerts shall be configured in Firebase for significant spikes in app crashes.
*   Budget alerts shall be configured in GCP to prevent uncontrolled cloud costs and notify administrators of potential overages.

#### **8. Transition Requirements**

##### **8.1 Implementation Approach**
*   The system shall be deployed using a phased rollout methodology.
*   **Phase 1 (Pilot):** The initial deployment shall be to a limited, pre-selected pilot group within the client organization for a period of 30 days to gather feedback and validate core functionality.
*   **Phase 2 (Staged Rollout):** Following a successful pilot, the system shall be rolled out to the remaining users in stages, organized by department or team.
*   **Phase 3 (Full Deployment):** Once all stages are complete, the system will be considered fully deployed.

##### **8.2 Data Migration Strategy**
*   The system shall provide a data migration path for new tenants transitioning from existing systems.
*   **8.2.1 Data Extraction:** The tenant Admin shall be responsible for extracting user and team data from the legacy system into a predefined CSV template provided by the implementation team.
*   **8.2.2 Data Transformation:** The implementation team shall provide scripts to validate and transform the provided CSV data into the required format for ingestion.
*   **8.2.3 Data Loading:** A secure, Admin-only data import tool shall be provided in the web dashboard to upload the transformed data, which will trigger a Cloud Function to create user profiles, teams, and send out activation invitations.
*   **8.2.4 Data Validation:** After the import, the Admin shall be provided with a summary report detailing successful and failed records. The Admin must review and validate the imported data for accuracy before proceeding with the user rollout.
*   Historical attendance data shall not be migrated. The system will start recording new data from the date of cutover.

##### **8.3 Training Requirements**
*   Role-based training shall be provided for all user classes.
*   **8.3.1 Training Materials:** The following materials shall be developed:
    *   **Admin Guide (PDF):** Detailed documentation covering all web dashboard functions, including user management, configuration, and reporting.
    *   **Supervisor Guide (PDF):** Documentation focused on team management, event creation, and the approval workflow.
    *   **Subordinate Quick Start Guide (PDF/Video):** A simple guide on how to install the app, log in, and perform check-in/check-out.
*   **8.3.2 Training Delivery:** All training materials shall be delivered online and be self-paced, accessible via a help section within the application and web dashboard.

##### **8.4 Cutover Plan**
*   A formal cutover plan shall be executed for each new tenant's go-live.
*   **8.4.1 Pre-Cutover Checklist:** A checklist shall be completed 48 hours before go-live, including data migration validation, tenant configuration sign-off, and communication plan readiness.
*   **8.4.2 Cutover Window:** The cutover shall be scheduled during a period of low business activity, typically over a weekend. During this window, final data will be loaded, and user invitations will be sent.
*   **8.4.3 Post-Cutover Support:** For the first 5 business days post-go-live, enhanced support shall be available to address user issues and questions.
*   **8.4.4 Success Criteria:** The cutover shall be deemed successful if 95% of users can successfully log in and perform a check-in within the first 24 hours of their first scheduled workday.
*   **8.4.5 Fallback Plan:** In the event of a critical system failure during cutover, the process shall be halted, and the organization will continue using its legacy system. A root cause analysis will be performed before rescheduling the cutover.

##### **8.5 Legacy System Decommissioning**
*   The legacy attendance system shall be decommissioned following a successful transition.
*   **8.5.1 Read-Only Period:** After the go-live date, the legacy system shall be placed in a read-only mode for 90 days to allow for historical data access if needed.
*   **8.5.2 Data Archival:** At the end of the read-only period, a final data export of the legacy system shall be performed by the tenant and stored according to their internal data retention policies.
*   **8.5.3 System Shutdown:** After data archival is confirmed, the legacy system shall be formally shut down and all associated services and accounts shall be terminated.