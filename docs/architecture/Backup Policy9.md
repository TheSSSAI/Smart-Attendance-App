# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Technology Stack

- Flutter
- Firebase (Cloud Functions, Firestore, Hosting)
- TypeScript
- Node.js
- GitHub Actions

## 1.3 Architecture Style

Serverless IaC-managed Backend with Cross-Platform Client

# 2.0 Pipelines

## 2.1 Firebase Backend CI/CD Pipeline

### 2.1.1 Id

firebase-backend-pipeline

### 2.1.2 Name

Firebase Backend CI/CD Pipeline

### 2.1.3 Description

Handles continuous integration and deployment for all server-side Firebase resources, including Cloud Functions (TypeScript), Firestore Security Rules, and Indexes. This pipeline is managed as Infrastructure as Code (IaC) as per REQ-1-072.

### 2.1.4 Triggers

#### 2.1.4.1 Event

##### 2.1.4.1.1 Event

push

##### 2.1.4.1.2 Branches

- main
- staging

##### 2.1.4.1.3 Paths

- functions/**
- firestore.rules
- firestore.indexes.json

#### 2.1.4.2.0 Event

##### 2.1.4.2.1 Event

pull_request

##### 2.1.4.2.2 Branches

- main
- staging

##### 2.1.4.2.3 Paths

- functions/**
- firestore.rules
- firestore.indexes.json

### 2.1.5.0.0 Jobs

#### 2.1.5.1.0 Validate & Test Backend Code

##### 2.1.5.1.1 Id

validate-and-test

##### 2.1.5.1.2 Name

Validate & Test Backend Code

##### 2.1.5.1.3 Description

Runs on every push and pull request to ensure code quality, adherence to style, and correctness through automated testing.

##### 2.1.5.1.4 Stages

###### 2.1.5.1.4.1 Checkout Code

####### 2.1.5.1.4.1.1 Name

Checkout Code

####### 2.1.5.1.4.1.2 Tool

actions/checkout@v4

####### 2.1.5.1.4.1.3 Configuration

Default configuration.

###### 2.1.5.1.4.2.0 Setup Node.js Environment

####### 2.1.5.1.4.2.1 Name

Setup Node.js Environment

####### 2.1.5.1.4.2.2 Tool

actions/setup-node@v4

####### 2.1.5.1.4.2.3 Configuration

Node.js version 18+ as required by REQ-1-071.

###### 2.1.5.1.4.3.0 Install Dependencies

####### 2.1.5.1.4.3.1 Name

Install Dependencies

####### 2.1.5.1.4.3.2 Tool

npm

####### 2.1.5.1.4.3.3 Configuration

Command: `npm ci` in the 'functions' directory for reproducible builds.

###### 2.1.5.1.4.4.0 Static Code Analysis (Lint)

####### 2.1.5.1.4.4.1 Name

Static Code Analysis (Lint)

####### 2.1.5.1.4.4.2 Tool

ESLint

####### 2.1.5.1.4.4.3 Configuration

Command: `npm run lint`. Fails the job on any errors, enforcing code quality as per REQ-1-072.

###### 2.1.5.1.4.5.0 Unit Testing

####### 2.1.5.1.4.5.1 Name

Unit Testing

####### 2.1.5.1.4.5.2 Tool

Jest

####### 2.1.5.1.4.5.3 Configuration

Command: `npm test -- --coverage`. Executes all unit tests for Cloud Functions logic as per REQ-1-071.

###### 2.1.5.1.4.6.0 Check Code Coverage

####### 2.1.5.1.4.6.1 Name

Check Code Coverage

####### 2.1.5.1.4.6.2 Tool

Jest Coverage Reporter

####### 2.1.5.1.4.6.3 Configuration

Parses the coverage report and fails the job if total coverage is below 80%, as mandated by REQ-1-072.

#### 2.1.5.2.0.0.0 Deploy to Staging

##### 2.1.5.2.1.0.0 Id

deploy-staging

##### 2.1.5.2.2.0.0 Name

Deploy to Staging

##### 2.1.5.2.3.0.0 Description

Automatically deploys the backend resources to the dedicated Staging/UAT Firebase project (REQ-1-020) upon a successful merge to the 'staging' branch.

##### 2.1.5.2.4.0.0 Dependencies

- validate-and-test

##### 2.1.5.2.5.0.0 Trigger

###### 2.1.5.2.5.1.0 Event

push

###### 2.1.5.2.5.2.0 Branch

staging

##### 2.1.5.2.6.0.0 Stages

###### 2.1.5.2.6.1.0 Authenticate to Google Cloud

####### 2.1.5.2.6.1.1 Name

Authenticate to Google Cloud

####### 2.1.5.2.6.1.2 Tool

google-github-actions/auth@v2

####### 2.1.5.2.6.1.3 Configuration

Uses a Workload Identity Federation Service Account key stored in GitHub Secrets to authenticate with the Staging GCP project.

###### 2.1.5.2.6.2.0 Deploy to Firebase Staging

####### 2.1.5.2.6.2.1 Name

Deploy to Firebase Staging

####### 2.1.5.2.6.2.2 Tool

Firebase CLI

####### 2.1.5.2.6.2.3 Configuration

Command: `firebase deploy --only functions,firestore --project <staging-project-id>`. Deploys IaC resources (REQ-1-072).

#### 2.1.5.3.0.0.0 Deploy to Production

##### 2.1.5.3.1.0.0 Id

deploy-production

##### 2.1.5.3.2.0.0 Name

Deploy to Production

##### 2.1.5.3.3.0.0 Description

Deploys the backend resources to the Production Firebase project (REQ-1-020) upon a successful merge to the 'main' branch, protected by a mandatory manual approval step.

##### 2.1.5.3.4.0.0 Dependencies

- validate-and-test

##### 2.1.5.3.5.0.0 Trigger

###### 2.1.5.3.5.1.0 Event

push

###### 2.1.5.3.5.2.0 Branch

main

##### 2.1.5.3.6.0.0 Environment

###### 2.1.5.3.6.1.0 Name

production

###### 2.1.5.3.6.2.0 Protection Rules

- Required reviewers: 1

##### 2.1.5.3.7.0.0 Stages

###### 2.1.5.3.7.1.0 Manual Approval Gate

####### 2.1.5.3.7.1.1 Name

Manual Approval Gate

####### 2.1.5.3.7.1.2 Tool

GitHub Actions Environments

####### 2.1.5.3.7.1.3 Configuration

The pipeline will pause and require a manual approval from a designated approver before proceeding to deploy to the production environment.

###### 2.1.5.3.7.2.0 Authenticate to Google Cloud

####### 2.1.5.3.7.2.1 Name

Authenticate to Google Cloud

####### 2.1.5.3.7.2.2 Tool

google-github-actions/auth@v2

####### 2.1.5.3.7.2.3 Configuration

Uses a Workload Identity Federation Service Account key stored in GitHub Secrets to authenticate with the Production GCP project.

###### 2.1.5.3.7.3.0 Deploy to Firebase Production

####### 2.1.5.3.7.3.1 Name

Deploy to Firebase Production

####### 2.1.5.3.7.3.2 Tool

Firebase CLI

####### 2.1.5.3.7.3.3 Configuration

Command: `firebase deploy --only functions,firestore --project <production-project-id>`. Deploys IaC resources (REQ-1-072).

## 2.2.0.0.0.0.0 Flutter Client CI/CD Pipeline

### 2.2.1.0.0.0.0 Id

flutter-client-pipeline

### 2.2.2.0.0.0.0 Name

Flutter Client CI/CD Pipeline

### 2.2.3.0.0.0.0 Description

Handles continuous integration, building, and deployment/distribution for the cross-platform Flutter application (iOS, Android, Web) as per REQ-1-013.

### 2.2.4.0.0.0.0 Triggers

#### 2.2.4.1.0.0.0 Event

##### 2.2.4.1.1.0.0 Event

push

##### 2.2.4.1.2.0.0 Branches

- main
- staging

##### 2.2.4.1.3.0.0 Paths

- lib/**
- pubspec.yaml
- web/**

#### 2.2.4.2.0.0.0 Event

##### 2.2.4.2.1.0.0 Event

pull_request

##### 2.2.4.2.2.0.0 Branches

- main
- staging

##### 2.2.4.2.3.0.0 Paths

- lib/**
- pubspec.yaml

#### 2.2.4.3.0.0.0 Event

##### 2.2.4.3.1.0.0 Event

workflow_dispatch

##### 2.2.4.3.2.0.0 Inputs

###### 2.2.4.3.2.1.0 Release Tag

string

### 2.2.5.0.0.0.0 Jobs

#### 2.2.5.1.0.0.0 Analyze & Test Flutter Code

##### 2.2.5.1.1.0.0 Id

analyze-and-test

##### 2.2.5.1.2.0.0 Name

Analyze & Test Flutter Code

##### 2.2.5.1.3.0.0 Description

Runs on every push and pull request to ensure the Flutter client code meets quality and testing standards.

##### 2.2.5.1.4.0.0 Stages

###### 2.2.5.1.4.1.0 Checkout Code

####### 2.2.5.1.4.1.1 Name

Checkout Code

####### 2.2.5.1.4.1.2 Tool

actions/checkout@v4

####### 2.2.5.1.4.1.3 Configuration

Default configuration.

###### 2.2.5.1.4.2.0 Setup Flutter Environment

####### 2.2.5.1.4.2.1 Name

Setup Flutter Environment

####### 2.2.5.1.4.2.2 Tool

subosito/flutter-action@v2

####### 2.2.5.1.4.2.3 Configuration

Flutter version 3.x as per REQ-1-071.

###### 2.2.5.1.4.3.0 Install Dependencies

####### 2.2.5.1.4.3.1 Name

Install Dependencies

####### 2.2.5.1.4.3.2 Tool

flutter

####### 2.2.5.1.4.3.3 Configuration

Command: `flutter pub get`.

###### 2.2.5.1.4.4.0 Static Code Analysis

####### 2.2.5.1.4.4.1 Name

Static Code Analysis

####### 2.2.5.1.4.4.2 Tool

flutter

####### 2.2.5.1.4.4.3 Configuration

Command: `flutter analyze`. Fails the job on any analysis errors, enforcing code style from the `lints` package (REQ-1-072).

###### 2.2.5.1.4.5.0 Unit & Widget Testing

####### 2.2.5.1.4.5.1 Name

Unit & Widget Testing

####### 2.2.5.1.4.5.2 Tool

flutter

####### 2.2.5.1.4.5.3 Configuration

Command: `flutter test --coverage`. Executes all unit and widget tests as per REQ-1-071.

###### 2.2.5.1.4.6.0 Check Code Coverage

####### 2.2.5.1.4.6.1 Name

Check Code Coverage

####### 2.2.5.1.4.6.2 Tool

Coverage Tooling (e.g., lcov)

####### 2.2.5.1.4.6.3 Configuration

Parses the coverage report and fails the job if total coverage is below 80%, as mandated by REQ-1-072.

#### 2.2.5.2.0.0.0 Build & Deploy Web Admin Dashboard

##### 2.2.5.2.1.0.0 Id

build-deploy-web-admin

##### 2.2.5.2.2.0.0 Name

Build & Deploy Web Admin Dashboard

##### 2.2.5.2.3.0.0 Description

Builds the Flutter for Web application and deploys it to Firebase Hosting for the appropriate environment (Staging or Production).

##### 2.2.5.2.4.0.0 Dependencies

- analyze-and-test

##### 2.2.5.2.5.0.0 Stages

###### 2.2.5.2.5.1.0 Build Web Artifacts

####### 2.2.5.2.5.1.1 Name

Build Web Artifacts

####### 2.2.5.2.5.1.2 Tool

flutter

####### 2.2.5.2.5.1.3 Configuration

Command: `flutter build web`.

###### 2.2.5.2.5.2.0 Deploy to Firebase Hosting

####### 2.2.5.2.5.2.1 Name

Deploy to Firebase Hosting

####### 2.2.5.2.5.2.2 Tool

Firebase CLI

####### 2.2.5.2.5.2.3 Configuration

Command: `firebase deploy --only hosting --project <project-id>`. The project ID is determined by the branch (`staging` or `main`).

#### 2.2.5.3.0.0.0 Build & Upload Mobile Apps

##### 2.2.5.3.1.0.0 Id

build-upload-mobile

##### 2.2.5.3.2.0.0 Name

Build & Upload Mobile Apps

##### 2.2.5.3.3.0.0 Description

Builds, signs, and uploads the Android and iOS applications to their respective store's internal testing tracks for QA and pilot testing (REQ-1-078).

##### 2.2.5.3.4.0.0 Dependencies

- analyze-and-test

##### 2.2.5.3.5.0.0 Trigger

###### 2.2.5.3.5.1.0 Event

push

###### 2.2.5.3.5.2.0 Branch

staging

##### 2.2.5.3.6.0.0 Stages

###### 2.2.5.3.6.1.0 Build Android App Bundle

####### 2.2.5.3.6.1.1 Name

Build Android App Bundle

####### 2.2.5.3.6.1.2 Tool

flutter

####### 2.2.5.3.6.1.3 Configuration

Command: `flutter build appbundle`. The release bundle is signed using a keystore stored securely in GitHub Secrets.

###### 2.2.5.3.6.2.0 Upload to Google Play Internal Testing

####### 2.2.5.3.6.2.1 Name

Upload to Google Play Internal Testing

####### 2.2.5.3.6.2.2 Tool

Google Play Action (e.g., r0adkll/upload-google-play)

####### 2.2.5.3.6.2.3 Configuration

Uploads the signed App Bundle to the internal testing track. Requires a Google Play service account key stored in GitHub Secrets.

###### 2.2.5.3.6.3.0 Build iOS IPA

####### 2.2.5.3.6.3.1 Name

Build iOS IPA

####### 2.2.5.3.6.3.2 Tool

flutter

####### 2.2.5.3.6.3.3 Configuration

Command: `flutter build ipa`. Runs on a macOS runner. The IPA is signed using certificates and provisioning profiles stored in GitHub Secrets.

###### 2.2.5.3.6.4.0 Upload to Apple TestFlight

####### 2.2.5.3.6.4.1 Name

Upload to Apple TestFlight

####### 2.2.5.3.6.4.2 Tool

Apple Store Connect Action (e.g., apple-actions/upload-testflight-build)

####### 2.2.5.3.6.4.3 Configuration

Uploads the signed IPA to TestFlight for internal and pilot testers. Requires App Store Connect API keys stored in GitHub Secrets.

# 3.0.0.0.0.0.0 Cross Cutting Concerns

## 3.1.0.0.0.0.0 Secrets Management

### 3.1.1.0.0.0.0 Tool

GitHub Encrypted Secrets

### 3.1.2.0.0.0.0 Description

All sensitive credentials, such as GCP Service Account keys, mobile app signing keys, and App Store API keys, are stored as encrypted secrets in GitHub and exposed to workflows as environment variables.

## 3.2.0.0.0.0.0 Environment Management

### 3.2.1.0.0.0.0 Tool

GitHub Actions Environments

### 3.2.2.0.0.0.0 Description

The 'production' environment is configured with a protection rule requiring manual approval for deployments, ensuring a human gate before any changes are released to live users, fulfilling the need for a controlled cutover process (REQ-1-081).

## 3.3.0.0.0.0.0 Artifact Management

### 3.3.1.0.0.0.0 Strategy

The primary artifacts are the versioned Android App Bundle (.aab) and iOS application archive (.ipa), which are uploaded directly to their respective app stores. Web artifacts are deployed directly to Firebase Hosting. The immutable source code Git tag serves as the version reference for all deployed artifacts.

### 3.3.2.0.0.0.0 Requirements

- REQ-1-078

## 3.4.0.0.0.0.0 Rollback Strategy

| Property | Value |
|----------|-------|
| Backend | A rollback is performed by re-running the deployme... |
| Client Web | Identical to the backend; a previous commit is red... |
| Client Mobile | Rollback is a manual process managed within the Go... |

