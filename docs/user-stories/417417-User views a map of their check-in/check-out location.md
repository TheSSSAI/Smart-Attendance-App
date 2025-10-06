# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-075 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User views a map of their check-in/check-out locat... |
| As A User Story | As a User (Subordinate, Supervisor, or Admin), I w... |
| User Persona | Any authenticated user (Subordinate, Supervisor, A... |
| Business Value | Increases user trust and data transparency by prov... |
| Functional Area | Attendance Management |
| Story Theme | User Experience and Data Visualization |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Display map with both check-in and check-out locations

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

a user is viewing the details of an attendance record that has valid GPS coordinates for both check-in and check-out

### 3.1.5 When

the attendance detail screen loads

### 3.1.6 Then

a map component is displayed, showing two distinct, clearly labeled pins for the check-in and check-out locations, and the map is zoomed and centered to encompass both pins.

### 3.1.7 Validation Notes

Verify that two pins are visible. The check-in pin could be green and the check-out pin red for clarity. The map view should be interactive (pannable and zoomable).

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Display map with only a check-in location

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

a user is viewing the details of an attendance record that has valid GPS coordinates for check-in but has not yet been checked-out

### 3.2.5 When

the attendance detail screen loads

### 3.2.6 Then

a map component is displayed, showing a single pin for the check-in location, and the map is centered on this pin at a reasonable default zoom level.

### 3.2.7 Validation Notes

Verify only one pin is displayed and the map is centered on it.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

User interacts with a location pin

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

a map is displayed with one or more location pins

### 3.3.5 When

the user taps on a pin

### 3.3.6 Then

an info window appears above the pin, displaying the action type ('Check-In' or 'Check-Out') and the corresponding timestamp from the attendance record.

### 3.3.7 Validation Notes

Tap each pin type and verify the correct information is displayed in the info window.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Attendance record has no location data

### 3.4.3 Scenario Type

Edge_Case

### 3.4.4 Given

a user is viewing an attendance record where the GPS data is null or missing

### 3.4.5 When

the attendance detail screen loads

### 3.4.6 Then

the map component is not displayed, and a user-friendly message, such as 'Location data not available for this record', is shown in its place.

### 3.4.7 Validation Notes

Test with a Firestore document where the `checkInGps` field is null or absent. The app should not crash.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Device is offline when viewing the map

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

the user's device has no active internet connection

### 3.5.5 When

the user navigates to an attendance detail screen with valid GPS data

### 3.5.6 Then

the map area displays a placeholder with a message like 'Map cannot be loaded. Please check your internet connection.' and the application does not crash.

### 3.5.7 Validation Notes

Enable airplane mode on the device and navigate to the screen. Verify the graceful failure message.

## 3.6.0 Criteria Id

### 3.6.1 Criteria Id

AC-006

### 3.6.2 Scenario

Map service API fails

### 3.6.3 Scenario Type

Error_Condition

### 3.6.4 Given

the Google Maps API service is unavailable or the API key is invalid

### 3.6.5 When

the user navigates to an attendance detail screen

### 3.6.6 Then

the map area displays a generic error message, such as 'Map service is temporarily unavailable.'

### 3.6.7 Validation Notes

This can be simulated by using an invalid API key during testing. The app must handle the API error without crashing.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- Embedded map view component within the attendance detail screen.
- Custom map pins/markers for 'Check-In' and 'Check-Out'.
- Info window/tooltip that appears on pin tap.
- Placeholder text area for error states (no data, no network).

## 4.2.0 User Interactions

- User can pan and zoom the map using standard touch gestures.
- Tapping a pin reveals more information.
- Tapping the map background dismisses the info window.

## 4.3.0 Display Requirements

- The map must clearly distinguish between check-in and check-out locations.
- The info window must display the action type and timestamp.

## 4.4.0 Accessibility Needs

- Color contrast for map pins and labels must be sufficient (WCAG 2.1 AA).
- Text within info windows must be readable by screen readers.
- The map component should have a descriptive label for screen readers, e.g., 'Map showing check-in and check-out locations.'

# 5.0.0 Business Rules

*No items available*

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

This story depends on the functionality to capture and store GPS coordinates upon check-in.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-029

#### 6.1.2.2 Dependency Reason

This story depends on the functionality to capture and store GPS coordinates upon check-out.

## 6.2.0.0 Technical Dependencies

- Integration with the Google Maps SDK for Flutter (`google_maps_flutter` package).
- Valid Google Maps API keys for both Android and iOS platforms, configured securely.
- Firestore SDK for retrieving attendance records with GeoPoint data.

## 6.3.0.0 Data Dependencies

- Requires access to the `/attendance/{recordId}` collection in Firestore.
- Depends on the `checkInGps` and `checkOutGps` fields being stored as Firestore `GeoPoint` data types.

## 6.4.0.0 External Dependencies

- Availability and correct functioning of the Google Maps Platform services.

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The map component, with pins, should load and render within 2 seconds on a stable 4G/Wi-Fi connection.
- Map interactions (panning, zooming) must be smooth and maintain at least 60 fps.

## 7.2.0.0 Security

- Google Maps API keys must be stored securely and not exposed in client-side code or committed to version control.
- API keys must be restricted in the Google Cloud Console to the application's specific package name (Android) and bundle ID (iOS) to prevent unauthorized use.

## 7.3.0.0 Usability

- The map's default zoom level should provide sufficient geographical context without requiring the user to immediately zoom out.
- Error messages must be clear, user-friendly, and non-technical.

## 7.4.0.0 Accessibility

- Must comply with WCAG 2.1 Level AA standards where applicable (color contrast, screen reader support for text elements).

## 7.5.0.0 Compatibility

- The map functionality must be verified on all supported OS versions: Android 6.0+ and iOS 12.0+.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires native configuration for both Android and iOS to integrate the Google Maps SDK.
- Secure management and configuration of API keys.
- Handling multiple map states (loading, success with one/two pins, no data, network error, API error).
- Potential for performance issues (memory leaks) if the map view lifecycle is not managed correctly.

## 8.3.0.0 Technical Risks

- Exceeding the Google Maps API free tier, leading to unexpected costs. Usage must be monitored.
- API key leakage could result in fraudulent use and high bills.
- Platform-specific bugs or limitations in the Flutter mapping package.

## 8.4.0.0 Integration Points

- Google Maps Platform (Maps SDK for Android, Maps SDK for iOS).
- Firebase Firestore for data retrieval.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- E2E
- Performance
- Accessibility

## 9.2.0.0 Test Scenarios

- Verify map with one pin (check-in only).
- Verify map with two pins (check-in and check-out).
- Verify info window content on pin tap.
- Verify UI state when GPS data is null.
- Verify UI state when the device is offline.
- Verify smooth panning and zooming on a physical device.

## 9.3.0.0 Test Data Needs

- Firestore documents with both `checkInGps` and `checkOutGps` as valid GeoPoints.
- Firestore documents with only `checkInGps`.
- Firestore documents with null or missing `checkInGps` field.
- Coordinates that are geographically close and far apart.

## 9.4.0.0 Testing Tools

- `flutter_test` for unit and widget tests (using a mocked map controller).
- `integration_test` for on-device E2E testing.
- Firebase Local Emulator Suite for testing against a local Firestore instance.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by at least one other developer
- Unit and widget tests implemented with >80% coverage for new logic
- E2E integration testing completed successfully on both Android and iOS physical devices
- User interface reviewed and approved by the Product Owner/Designer
- Performance requirements (map load time) verified
- Security review of API key handling completed
- Documentation for map component usage updated in the developer wiki
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- Requires setup of Google Maps API keys in the GCP project before development can begin.
- Requires testing on physical devices to accurately assess performance and user interaction.

## 11.4.0.0 Release Impact

Enhances a core feature by improving usability and transparency. It is a high-value improvement for the user experience but not a blocker for an initial release.

