# 1 Diagram Info

## 1.1 Diagram Name

User Authentication Flow

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

To document the end-to-end user authentication process, including login method selection, credential/OTP validation, user status checks, and role-based redirection.

## 1.4 Target Audience

- developers
- QA engineers
- product managers

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3-5 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph "Start: Login Screen"
  ... |
| Syntax Validation | Mermaid syntax verified and tested |
| Rendering Notes | Optimized for both light and dark themes using def... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- User
- Frontend Application (Mobile/Web)
- Backend (Firebase Auth, Firestore, Cloud Functions)

## 3.2 Key Processes

- Credential Validation
- OTP Verification
- User Status Check
- Role-Based Routing

## 3.3 Decision Points

- Login Method Selection
- Credential Validity
- Phone Number Registration
- OTP Validity
- User Status (active, deactivated, invited)
- User Role & Platform

## 3.4 Success Paths

- User successfully logs in with email/password or phone OTP and is redirected to their correct dashboard.

## 3.5 Error Scenarios

- Invalid email or password
- Account lockout due to brute-force attempts
- Unregistered phone number
- Invalid or expired OTP
- Login attempt by a deactivated user
- Login attempt by a user with a misconfigured role

## 3.6 Edge Cases Covered

- Non-admin user attempting to log into the web dashboard
- A newly invited user logging in before completing registration/ToS acceptance

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the user authentication proc... |
| Color Independence | Information is conveyed through branching paths an... |
| Screen Reader Friendly | All nodes have descriptive text labels that explai... |
| Print Compatibility | Diagram renders clearly in black and white, though... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Scales appropriately for mobile and desktop viewin... |
| Theme Compatibility | Works with default, dark, and custom themes by lev... |
| Performance Notes | The diagram is of medium complexity and should ren... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development of authentication features, QA test case creation, and product reviews of the user onboarding and login journeys.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear map of the required logic, state ... |
| Designers | Validates the user experience flow and ensures all... |
| Product Managers | Offers a comprehensive overview of the primary use... |
| Qa Engineers | Serves as a definitive source for creating a compl... |

## 6.3 Maintenance Notes

Update this diagram if new login methods are added, user statuses change, or the role-based redirection logic is modified.

## 6.4 Integration Recommendations

Embed this diagram in the main technical design document for authentication and link to it from relevant user stories (e.g., US-017, US-018, US-021).

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

