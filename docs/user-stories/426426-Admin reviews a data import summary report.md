# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-084 |
| Elaboration Date | 2025-01-26 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Admin reviews a data import summary report |
| As A User Story | As an Admin responsible for onboarding my organiza... |
| User Persona | Admin: A user with full access to their tenant's d... |
| Business Value | Improves the efficiency and accuracy of the tenant... |
| Functional Area | Tenant and User Management |
| Story Theme | Data Migration and Onboarding |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful import of all records

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

an Admin has uploaded a CSV file where all records are valid

### 3.1.5 When

the asynchronous import process completes successfully

### 3.1.6 Then

the Admin is shown a summary report on the web dashboard indicating: Total Records Processed, Number of Successful Imports (matching the total), and Number of Failed Imports (as 0). The list of failed records is empty.

### 3.1.7 Validation Notes

Verify the counts on the summary report are accurate. The 'Download Failed Records' button should be hidden or disabled.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Partial success with some failed records

### 3.2.3 Scenario Type

Alternative_Flow

### 3.2.4 Given

an Admin has uploaded a CSV file containing a mix of valid and invalid records (e.g., duplicate emails, invalid roles)

### 3.2.5 When

the import process completes

### 3.2.6 Then

the summary report accurately displays the total records processed, the count of successful imports, and the count of failed imports. A detailed list of failed records is displayed, showing the original row number, the problematic data, and a clear, user-friendly error message for each failure.

### 3.2.7 Validation Notes

Test with a CSV containing various error types. Ensure each failed row is listed with a specific, understandable error message (e.g., 'Email already exists', 'Invalid role specified', 'Required field 'name' is missing').

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Admin downloads the failed records report

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

an Admin is viewing an import summary report that contains at least one failed record

### 3.3.5 When

the Admin clicks the 'Download Failed Records' button

### 3.3.6 Then

a CSV file is downloaded to the Admin's computer. This file contains the full data from the original rows that failed, plus an additional column named 'Error' detailing the reason for the failure.

### 3.3.7 Validation Notes

Verify the downloaded file format is CSV, contains the correct header row (including the new 'Error' column), and includes only the rows that failed to import.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Import of a file with invalid headers or format

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

an Admin attempts to upload a file that is not a valid CSV or has incorrect/missing column headers

### 3.4.5 When

the system attempts to process the file

### 3.4.6 Then

the import process fails immediately, and the summary report shows a single, clear error message explaining that the file format or structure is incorrect (e.g., 'Invalid file format. Please upload a CSV.' or 'Missing required column header: email').

### 3.4.7 Validation Notes

Test with a .txt file, an empty file, and a CSV file with a modified header row.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

UI handling for asynchronous processing

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

an Admin has just uploaded a large CSV file for processing

### 3.5.5 When

the backend Cloud Function is processing the data

### 3.5.6 Then

the UI displays a clear 'Processing...' state with a loading indicator, preventing further uploads. Once the process is complete, the UI automatically updates to show the final summary report.

### 3.5.7 Validation Notes

Simulate a long-running function to ensure the UI remains responsive and provides clear feedback to the user about the ongoing process.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Report displays referential integrity errors

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

an Admin uploads a CSV where a user record lists a 'supervisorEmail' that does not correspond to another user in the CSV or an existing user in the tenant

### 3.6.5 When

the import process completes

### 3.6.6 Then

the summary report lists that record as failed with a clear error message, such as 'Supervisor with email 'supervisor@example.com' not found on row X'.

### 3.6.7 Validation Notes

Ensure the validation logic correctly checks for the existence of supervisors before creating subordinate records.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Summary statistics display (Total, Success, Fail counts)
- A table or list view for detailed failure reporting
- Columns in the failure table: 'Row Number', 'Problematic Data', 'Error Message'
- A 'Download Failed Records' button (enabled only if failures > 0)
- A loading indicator/spinner for the 'Processing' state
- A 'Close' or 'Back to Dashboard' button

## 4.2.0 User Interactions

- The report is displayed automatically in a modal or on a new page after the import process concludes.
- The failure list should be scrollable if it exceeds the viewable area.
- Clicking the download button initiates a file download.

## 4.3.0 Display Requirements

- Error messages must be human-readable and actionable, avoiding technical jargon.
- The report must clearly distinguish between successful and failed operations.

## 4.4.0 Accessibility Needs

