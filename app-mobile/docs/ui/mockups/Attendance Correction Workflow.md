# 1 Diagram Info

## 1.1 Diagram Name

Attendance Correction Workflow

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

To visualize the end-to-end business process for a Subordinate requesting a correction to their attendance record, and the subsequent review, decision, and notification flow handled by the Supervisor.

## 1.4 Target Audience

- developers
- QA engineers
- product managers
- business analysts

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3-5 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph Subordinate Actions
    ... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for top-to-bottom flow, separating actio... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- Subordinate (Mobile App)
- Supervisor (Mobile App)
- Firestore Database
- Cloud Functions (Backend)
- Audit Log Service
- Notification Service (FCM)

## 3.2 Key Processes

- Request Submission
- State Transition to 'correction_pending'
- Supervisor Review
- Approval Logic
- Rejection Logic
- Audit Logging
- User Notification

## 3.3 Decision Points

- Form Validation (Justification)
- Supervisor's Approve/Reject Decision

## 3.4 Success Paths

- Request is submitted and subsequently approved, updating the record.
- Request is submitted and subsequently rejected, reverting the record.

## 3.5 Error Scenarios

- Invalid submission due to missing or short justification.

## 3.6 Edge Cases Covered

- The full workflow from request initiation by a subordinate to the final decision and notification.
- Mandatory reason for rejection is included as a distinct step.

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the attendance correction wo... |
| Color Independence | Information is conveyed through node shapes (recta... |
| Screen Reader Friendly | All nodes have descriptive text labels that explai... |
| Print Compatibility | Diagram uses distinct shapes and text, making it u... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | The vertical layout is well-suited for both wide a... |
| Theme Compatibility | Node styling is defined via classes, allowing for ... |
| Performance Notes | The diagram is of medium complexity and should ren... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During feature development for the attendance correction workflow (US-045 through US-049), for QA test case creation, and for onboarding new developers to this part of the system.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear, high-level overview of the busin... |
| Designers | Validates the user flow and identifies all necessa... |
| Product Managers | Confirms that the implemented flow correctly match... |
| Qa Engineers | Serves as a blueprint for creating end-to-end test... |

## 6.3 Maintenance Notes

Update this diagram if the states of an attendance record change, if new roles can action a correction, or if the side-effects (like auditing) are modified.

## 6.4 Integration Recommendations

Embed this diagram in the main technical design document for the Attendance Management feature and link to it from relevant user stories (US-045, US-047, US-048).

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

