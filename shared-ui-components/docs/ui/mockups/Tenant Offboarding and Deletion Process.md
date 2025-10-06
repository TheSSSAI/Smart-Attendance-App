# 1 Diagram Info

## 1.1 Diagram Name

Tenant Offboarding and Deletion Process

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

To visually document the complete end-to-end lifecycle for tenant offboarding, from the initial Admin request through the 30-day grace period to the final, automated, and irreversible data deletion.

## 1.4 Target Audience

- developers
- product managers
- QA engineers
- system architects

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3-5 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph Admin Action in Web Dash... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for both light and dark themes. Uses sub... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- Admin User
- Admin Web Dashboard
- Backend Service (Cloud Functions)
- Firestore Database
- Cloud Scheduler

## 3.2 Key Processes

- Re-authentication for destructive action
- Tenant status change to 'pending_deletion'
- Grace period implementation
- Cancellation workflow
- Scheduled, automated data deletion

## 3.3 Decision Points

- Password validation
- Admin choice to cancel during grace period
- Scheduled job query for expired tenants

## 3.4 Success Paths

- Successful initiation of deletion process
- Successful cancellation of deletion process
- Successful automated deletion after grace period

## 3.5 Error Scenarios

- Incorrect password during re-authentication

## 3.6 Edge Cases Covered

- User does nothing and lets the grace period expire
- User cancels the deletion process

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the tenant offboarding proce... |
| Color Independence | Information is conveyed through labels and flow, n... |
| Screen Reader Friendly | All nodes and decision points have clear, descript... |
| Print Compatibility | Diagram renders clearly in black and white, mainta... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Diagram scales appropriately for different screen ... |
| Theme Compatibility | Works with default, dark, and neutral themes. Cust... |
| Performance Notes | The diagram is of medium complexity and should ren... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development of the tenant deletion feature, for QA test plan creation, and for architectural reviews of the offboarding process.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear sequence of UI, backend function ... |
| Designers | Validates the user flow and identifies all necessa... |
| Product Managers | Visualizes the entire feature, including safety ne... |
| Qa Engineers | Defines all paths that need to be tested, includin... |

## 6.3 Maintenance Notes

Update this diagram if the duration of the grace period changes, if the re-authentication logic is modified, or if the scheduled job's behavior is altered.

## 6.4 Integration Recommendations

Embed in the technical design document for the tenant lifecycle feature and link from relevant user stories (US-022, US-023, US-024, US-025).

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

