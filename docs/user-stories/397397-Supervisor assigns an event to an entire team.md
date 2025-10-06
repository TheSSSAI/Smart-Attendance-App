# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-055 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor assigns an event to an entire team |
| As A User Story | As a Supervisor, I want to assign an event to one ... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Increases operational efficiency for managers by r... |
| Functional Area | Event Management |
| Story Theme | Team Scheduling and Coordination |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Supervisor assigns a new event to a single team

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a Supervisor is logged in and is on the 'Create Event' screen

### 3.1.5 When

the Supervisor selects one team they manage from the 'Assign to Teams' list and saves the event

### 3.1.6 Then

a new event document is created in Firestore with the selected team's ID in the 'assignedTeamIds' array

### 3.1.7 Validation Notes

Verify the Firestore document for the new event. Verify that members of the assigned team receive a push notification (dependency US-058) and can see the event on their calendar (dependency US-057).

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Supervisor assigns an event to multiple teams

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a Supervisor manages at least two teams ('Team A' and 'Team B')

### 3.2.5 When

the Supervisor creates an event and selects both 'Team A' and 'Team B' for assignment

### 3.2.6 Then

the created event document's 'assignedTeamIds' array contains the IDs for both 'Team A' and 'Team B'

### 3.2.7 Validation Notes

Check the Firestore event document to confirm both team IDs are present in the array.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Supervisor assigns an event to a team and an individual user

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

a Supervisor is creating an event and 'User Z' is not a member of 'Team A'

### 3.3.5 When

the Supervisor selects 'Team A' from the teams list and also selects 'User Z' from the individual user list

### 3.3.6 Then

the event document contains the ID for 'Team A' in 'assignedTeamIds' and the ID for 'User Z' in 'assignedUserIds'

### 3.3.7 Validation Notes

Verify that members of Team A and User Z all see the event. A user who is a member of Team A and also individually selected should only see the event once.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Supervisor only sees teams they manage

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

a Supervisor is logged in and another team ('Executive Team') exists which they do not manage

### 3.4.5 When

the Supervisor views the 'Assign to Teams' list on the event creation screen

### 3.4.6 Then

the 'Executive Team' is not visible in the list of options

### 3.4.7 Validation Notes

This must be enforced by Firestore Security Rules. Test by querying the 'teams' collection with the Supervisor's credentials; the query should only return teams they manage.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Supervisor with no assigned teams attempts to assign to a team

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

a user with the Supervisor role is not currently assigned as the supervisor of any team

### 3.5.5 When

they navigate to the 'Create Event' screen

### 3.5.6 Then

the UI for assigning to teams is either hidden or displays an informative message, such as 'You do not manage any teams.'

### 3.5.7 Validation Notes

Verify the UI state for a Supervisor user who has an empty list of managed teams.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Supervisor edits an event to add a team assignment

### 3.6.3 Scenario Type

Alternative_Flow

### 3.6.4 Given

an existing event is assigned only to individuals

### 3.6.5 When

a Supervisor edits the event and adds 'Team B' to the assignment

### 3.6.6 Then

the event document is updated to include 'Team B's ID in the 'assignedTeamIds' array, and members of 'Team B' are notified

### 3.6.7 Validation Notes

Verify that newly assigned team members can now see the event on their calendar.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A multi-select dropdown, chip group, or checkbox list labeled 'Assign to Teams' within the event creation/editing form.
- An empty state message for the 'Assign to Teams' component when the Supervisor manages no teams.

## 4.2.0 User Interactions

- The Supervisor can select one or more teams from the list.
- The Supervisor can de-select a team to remove it from the assignment.
- The list of teams should be searchable if it can become long.

## 4.3.0 Display Requirements

- The component must only display the names of teams for which the logged-in user is the designated supervisor.
- Selected teams should be clearly indicated visually.

## 4.4.0 Accessibility Needs

- The multi-select component must be keyboard-navigable and compatible with screen readers (e.g., proper labeling for checkboxes).

# 5.0.0 Business Rules

