# 1 Id

392

# 2 Section

Smart Attendance App Specification

# 3 Section Id

SRS-001

# 4 Section Requirement Text

```javascript
Smart Attendance App

Objective

Develop a free, cross-platform mobile attendance application for organizations with a hierarchical structure. The app should support GPS-based attendance marking, supervisor approval workflows, calendar-based events, and optional export to Google Sheets. Designed for multi-tenant use, this app will be made available for organizations who cannot afford commercial attendance solutions.

_

1. Technology Stack

Component	Technology	Notes
Mobile Framework	Flutter	Cross-platform for Android and iOS
Authentication	Firebase Authentication	Email/password and phone OTP support
Database	Firebase Firestore	Real-time NoSQL with role-based access rules
Storage (Optional)	Firebase Storage	For files or attachments (if needed)
Reports & Export	Google Sheets API + Google Drive	Admin-specific reporting interface
Notifications	Firebase Cloud Messaging	For reminders and approval updates
Maps Integration	Google Maps API	GPS location preview
Hosting (Optional)	Firebase Hosting	For web panel or public pages (if needed)

_

2. System Architecture

Multi-Tenant Structure
	_	Each organization is treated as an isolated tenant.
	_	Firebase stores all data under /tenants/{tenantId}.
	_	Firebase rules enforce tenant-based data access.

Data Model (Simplified)

/tenants/{tenantId}/
    users/{userId}
    attendance/{recordId}
    events/{eventId}
    config/
    linkedSheets/

Firebase Collections
	_	users: stores user profile, role, and reporting structure
	_	attendance: stores timestamp, GPS, and event-based records
	_	events: stores supervisor-assigned events or tasks
	_	config: organization-specific policies (working hours, geofence)
	_	linkedSheets: file ID and metadata for Google Sheet export

_

3. Functional Modules

3.1 Authentication
	_	Role-based login (Admin, Supervisor, Subordinate)
	_	Firebase Auth with Email/Password and/or OTP

3.2 Attendance Capture
	_	Button or event-based check-in/out
	_	Capture:
	_	Timestamp
	_	GPS coordinates
	_	Event reference (if applicable)
	_	Store in Firestore
	_	Optional offline sync logic

3.3 Supervisor Approval Flow
	_	Subordinate attendance is marked _pending_
	_	Supervisor views requests in their dashboard
	_	Approves or rejects with optional comments
	_	System supports multiple approval levels if configured

3.4 Calendar & Events
	_	Supervisors create events: training, field visit, etc.
	_	Events are assigned to individuals or teams
	_	Attendance can be linked to event ID

3.5 Reporting & Export
	_	Admins can view attendance summaries
	_	Optionally sync data to Google Sheets using:
	_	OAuth-based access to Drive
	_	Append attendance records daily or weekly
	_	Alerts or retry mechanism if sheet is removed or permission is revoked

_

4. Data Storage Strategy

Data Type	Firebase	Google Sheets
Master Data (users, hierarchy)	Yes	No
Events	Yes	No
Daily Attendance	Yes	Optional export only
Configurations	Yes	No
Reports (exports)	Derived	Yes

Google Sheets will be used for:
	_	Daily summaries or attendance exports
	_	Admin-visible history
	_	Optional backup (JSON or CSV)

_

5. Security and Access Control
	_	Firebase rules ensure:
	_	Users only access their tenant_s data
	_	Supervisors can only see their subordinates
	_	Admins have full org access
	_	Google Sheets access is per-admin and must be manually granted through OAuth
	_	GPS data is <<$Change>>secured (encrypted in transit and at rest)<<$Change>> and not editable after submission
Enhancement Justification:
The original requirement "GPS data is encrypted and not editable after submission" was ambiguous regarding the type of encryption. For a Firebase-centric architecture, relying on Firebase's default encryption-in-transit (HTTPS) and encryption-at-rest, combined with robust Firestore Security Rules for access control, is the standard and most feasible approach. Client-side application-level encryption of GPS data would severely complicate or prevent the use of Firestore Security Rules for filtering and access control, as well as querying and reporting, which are critical functionalities. This change clarifies that GPS data is secured through platform-level encryption and access control, ensuring its protection without hindering core application features.

_

6. App Development Flow

Phase	Tasks
Planning	Confirm features, design screens, set up Firebase
Authentication Module	Implement Firebase login and role routing
Attendance Module	Develop GPS capture and data submission
Approval Module	Create supervisor dashboards and approval logic
Event Module	Enable calendar creation and event linkage
Google Integration	Admin OAuth + Sheet syncing
Testing	Unit testing, Firebase rule testing, offline sync
Deployment	Google Play Store, TestFlight (iOS), Firebase Hosting (optional)

_

7. Publishing Strategy

Android (Google Play Store)
	_	Create app bundle
	_	Add permissions for location and internet
	_	Add Privacy Policy and Terms (hosted on Firebase Hosting or GitHub Pages)
	_	Use internal test track for first QA phase

iOS (TestFlight / App Store)
	_	Sign with Apple Developer Account
	_	Manage entitlements for location and network
	_	Submit via Xcode or Flutter build tools

_

8. Optional Enhancements
	_	Web dashboard for Admin (using Flutter Web or React)
	_	Analytics (attendance trends, GPS map heatmaps)
	_	Email or WhatsApp notification integration
	_	Sponsor or donation system to support free use

_

9. Admin Recovery Logic (Google Sheet Failure)
	_	Store file ID in Firebase
	_	Detect API errors (file missing, permission revoked)
	_	App shows admin prompt to re-link or recreate Google Sheet
	_	New attendance records are queued until successful sync

_

10. Developer Notes
	_	Use Provider or Riverpod for state management
	_	Handle GPS and location permission with fallback logic
	_	Include offline support for key screens
	_	<<$Change>>All sensitive data must be handled securely, ensuring encryption in transit (HTTPS) and at rest (Firebase's default encryption). Robust Firestore Security Rules will enforce access control.<<$Change>>
Enhancement Justification:
The original requirement "All sensitive data must be encrypted before submission" implied client-side application-level encryption for all sensitive data. This is technically infeasible for a Firebase Firestore-based application that relies heavily on Firestore Security Rules for multi-tenancy, role-based access control, and querying. If data is encrypted client-side, Firestore Security Rules cannot inspect or filter data based on its content, making it impossible to implement features like supervisors seeing only their subordinates' data or tenant isolation. Furthermore, querying, indexing, and reporting on such encrypted data would be extremely complex or impossible without a custom server-side decryption layer, which contradicts the "free" and simplified Firebase-centric architecture. The revised requirement clarifies that security will be achieved through standard industry practices: HTTPS for data in transit, Firebase's inherent encryption at rest, and the robust access control mechanisms provided by Firestore Security Rules. This approach ensures data security while maintaining the feasibility and functionality of the application.
	_	Use Firestore batch or transaction for consistent updates
```

# 5 Requirement Type

other

# 6 Priority

🔹 ❌ No

# 7 Original Text

❌ No

# 8 Change Comments

❌ No

# 9 Enhancement Justification

❌ No

