# 1 Diagram Info

## 1.1 Diagram Name

User Login and Initial Routing Flow

## 1.2 Diagram Type

flowchart

## 1.3 Purpose

Documents the primary entry path for all mobile users, covering login variations (email/password, OTP), initial policy acceptance for new users, and redirection to role-specific dashboards.

## 1.4 Target Audience

- developers
- QA engineers
- product managers
- system architects

## 1.5 Complexity Level

medium

## 1.6 Estimated Review Time

3-5 minutes

# 2.0 Mermaid Implementation

| Property | Value |
|----------|-------|
| Mermaid Code | flowchart TD
    subgraph "Authentication Flow"
  ... |
| Syntax Validation | Mermaid syntax verified and renders correctly. |
| Rendering Notes | Optimized for readability with distinct colors for... |

# 3.0 Diagram Elements

## 3.1 Actors Systems

- User
- Mobile Application
- Firebase Authentication
- Firestore Database

## 3.2 Key Processes

- Credential Validation
- OTP Verification
- User Status Check
- Role-Based Routing

## 3.3 Decision Points

- Login Method
- Credential Validity
- OTP Validity
- User Status
- User Role

## 3.4 Success Paths

- Successful login via email/password to role-specific dashboard
- Successful login via OTP to role-specific dashboard

## 3.5 Error Scenarios

- Invalid email/password
- Invalid/Expired OTP
- Account Deactivated
- Account not yet activated ('Invited')

## 3.6 Edge Cases Covered

- Admin attempting to log in on mobile
- User closes app before accepting Terms of Service

# 4.0 Accessibility Considerations

| Property | Value |
|----------|-------|
| Alt Text | A flowchart detailing the user login process. It s... |
| Color Independence | Information is conveyed through labeled nodes and ... |
| Screen Reader Friendly | All nodes have clear, descriptive text labels. |
| Print Compatibility | Diagram uses simple shapes and lines, rendering cl... |

# 5.0 Technical Specifications

| Property | Value |
|----------|-------|
| Mermaid Version | 10.0+ compatible |
| Responsive Behavior | Scales appropriately for mobile and desktop viewin... |
| Theme Compatibility | Works with default, dark, and custom themes using ... |
| Performance Notes | Diagram is of medium complexity and should render ... |

# 6.0 Usage Guidelines

## 6.1 When To Reference

During development of authentication, onboarding, and routing features. Also used by QA for creating test plans for the login and initial app experience.

## 6.2 Stakeholder Value

| Property | Value |
|----------|-------|
| Developers | Provides a clear, step-by-step implementation guid... |
| Designers | Validates the user flow and ensures all states (lo... |
| Product Managers | Offers a comprehensive overview of the application... |
| Qa Engineers | Defines all possible paths, including error and ed... |

## 6.3 Maintenance Notes

Update this diagram if new login methods are added, the user status lifecycle changes, or new roles are introduced.

## 6.4 Integration Recommendations

Embed this diagram in the main authentication feature documentation, relevant user stories (US-017, US-018, US-021), and the technical design document.

# 7.0 Validation Checklist

- ✅ All critical user paths documented
- ✅ Error scenarios and recovery paths included
- ✅ Decision points clearly marked with conditions
- ✅ Mermaid syntax validated and renders correctly
- ✅ Diagram serves intended audience needs
- ✅ Visual hierarchy supports easy comprehension
- ✅ Styling enhances rather than distracts from content
- ✅ Accessible to users with different visual abilities