- The report table must use proper HTML `<table>`, `<thead>`, `<th>`, and `<tbody>` tags for screen reader compatibility.
- Color indicators (e.g., red text for errors) must be supplemented with icons or text to meet WCAG standards.
- All interactive elements (buttons) must be keyboard-navigable and have clear focus states.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

The import process must be atomic at the row level. A single error in a row prevents that entire row from being imported; partial data from a failed row must not be saved.

### 5.1.3 Enforcement Point

Backend Cloud Function during data processing.

### 5.1.4 Violation Handling

The entire row's transaction is rolled back, and the failure is logged for the summary report.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The downloaded failure report must contain the original data plus the specific error message to facilitate easy correction and re-upload.

### 5.2.3 Enforcement Point

Backend Cloud Function responsible for generating the downloadable CSV.

### 5.2.4 Violation Handling

If the report cannot be generated, a server error should be logged, and the UI should display a message like 'Could not generate failure report. Please try again or contact support.'

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-083

#### 6.1.1.2 Dependency Reason

This story defines the file upload mechanism and the backend process that generates the data needed for this report. US-084 cannot be implemented without the import functionality from US-083.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-082

#### 6.1.2.2 Dependency Reason

This story defines the expected CSV template. The validation logic in the import process, and therefore the error messages in this report, are based on the structure defined in US-082.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Function for asynchronous CSV processing.
- Firestore for storing the import job status and results.
- Firebase Hosting for the Admin Web Dashboard (Flutter for Web).
- A server-side CSV parsing library (e.g., 'csv-parser' for Node.js).

## 6.3.0.0 Data Dependencies

- A finalized and versioned schema for the user/team import CSV file.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The backend processing of a CSV with 1,000 records should complete within 2 minutes.
- The summary report UI must load in under 2 seconds after the backend process is complete.

## 7.2.0.0 Security

- The Cloud Function for processing must be secured, accessible only by authenticated Admin users.
- The uploaded CSV file must be deleted from temporary storage immediately after processing is complete to protect PII.
- The generated failure report download link should be a short-lived, secure URL.

## 7.3.0.0 Usability

- Error messages must be clear, concise, and provide enough information for the Admin to solve the problem without needing to consult documentation.

## 7.4.0.0 Accessibility

- The report must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The Admin web dashboard, including this report view, must be functional on the latest stable versions of Chrome, Firefox, Safari, and Edge.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires robust asynchronous backend processing to handle file parsing, validation, and database operations without timing out.
- Complex state management on the frontend to reflect the 'uploading', 'processing', and 'complete' states.
- Requires careful design of the data model for storing import job results in Firestore.
- Server-side generation of a downloadable CSV report adds complexity.

## 8.3.0.0 Technical Risks

- Potential for Cloud Function timeouts with very large files if not optimized.
- Handling varied and complex validation rules (e.g., circular supervisor dependencies) can be challenging to implement correctly.
- Ensuring data consistency if a batch import is partially successful.

## 8.4.0.0 Integration Points

- The UI component for this report integrates with the file upload component (from US-083).
- The UI listens to a specific Firestore document path for real-time updates on the import job's status.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Usability

## 9.2.0.0 Test Scenarios

- Upload a perfectly valid CSV.
- Upload a CSV with a mix of valid and invalid data (duplicate emails, bad roles, missing fields, bad supervisor references).
- Upload a file with incorrect headers.
- Upload a non-CSV file.
- Upload an empty CSV.
- Verify the contents of the downloaded failure report CSV.

## 9.3.0.0 Test Data Needs

- A suite of test CSV files covering all success, failure, and edge-case scenarios.

## 9.4.0.0 Testing Tools

- Jest for Cloud Function unit tests.
- Firebase Local Emulator Suite for integration testing.
- `integration_test` package for Flutter E2E tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for Cloud Function logic implemented with >80% coverage
- Widget tests for the report UI component implemented
- Integration testing of the full upload-process-report flow completed successfully
- E2E test scenario for a partial failure and report download is automated and passing
- User interface reviewed and approved for clarity and usability
- All displayed error messages are verified to be user-friendly
- Documentation for the data import feature is updated to explain the summary report
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

8

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is tightly coupled with US-083. It is recommended to plan them for the same sprint and have the API contract (the structure of the Firestore results document) defined early.
- Requires both backend (Cloud Function) and frontend (Flutter Web) development effort.

## 11.4.0.0 Release Impact

This is a critical feature for the initial onboarding experience of new tenants. Its completion is necessary for any release targeting new customer acquisition.