- {'rule_id': 'BR-001', 'rule_description': 'A Supervisor can only assign events to teams they directly supervise.', 'enforcement_point': 'Backend (Firestore Security Rules) during data query and Client-side during UI rendering.', 'violation_handling': 'The query for teams will return an empty set or a permissions error. The UI will not display unauthorized teams.'}

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-011

#### 6.1.1.2 Dependency Reason

The system must support the creation of teams and assignment of a Supervisor before events can be assigned to them.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-015

#### 6.1.2.2 Dependency Reason

Teams must have members for the team-based assignment to have any effect.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-052

#### 6.1.3.2 Dependency Reason

This story modifies the event creation flow, which must exist first.

### 6.1.4.0 Story Id

#### 6.1.4.1 Story Id

US-057

#### 6.1.4.2 Dependency Reason

The Subordinate's calendar view must be updated to resolve and display events assigned via team membership.

### 6.1.5.0 Story Id

#### 6.1.5.1 Story Id

US-058

#### 6.1.5.2 Dependency Reason

The push notification logic must be updated to resolve all members of an assigned team and send them notifications.

## 6.2.0.0 Technical Dependencies

- Finalized Firestore data model for 'events' and 'teams' collections, including 'assignedTeamIds' array on events.
- Implementation of Firestore Security Rules to restrict team queries by 'supervisorId'.

## 6.3.0.0 Data Dependencies

- Test data must include a Supervisor user who manages at least two teams with distinct members, and at least one team they do not manage.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The query to fetch the Supervisor's list of teams must complete in under 500ms.
- Saving an event assignment should not have a noticeable delay, regardless of the number of teams selected.

## 7.2.0.0 Security

- Access control must be strictly enforced via Firestore Security Rules to prevent a Supervisor from viewing or assigning events to teams they do not manage.

## 7.3.0.0 Usability

- The process of selecting a team should be intuitive and require minimal clicks.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The feature must function correctly on all supported mobile and web platforms as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires modification of downstream features: Subordinate calendar view (US-057) and push notifications (US-058).
- The logic for resolving team members for notifications must be efficient to avoid high Firestore read costs and function execution time.
- Careful implementation of Firestore Security Rules is critical for data segregation and security.

## 8.3.0.0 Technical Risks

- Inefficient implementation of the Subordinate's calendar query could lead to poor performance and high read costs as the number of teams and events grows.
- The notification fan-out logic could become slow or costly if a single event is assigned to many large teams.

## 8.4.0.0 Integration Points

- Firestore 'events' collection (write).
- Firestore 'teams' collection (read).
- Firebase Cloud Messaging (FCM) via a Cloud Function for notifications.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E
- Security

## 9.2.0.0 Test Scenarios

- Verify a Supervisor can assign an event to one team.
- Verify a Supervisor can assign an event to multiple teams.
- Verify a Supervisor cannot see or select teams they do not manage.
- Verify a Subordinate in an assigned team sees the event on their calendar.
- Verify a Subordinate NOT in an assigned team does NOT see the event.
- Verify editing an event to add/remove a team assignment works correctly.

## 9.3.0.0 Test Data Needs

- A tenant with at least 3 users: 1 Supervisor, 2 Subordinates.
- At least 2 teams, both managed by the Supervisor.
- At least 1 team NOT managed by the Supervisor.
- Subordinates assigned to different teams.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for local development and integration testing.
- Jest for Cloud Functions unit tests.
- flutter_test for widget tests.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for UI logic and Cloud Functions, achieving >80% coverage
- Integration testing for Firestore rules and data flow completed successfully
- End-to-end test scenario (Supervisor assigns, Subordinate views) is passing
- User interface reviewed and approved by UX/Product Owner
- Performance requirements for team list loading are verified
- Security requirements validated via manual and automated tests
- Supervisor Guide documentation is updated to include this feature
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story has dependencies on several other stories and should be scheduled accordingly.
- Requires coordinated effort between frontend (Flutter) and backend (Cloud Functions, Firestore Rules) developers.
- Should be planned in a sprint that also includes updates to US-057 and US-058 to deliver a complete feature.

## 11.4.0.0 Release Impact

This is a core feature for the Supervisor role and a key efficiency improvement. It is a high-value item for the release.

