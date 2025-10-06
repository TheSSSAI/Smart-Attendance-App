# 1 Strategies

## 1.1 Retry

### 1.1.1 Type

🔹 Retry

### 1.1.2 Configuration

#### 1.1.2.1 Comment

Applies to server-side Cloud Functions making external API calls (e.g., SendGrid, Google Sheets) that may experience temporary outages. Leverages Cloud Functions' built-in retry for background events.

#### 1.1.2.2 Retry Attempts

3

#### 1.1.2.3 Backoff Strategy

Exponential

#### 1.1.2.4 Error Handling Rules

- ExternalAPITransientError
- InfrastructureTransientError

## 1.2.0.0 CircuitBreaker

### 1.2.1.0 Type

🔹 CircuitBreaker

### 1.2.2.0 Configuration

#### 1.2.2.1 Comment

Protects the system from making repeated calls to a known failing external service (e.g., SendGrid API is down). To be implemented within the Cloud Function logic for critical external calls.

#### 1.2.2.2 Failure Threshold

5

#### 1.2.2.3 Open State Duration

5m

#### 1.2.2.4 Error Handling Rules

- ExternalAPIServiceUnavailable

## 1.3.0.0 Fallback

### 1.3.1.0 Type

🔹 Fallback

### 1.3.2.0 Configuration

#### 1.3.2.1 Comment

Handles client-side network unavailability by writing to the local cache, as per REQ-1-009. This is the core offline functionality.

#### 1.3.2.2 Fallback Response

USE_LOCAL_CACHE

#### 1.3.2.3 Error Handling Rules

- ClientNetworkUnavailable

## 1.4.0.0 StateUpdateAndNotify

### 1.4.1.0 Type

🔹 StateUpdateAndNotify

### 1.4.2.0 Configuration

#### 1.4.2.1 Comment

Handles permanent, non-retryable errors with the Google Sheets integration, such as revoked permissions or a deleted file, as per REQ-1-060.

#### 1.4.2.2 State Update

| Property | Value |
|----------|-------|
| Entity | GoogleSheetIntegration |
| Field | status |
| Value | error |

#### 1.4.2.3 Notification

Display persistent alert in Admin Dashboard with error details.

#### 1.4.2.4 Error Handling Rules

- GoogleSheetsPermanentError

## 1.5.0.0 UserPromptedManualRetry

### 1.5.1.0 Type

🔹 UserPromptedManualRetry

### 1.5.2.0 Configuration

#### 1.5.2.1 Comment

Handles the specific case where offline data fails to sync for an extended period, requiring user intervention, as per REQ-1-047.

#### 1.5.2.2 Notification

Display persistent, non-dismissible in-app notification with a manual sync trigger.

#### 1.5.2.3 Error Handling Rules

- ClientSyncFailure_24h

# 2.0.0.0 Monitoring

## 2.1.0.0 Error Types

- ExternalAPITransientError
- ExternalAPIServiceUnavailable
- GoogleSheetsPermanentError
- ClientNetworkUnavailable
- ClientSyncFailure_24h
- ClientCrash
- CloudFunctionError

## 2.2.0.0 Alerting

1. Client-side crashes are reported to Firebase Crashlytics (REQ-1-076). 2. All server-side errors are logged to Google Cloud Logging (REQ-1-076). 3. An automated alert is sent to administrators via Google Cloud Monitoring if any Cloud Function error rate exceeds 1% (REQ-1-076). 4. A prominent UI alert is displayed on the Admin Dashboard for GoogleSheetsPermanentError (REQ-1-060). 5. A budget alert is configured in GCP to notify administrators of potential cost overruns (REQ-1-076).

