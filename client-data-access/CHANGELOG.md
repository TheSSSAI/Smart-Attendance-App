# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release of the `client_data_access` package.
- Implemented Repository Pattern for Clean Architecture data layer.
- Added repositories for Authentication, User, Team, Event, and Attendance.
- Encapsulated all Firebase SDK interactions (Firestore, Auth, Functions).
- Included support for Firestore's offline persistence.
- Implemented robust error handling using `fpdart`'s `Either` type.