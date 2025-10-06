# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-030 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate is prevented from checking out before ... |
| As A User Story | As a Subordinate, I want the 'Check-Out' button to... |
| User Persona | Subordinate - The primary end-user responsible for... |
| Business Value | Ensures data integrity by preventing orphaned chec... |
| Functional Area | Attendance Management |
| Story Theme | Core Attendance Workflow |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Initial state on a new day

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Subordinate user opens the attendance screen

### 3.1.5 When

they have no active (non-checked-out) attendance record for the current calendar day

### 3.1.6 Then

the 'Check-In' button is enabled and interactive, and the 'Check-Out' button is disabled and not interactive.

### 3.1.7 Validation Notes

Verify the initial UI state upon loading the attendance screen. The check for the current day must respect the tenant's configured timezone.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

UI state updates immediately after a successful check-in

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Subordinate is on the attendance screen with the 'Check-In' button enabled

### 3.2.5 When

they successfully perform a check-in action

### 3.2.6 Then

the 'Check-In' button immediately becomes disabled, and the 'Check-Out' button immediately becomes enabled.

### 3.2.7 Validation Notes

The UI state change should be reactive and not require a screen refresh.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

State persistence after app restart

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

a Subordinate has an active check-in for the current day

### 3.3.5 When

they close and reopen the application on the same day and navigate back to the attendance screen

### 3.3.6 Then

the app correctly fetches their status, displaying the 'Check-In' button as disabled and the 'Check-Out' button as enabled.

### 3.3.7 Validation Notes

Test by killing the app process and restarting to ensure the state is correctly re-established from Firestore.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

State reset on a new calendar day

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

a Subordinate had an active check-in on the previous calendar day (e.g., they forgot to check out)

### 3.4.5 When

they open the app after midnight according to the tenant's timezone

### 3.4.6 Then

the attendance screen state is reset for the new day, with the 'Check-In' button enabled and the 'Check-Out' button disabled.

### 3.4.7 Validation Notes

This is critical for ensuring users can start a new day correctly. The previous day's record remains open and should be handled by other logic (e.g., REQ-FUN-005 Auto-Checkout).

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

UI state updates correctly during offline check-in

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

a Subordinate is using the app in offline mode

### 3.5.5 When

they perform a check-in action

### 3.5.6 Then

the check-in is saved to the local Firestore cache, and the UI immediately updates to disable the 'Check-In' button and enable the 'Check-Out' button.

### 3.5.7 Validation Notes

Verify that the UI state is driven by the local cache and does not wait for server confirmation, as per REQ-FUN-006.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Check-In Button
- Check-Out Button

## 4.2.0 User Interactions

- The disabled 'Check-Out' button must not respond to tap gestures.
- The visual state of both buttons must update instantly upon a successful check-in or check-out action.

## 4.3.0 Display Requirements

- A disabled button must be visually distinct from an enabled one (e.g., greyed out, reduced opacity) following Material Design guidelines.

## 4.4.0 Accessibility Needs

- The disabled state of a button must be announced by screen readers (e.g., 'Check-Out button, disabled').
- Color contrast for the disabled state must meet WCAG 2.1 AA standards.

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': "A check-out action can only be performed if there is a corresponding, open check-in record for the same user on the same calendar day, as defined by the tenant's timezone.", 'enforcement_point': 'Client-side UI logic (disabling the button).', 'violation_handling': 'The user is prevented from attempting the action by disabling the UI control.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

This story manages the state related to the check-in action. The check-in functionality must exist first.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-033

#### 6.1.2.2 Dependency Reason

The state management logic must account for offline check-ins, which are defined in this story.

## 6.2.0.0 Technical Dependencies

- Firebase Firestore for querying attendance status.
- Firestore Offline Persistence for handling offline state.
- Riverpod (or chosen state management solution) for managing the UI state reactively.

## 6.3.0.0 Data Dependencies

- Access to the current user's ID.
- Access to the tenant's configured timezone.
- Ability to query the `/attendance` collection (as per REQ-DAT-001).

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The query to determine the user's current check-in status on screen load must resolve in under 500ms to prevent UI lag.

## 7.2.0.0 Security

- While the UI enforces this rule, Firestore Security Rules should also prevent a check-out write if no corresponding check-in exists, as a secondary defense.

## 7.3.0.0 Usability

- The state of the buttons must be unambiguous to the user, clearly indicating the next expected action.

## 7.4.0.0 Accessibility

- Must adhere to WCAG 2.1 Level AA standards for visual and non-visual feedback on the button states.

## 7.5.0.0 Compatibility

- The logic must function correctly on all supported iOS and Android versions (REQ-DEP-001).

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- Requires careful handling of date and timezone logic to correctly identify the 'current day'.
- State management needs to be robust enough to handle online/offline transitions and app restarts seamlessly.

## 8.3.0.0 Technical Risks

- Incorrect timezone handling could lead to the state being reset at the wrong time (e.g., midnight UTC instead of the tenant's local midnight).

## 8.4.0.0 Integration Points

- Integrates with the state management provider that handles the core check-in/check-out logic.
- Reads from the Firestore `/attendance` collection.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration

## 9.2.0.0 Test Scenarios

- Verify button states for a new user on a new day.
- Verify button states change immediately after check-in.
- Verify button states are correct after killing and restarting the app.
- Verify button states reset correctly after the clock passes midnight in the tenant's timezone.
- Verify button states update correctly when checking in while the device is offline.

## 9.3.0.0 Test Data Needs

- A test user with no attendance records.
- A test user with an active check-in for the current day.
- A test user with a completed attendance record for the previous day.

## 9.4.0.0 Testing Tools

- flutter_test for unit/widget tests.
- integration_test for E2E tests.
- Firebase Local Emulator Suite to mock backend services.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for the new logic
- Integration testing completed successfully against the Firebase Emulator
- User interface reviewed and approved for both enabled/disabled states
- Performance requirements for state lookup verified
- Accessibility requirements for button states validated with a screen reader
- Documentation updated appropriately
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a core part of the attendance workflow and should be prioritized alongside US-028 (Check-In) and US-029 (Check-Out).

## 11.4.0.0 Release Impact

- Essential for the initial release of the attendance feature to ensure a stable and error-free user experience.

