# 1 Diagram Info

## 1.1 Diagram Name

New Tenant Registration Flow

## 1.2 Diagram Type

sequenceDiagram

## 1.3 Purpose

To visualize the end-to-end process a new prospective admin goes through to register their organization, create a new tenant, and establish their admin account. This includes validation, data creation, and security claim setup.

## 1.4 Target Audience

- developers
- product managers
- QA engineers
- security analysts

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | sequenceDiagram
    actor User
    participant Adm... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | The diagram illustrates a happy path with alternat... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- User
- AdminWebDashboard
- UniquenessCheckFN (Cloud Function)
- RegisterOrgFN (Cloud Function)
- Firebase Auth
- Firestore Database

## 3.2 Key Processes

- Asynchronous organization name validation
- Atomic creation of Auth user, Tenant, and Firestore user
- Setting of custom claims for RBAC
- Compensation logic for failed transactions

## 3.3 Decision Points

- Is organization name available?
- Does the backend transaction succeed?

## 3.4 Success Paths

- User provides a unique org name, registers, and is redirected to their dashboard.

## 3.5 Error Scenarios

- User provides a duplicate organization name.
- The backend transaction fails, requiring rollback of the created Auth user.

## 3.6 Edge Cases Covered

- Race conditions for tenant creation are implicitly handled by the backend transaction.
- Ensuring no orphaned user accounts if part of the process fails.

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A sequence diagram detailing the new organization ... |
| Color Independence | The diagram uses standard sequence diagram notatio... |
| Screen Reader Friendly | All participants and interactions have descriptive... |
| Print Compatibility | The diagram is clear and legible in black and whit... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Diagram scales horizontally and is readable on var... |
| Theme Compatibility | Works with default, dark, and neutral themes. |
| Performance Notes | Diagram is of medium complexity and should render ... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development of the tenant registration feature (US-001, US-002), for security reviews of the onboarding process, and for creating QA test plans.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear blueprint for the interaction bet... |
| Designers | Validates the user flow and identifies points wher... |
| Product Managers | Outlines the complete registration funnel and the ... |
| Qa Engineers | Defines the end-to-end test case for the happy pat... |

## 6.3 Maintenance Notes

Update this diagram if the registration process changes, such as adding more validation steps or integrating with a payment provider.

## 6.4 Integration Recommendations

Embed in the technical design document for the tenant onboarding epic and link directly from the relevant user stories (US-001, US-002).

# 7.0 Validation Checklist

- ✅ User journey from form fill to dashboard is documented.
- ✅ Error scenarios for unique name validation and backend failure are included.
- ✅ Decision points are clearly marked with `alt` blocks.
- ✅ Mermaid syntax is validated and renders correctly.
- ✅ The diagram clearly serves developers, PMs, and QA.
- ✅ The sequence of interactions is logical and easy to follow.
- ✅ The use of a note clarifies the critical compensation logic.
- ✅ The diagram is accessible and does not rely on color for meaning.

