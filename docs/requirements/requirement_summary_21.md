# 1 Id

393

# 2 Section

Smart Attendance App Summary

# 3 Section Id

SUMMARY-001

# 4 Section Requirement Text

```
The Smart Attendance App aims to provide a free, cross-platform mobile solution for organizations with hierarchical structures. Key features include GPS-based attendance marking, a supervisor approval workflow, and calendar-based event management, with optional data export to Google Sheets. It is designed for multi-tenant use, isolating each organization's data.

**Technology Stack:** The app leverages Flutter for cross-platform development (Android/iOS), Firebase Authentication for user management (email/password, OTP), Firebase Firestore as a real-time NoSQL database with role-based access, and Firebase Cloud Messaging for notifications. Google Maps API is integrated for GPS location preview, and Google Sheets API + Google Drive for reporting and export.

**System Architecture:** A multi-tenant structure is implemented, with each organization's data stored under `/tenants/{tenantId}` in Firestore, enforced by Firebase Security Rules. The simplified data model includes collections for users, attendance records, events, organization configurations, and linked Google Sheets.

**Functional Modules:**
*   **Authentication:** Role-based login for Admin, Supervisor, and Subordinate roles using Firebase Auth.
*   **Attendance Capture:** Allows button or event-based check-in/out, capturing timestamp, GPS coordinates, and event reference, with optional offline sync.
*   **Supervisor Approval Flow:** Subordinate attendance is marked pending, requiring supervisor approval or rejection with comments. Supports multiple approval levels.
*   **Calendar & Events:** Supervisors can create and assign events (e.g., training, field visits) to individuals or teams, linking attendance to specific events.
*   **Reporting & Export:** Admins can view attendance summaries and optionally sync data to Google Sheets daily/weekly via OAuth, with recovery logic for sheet failures.

**Data Storage:** Firebase Firestore is the primary storage for master data, events, daily attendance (with optional export to Google Sheets), and configurations. Google Sheets serves for daily summaries, admin-visible history, and optional backups.

**Security and Access Control:** Firebase Security Rules enforce tenant isolation, supervisor-subordinate data visibility, and full admin access. Google Sheets access is OAuth-based and per-admin. GPS data is secured (encrypted in transit and at rest) and immutable after submission.

**Development & Publishing:** The development follows a modular flow, from planning to deployment. Publishing targets Google Play Store (Android) and Apple App Store (iOS via TestFlight), requiring standard permissions and privacy policies.

**Developer Notes:** Emphasizes state management (Provider/Riverpod), robust GPS permission handling, offline support, secure handling of sensitive data (HTTPS, Firebase encryption at rest, Firestore Security Rules), and use of Firestore batch/transactions.
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

