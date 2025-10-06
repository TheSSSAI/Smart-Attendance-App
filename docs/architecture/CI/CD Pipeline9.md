# 1 Pipelines

## 1.1 Flutter Client CI/CD Pipeline

### 1.1.1 Id

flutter-client-pipeline-001

### 1.1.2 Name

Flutter Client CI/CD Pipeline

### 1.1.3 Description

Builds, tests, and deploys the Flutter mobile (iOS/Android) and web applications to Staging and Production environments. This pipeline enforces quality and security checks as per system requirements.

### 1.1.4 Stages

#### 1.1.4.1 Build and Analyze

##### 1.1.4.1.1 Name

Build and Analyze

##### 1.1.4.1.2 Steps

- flutter pub get
- flutter analyze --fatal-infos
- flutter test --coverage

##### 1.1.4.1.3 Environment

###### 1.1.4.1.3.1 Flutter Version

3.x

###### 1.1.4.1.3.2 Dart Version

3.x

##### 1.1.4.1.4.0 Quality Gates

- {'name': 'Code Quality and Coverage Check', 'criteria': ['static analysis passes with zero fatal issues', 'unit and widget test coverage >= 80%'], 'blocking': True}

#### 1.1.4.2.0.0 Dependency Security Scan

##### 1.1.4.2.1.0 Name

Dependency Security Scan

##### 1.1.4.2.2.0 Steps

- Run Dart dependency vulnerability scan
- Report vulnerabilities

##### 1.1.4.2.3.0 Environment

###### 1.1.4.2.3.1 Fail On Severity

critical

##### 1.1.4.2.4.0 Quality Gates

- {'name': 'Vulnerability Check', 'criteria': ['zero critical CVEs in dependencies'], 'blocking': True}

#### 1.1.4.3.0.0 Build Release Artifacts

##### 1.1.4.3.1.0 Name

Build Release Artifacts

##### 1.1.4.3.2.0 Steps

- flutter build appbundle --release
- flutter build ipa --release
- flutter build web --release

##### 1.1.4.3.3.0 Environment

###### 1.1.4.3.3.1 Android Keystore Secret

${{ secrets.ANDROID_KEYSTORE }}

###### 1.1.4.3.3.2 Ios Provisioning Profile

${{ secrets.IOS_PROVISIONING_PROFILE }}

#### 1.1.4.4.0.0 Deploy to Staging

##### 1.1.4.4.1.0 Name

Deploy to Staging

##### 1.1.4.4.2.0 Steps

- firebase deploy --project staging-project-id --only hosting:staging-site
- Upload Android App Bundle to Google Play Internal Testing
- Upload iOS IPA to TestFlight

##### 1.1.4.4.3.0 Environment

###### 1.1.4.4.3.1 Firebase Token

${{ secrets.FIREBASE_TOKEN_STAGING }}

##### 1.1.4.4.4.0 Quality Gates

- {'name': 'Staging/UAT Manual Approval', 'criteria': ['Manual sign-off from QA and Product teams after validation on Staging'], 'blocking': True}

#### 1.1.4.5.0.0 Deploy to Production

##### 1.1.4.5.1.0 Name

Deploy to Production

##### 1.1.4.5.2.0 Steps

- firebase deploy --project production-project-id --only hosting:production-site
- Promote Android build to Production with staged rollout (10%)
- Submit iOS build from TestFlight for App Store Review

##### 1.1.4.5.3.0 Environment

| Property | Value |
|----------|-------|
| Firebase Token | ${{ secrets.FIREBASE_TOKEN_PRODUCTION }} |
| Google Play Credentials | ${{ secrets.GOOGLE_PLAY_CREDENTIALS }} |
| App Store Connect Api Key | ${{ secrets.APP_STORE_CONNECT_API_KEY }} |

## 1.2.0.0.0.0 Firebase Backend CI/CD Pipeline

### 1.2.1.0.0.0 Id

firebase-backend-pipeline-002

### 1.2.2.0.0.0 Name

Firebase Backend CI/CD Pipeline

### 1.2.3.0.0.0 Description

Deploys Firebase backend resources including Cloud Functions, Firestore Rules, and Indexes using an Infrastructure as Code approach, as required by REQ-NFR-006.

### 1.2.4.0.0.0 Stages

#### 1.2.4.1.0.0 Build and Analyze Functions

##### 1.2.4.1.1.0 Name

Build and Analyze Functions

##### 1.2.4.1.2.0 Steps

- cd functions
- npm install
- npm run lint
- npm run test
- npm run build

##### 1.2.4.1.3.0 Environment

###### 1.2.4.1.3.1 Node Version

18.x

##### 1.2.4.1.4.0 Quality Gates

- {'name': 'Backend Code Quality', 'criteria': ['ESLint passes with zero errors', 'All unit tests pass'], 'blocking': True}

#### 1.2.4.2.0.0 Dependency Security Scan

##### 1.2.4.2.1.0 Name

Dependency Security Scan

##### 1.2.4.2.2.0 Steps

- cd functions
- npm audit --audit-level=critical

##### 1.2.4.2.3.0 Environment

*No data available*

##### 1.2.4.2.4.0 Quality Gates

- {'name': 'NPM Vulnerability Check', 'criteria': ['zero critical CVEs in npm dependencies'], 'blocking': True}

#### 1.2.4.3.0.0 Deploy to Staging

##### 1.2.4.3.1.0 Name

Deploy to Staging

##### 1.2.4.3.2.0 Steps

- firebase use staging-project-id
- firebase deploy --only functions,firestore:rules,firestore:indexes

##### 1.2.4.3.3.0 Environment

###### 1.2.4.3.3.1 Firebase Token

${{ secrets.FIREBASE_TOKEN_STAGING }}

##### 1.2.4.3.4.0 Quality Gates

- {'name': 'Staging Manual Approval', 'criteria': ['Manual sign-off from backend lead after successful integration tests against the staged client'], 'blocking': True}

#### 1.2.4.4.0.0 Deploy to Production

##### 1.2.4.4.1.0 Name

Deploy to Production

##### 1.2.4.4.2.0 Steps

- firebase use production-project-id
- firebase deploy --only functions,firestore:rules,firestore:indexes

##### 1.2.4.4.3.0 Environment

###### 1.2.4.4.3.1 Firebase Token

${{ secrets.FIREBASE_TOKEN_PRODUCTION }}

# 2.0.0.0.0.0 Configuration

| Property | Value |
|----------|-------|
| Artifact Repository | GitHub Actions Artifacts |
| Default Branch | main |
| Retention Policy | 90d |
| Notification Channel | slack#build-and-deploy-alerts |

