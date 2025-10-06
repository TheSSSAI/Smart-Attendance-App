# Backend Shared Utilities

`@attendance-app/backend-shared-utils` is a private, reusable library containing common utilities and cross-cutting concerns for all backend Cloud Functions within the Attendance App ecosystem. Its purpose is to provide a consistent operational foundation for all backend services, simplifying development and ensuring uniform logging, error handling, and security practices.

## Overview

This library provides standardized modules for:

-   **Structured Logging**: A wrapper around Google Cloud Logging to ensure all logs are consistent, structured JSON payloads.
-   **Error Handling**: A centralized error handler and custom error types to standardize exception reporting.
-   **Secret Management**: A performant, cached client for securely accessing secrets from Google Secret Manager.
-   **Context Parsing**: Utilities for safely parsing `tenantId`, `userId`, and `role` from Firebase Functions request contexts.
-   **Standardized Responses**: Helpers for creating consistent success and error API responses.

## Installation

This is a private package. Ensure you are authenticated with your organization's package registry.

```bash
npm install @attendance-app/backend-shared-utils
```

## Usage

### Structured Logging (`StructuredLogger`)

Provides a consistent logging interface that produces JSON logs compatible with Google Cloud Logging.

```typescript
import { StructuredLogger } from '@attendance-app/backend-shared-utils';

const logger = new StructuredLogger('my-service-name');

export const myCloudFunction = functions.https.onCall(async (data, context) => {
    logger.info('Function started', { functionName: 'myCloudFunction' });

    try {
        // ... business logic
        logger.warn('A non-critical issue occurred.', { userId: context.auth?.uid });
        return { success: true };
    } catch (e) {
        const error = e as Error;
        logger.error('Function failed', error, { data });
        throw new functions.https.HttpsError('internal', 'An unexpected error occurred.');
    }
});
```

### Secret Management (`SecretManagerClient`)

A singleton, cached client for fetching secrets from Google Secret Manager. It reduces latency and cost by caching secrets in memory for the lifetime of a function instance.

```typescript
import { SecretManagerClient } from '@attendance-app/backend-shared-utils';

const secretClient = SecretManagerClient.getInstance();

async function getApiKey() {
    try {
        const apiKey = await secretClient.getSecret('MY_API_KEY');
        // Use the API key
    } catch (error) {
        // Handle cases where the secret is not found
        console.error('Failed to retrieve secret:', error);
    }
}
```

### Context Parsing (`FirebaseContextUtils`)

Safely extract and validate the authentication context from a Firebase Function request.

```typescript
import { FirebaseContextUtils, AuthenticationError } from '@attendance-app/backend-shared-utils';

export const myProtectedFunction = functions.https.onCall(async (data, context) => {
    try {
        const { userId, tenantId, role } = FirebaseContextUtils.getAuthenticatedContext(context);
        
        // Now you can safely use userId, tenantId, and role
        console.log(`Request from user ${userId} in tenant ${tenantId} with role ${role}`);

    } catch (error) {
        if (error instanceof AuthenticationError) {
            // This will be caught if the user is not authenticated
            throw new functions.https.HttpsError('unauthenticated', error.message);
        }
        // Handle other errors
    }
});
```

### Error Handling (`withErrorHandler`)

A higher-order function that wraps your main function logic to provide centralized `try/catch` blocks, logging, and standardized error responses.

```typescript
import { withErrorHandler, StructuredLogger, createErrorResponse } from '@attendance-app/backend-shared-utils';
import { Request, Response } from 'firebase-functions';

const logger = new StructuredLogger('my-http-service');

const myHttpHandler = async (req: Request, res: Response) => {
    // Main business logic here. If this throws an error,
    // withErrorHandler will catch it, log it, and send a
    // standardized JSON error response.
    
    if (!req.body.name) {
        // For controlled errors, you can send a specific response
        return res.status(400).send(createErrorResponse('Name is required.', 'VALIDATION_ERROR'));
    }

    res.status(200).send({ success: true, data: { id: '123' } });
};

// Wrap the handler to get automatic error handling
export const myHttpFunction = functions.https.onRequest(
    withErrorHandler(myHttpHandler, logger)
);
```

## Development

### Prerequisites

-   Node.js (version specified in `.nvmrc`)
-   NPM

### Setup

1.  **Install Node Version Manager (`nvm`)**
2.  **Use the correct Node.js version:**
    ```bash
    nvm install
    nvm use
    ```
3.  **Install dependencies:**
    ```bash
    npm install
    ```

### Running Tests

To run the test suite:

```bash
npm test
```

To run tests in watch mode:

```bash
npm run test:watch
```

### Linting and Formatting

To check for linting errors:

```bash
npm run lint
```

To automatically format the code:

```bash
npm run format
```

### Building the Project

To compile the TypeScript code into JavaScript in the `dist` directory:

```bash
npm run build
```

## Contributing

Please follow the established coding standards and ensure all tests pass before submitting a pull request. All new features must be accompanied by corresponding unit tests.