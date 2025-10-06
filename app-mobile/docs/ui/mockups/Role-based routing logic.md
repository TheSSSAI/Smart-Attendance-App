# 1 Diagram Info

## 1.1 Diagram Name

Role-based routing logic

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

To visually document the application's logic for routing a user to the correct dashboard based on their assigned role and the platform they are using (Web vs. Mobile) immediately after successful authentication.

## 1.4 Target Audience

- developers
- QA engineers
- product managers
- system architects

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph Post-Authentication Flow... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for clarity with distinct colors for pro... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- Authenticated User
- Client Application (Web/Mobile)
- Authentication Service (providing JWT)

## 3.2 Key Processes

- Inspect JWT Custom Claims
- Check Platform (Web/Mobile)
- Redirect/Navigate User

## 3.3 Decision Points

- What is the user's role?
- What platform is the user on?

## 3.4 Success Paths

- Admin on any platform is routed to the Admin Web Dashboard.
- Supervisor on Mobile is routed to the Supervisor Mobile Dashboard.
- Subordinate on Mobile is routed to the Subordinate Mobile Dashboard.

## 3.5 Error Scenarios

- User's role claim is missing or invalid, leading to logout.
- Supervisor/Subordinate attempts to access the Web platform and is blocked.

## 3.6 Edge Cases Covered

- Routing for all three defined roles.
- Handling of users attempting to use the wrong platform for their role.

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the post-login routing logic... |
| Color Independence | Information is conveyed through branching paths an... |
| Screen Reader Friendly | All nodes and decision points have descriptive tex... |
| Print Compatibility | Diagram uses distinct shapes and clear text, makin... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | The flowchart scales down for smaller viewports, m... |
| Theme Compatibility | Styling uses class definitions, making it adaptabl... |
| Performance Notes | Low-complexity diagram with fast rendering time. |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development or testing of the authentication and authorization flow, specifically when implementing the logic from US-021.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear blueprint for implementing the cl... |
| Designers | Validates the user journey for different roles imm... |
| Product Managers | Confirms the expected behavior and access rules fo... |
| Qa Engineers | Defines the exact test cases needed to validate al... |

## 6.3 Maintenance Notes

Update this diagram if new roles are added or if access rules for platforms change (e.g., if a Supervisor gets a web view).

## 6.4 Integration Recommendations

Embed this diagram directly in the user story (US-021) documentation and in the technical documentation for the authentication module.

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

