# 1 Diagram Info

## 1.1 Diagram Name

New Tenant & Initial Admin Registration Flow

## 1.2 Diagram Type

sequenceDiagram

## 1.3 Purpose

To detail the complete, atomic server-side process for registering a new organization and its first Admin user. This includes form submission, validation, data creation across multiple services (Authentication and Firestore), setting of security claims, and failure compensation logic (rollback).

## 1.4 Target Audience

- developers
- QA engineers
- system architects

## 1.5 Complexity Level

high

## 1.6 Estimated Review Time

3 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | sequenceDiagram
    actor User
    participant Reg... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for both light and dark themes. The 'alt... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- User
- Registration UI (Web)
- registerOrganization (Callable Function)
- Firestore Database
- Firebase Authentication

## 3.2 Key Processes

- Organization name uniqueness validation
- Firebase Auth user creation
- Atomic creation of Firestore documents (Tenant, User) via transaction
- Setting custom claims (role, tenantId) for RBAC
- Compensation logic (rollback) on failure

## 3.3 Decision Points

- Is organization name unique?
- Did Firestore transaction succeed?
- Did setting custom claims succeed?

## 3.4 Success Paths

- User submits valid, unique data, all backend operations succeed, and user is redirected to the dashboard.

## 3.5 Error Scenarios

- Organization name is already taken.
- Firebase Auth user creation fails.
- Firestore transaction fails.
- Setting custom claims fails.

## 3.6 Edge Cases Covered

- The diagram explicitly shows the rollback/compensation logic required to maintain data consistency, preventing orphaned user accounts or tenant documents if any step in the multi-service process fails.

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A sequence diagram illustrating the new organizati... |
| Color Independence | Information is conveyed through sequence and text ... |
| Screen Reader Friendly | All participants and interactions have descriptive... |
| Print Compatibility | Diagram renders clearly in black and white. |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Standard MermaidJS responsive scaling for various ... |
| Theme Compatibility | Works with default, dark, and neutral themes witho... |
| Performance Notes | The diagram is of moderate complexity but should r... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During backend development of the `registerOrganization` Cloud Function, for security reviews of the onboarding process, and by QA engineers creating test plans for user registration.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear, step-by-step implementation guid... |
| Designers | Validates the user flow and helps understand syste... |
| Product Managers | Confirms the business logic for tenant creation an... |
| Qa Engineers | Defines all success and failure paths that need to... |

## 6.3 Maintenance Notes

Update this diagram if any new steps are added to the registration flow or if the data model for tenants/users changes significantly.

## 6.4 Integration Recommendations

Embed this diagram directly in the technical documentation for the User Onboarding epic and link to it from relevant user stories (e.g., US-001).

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

