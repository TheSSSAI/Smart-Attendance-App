# 1 Diagram Info

## 1.1 Diagram Name

User Authentication and Routing Flow

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

To visualize the complete user journey from the login screen to their role-specific dashboard, covering all authentication methods, security checks, and routing logic.

## 1.4 Target Audience

- developers
- QA engineers
- product managers

## 1.5 Complexity Level

high

## 1.6 Estimated Review Time

5-7 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph "User Journey Start"
   ... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for both light and dark themes. Uses Fon... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- User
- Frontend (Mobile/Web)
- Backend (Firebase Auth, Cloud Functions, Firestore)

## 3.2 Key Processes

- Credential Validation
- OTP Verification
- User Status Check
- ToS Acceptance
- Role-based Routing

## 3.3 Decision Points

- Login Method
- Credential Validity
- Lockout Status
- User Status (Active/Deactivated)
- ToS Accepted?
- User Role
- Platform (Web/Mobile)

## 3.4 Success Paths

- Successful Email/Pass login to dashboard
- Successful OTP login to dashboard

## 3.5 Error Scenarios

- Invalid credentials
- Account lockout
- Unregistered phone
- Invalid OTP
- Deactivated account
- Invalid role
- Non-Admin login on web

## 3.6 Edge Cases Covered

- First-time login requiring ToS acceptance
- Login with invalid role claim

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the user authentication proc... |
| Color Independence | Information conveyed through node shapes, icons, a... |
| Screen Reader Friendly | All nodes have descriptive text labels suitable fo... |
| Print Compatibility | Diagram renders clearly in black and white, though... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Scales appropriately for mobile and desktop viewin... |
| Theme Compatibility | Works with default, dark, and custom themes using ... |
| Performance Notes | Diagram complexity is moderate; rendering should b... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development and QA of the authentication, onboarding, and routing features. Useful for new developers to understand the core login flow.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear map of all required logic, states... |
| Designers | Validates the user experience and ensures all stat... |
| Product Managers | Offers a comprehensive overview of the user's firs... |
| Qa Engineers | Serves as a complete checklist for test case creat... |

## 6.3 Maintenance Notes

Update this diagram if new authentication methods are added, security checks are modified, or post-login routing logic changes.

## 6.4 Integration Recommendations

Embed in the main technical design document for authentication and link directly from relevant user stories (US-017, US-018, US-021, US-026, etc.).

# 7.0 Validation Checklist

- ✅ All critical user paths documented (Email, OTP, ToS)
- ✅ Error scenarios and recovery paths included (Lockout, Invalid, Deactivated)
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs (Dev, QA, PM)
- ✅ Visual hierarchy supports easy comprehension through subgraphs
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities through descriptive labels

