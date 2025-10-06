import * as functions from "firebase-functions";
import { initializeApp, getApps, App } from "firebase-admin/app";
import { getFirestore, Firestore } from "firebase-admin/firestore";

import { env } from "./env";

// Level 2 Imports
import { SecretManagerClient } from "../infrastructure/services/SecretManagerClient";
import { GoogleAuthClient } from "../infrastructure/services/GoogleAuthClient";
import { GoogleSheetsClient } from "../infrastructure/services/GoogleSheetsClient";

// Level 3 Imports
import { FirestoreIntegrationRepository } from "../infrastructure/persistence/FirestoreIntegrationRepository";
import { FirestoreAttendanceRepository } from "../infrastructure/persistence/FirestoreAttendanceRepository";

// Level 4 Imports
import { HandleGoogleAuthCallbackUseCase } from "../application/use-cases/handleGoogleAuthCallback.usecase";
import { ExportAttendanceToSheetsUseCase } from "../application/use-cases/exportAttendanceToSheets.usecase";
import { GetAggregatedReportDataUseCase } from "../application/use-cases/getAggregatedReportData.usecase";

// Interfaces (Level 0, 1, 2)
import { ISecretManagerClient } from "../infrastructure/services/SecretManagerClient";
import { IGoogleAuthClient } from "../infrastructure/services/GoogleAuthClient";
import { IGoogleSheetsClient } from "../infrastructure/services/GoogleSheetsClient";
import { IIntegrationRepository } from "../domain/repositories/IIntegrationRepository";
import { IAttendanceRepository } from "../domain/repositories/IAttendanceRepository";

/**
 * A lightweight, manual Dependency Injection container.
 * It's responsible for instantiating and wiring together all services,
 * repositories, and use cases, following Clean Architecture principles.
 * A new instance should be created for each function invocation to ensure
 * statelessness and proper request scoping.
 */
export class DIContainer {
  private readonly firebaseApp: App;
  private readonly firestore: Firestore;
  private readonly secretManagerClient: ISecretManagerClient;
  private readonly googleAuthClient: IGoogleAuthClient;

  // Repositories
  private readonly integrationRepository: IIntegrationRepository;
  private readonly attendanceRepository: IAttendanceRepository;

  constructor() {
    // Initialize Firebase Admin SDK if not already done
    if (getApps().length === 0) {
      initializeApp();
    }
    this.firebaseApp = getApps()[0];
    this.firestore = getFirestore(this.firebaseApp);

    // Level 2: Infrastructure Services
    this.secretManagerClient = new SecretManagerClient();
    this.googleAuthClient = new GoogleAuthClient(this.secretManagerClient);

    // Level 3: Infrastructure Persistence (Repositories)
    this.integrationRepository = new FirestoreIntegrationRepository(
      this.firestore,
    );
    this.attendanceRepository = new FirestoreAttendanceRepository(
      this.firestore,
    );
  }

  /**
   * Constructs and returns an instance of the HandleGoogleAuthCallbackUseCase.
   * This use case is typically short-lived and created per request.
   * @returns {HandleGoogleAuthCallbackUseCase} A fully configured use case instance.
   */
  public getHandleGoogleAuthCallbackUseCase(): HandleGoogleAuthCallbackUseCase {
    return new HandleGoogleAuthCallbackUseCase(
      this.integrationRepository,
      this.secretManagerClient,
      this.googleAuthClient,
      functions.logger,
    );
  }

  /**
   * Constructs and returns an instance of the ExportAttendanceToSheetsUseCase.
   * This use case is created for each scheduled job execution.
   * @returns {ExportAttendanceToSheetsUseCase} A fully configured use case instance.
   */
  public getExportAttendanceToSheetsUseCase(): ExportAttendanceToSheetsUseCase {
    // The GoogleSheetsClient is instantiated here because it requires a runtime
    // access token, which is fetched within the use case itself.
    // We pass a factory function to the use case.
    const googleSheetsClientFactory = (
      accessToken: string,
    ): IGoogleSheetsClient => {
      return new GoogleSheetsClient(accessToken);
    };

    return new ExportAttendanceToSheetsUseCase(
      this.integrationRepository,
      this.attendanceRepository,
      this.secretManagerClient,
      this.googleAuthClient,
      googleSheetsClientFactory,
      functions.logger,
    );
  }

  /**
   * Constructs and returns an instance of the GetAggregatedReportDataUseCase.
   * @returns {GetAggregatedReportDataUseCase} A fully configured use case instance.
   */
  public getGetAggregatedReportDataUseCase(): GetAggregatedReportDataUseCase {
    return new GetAggregatedReportDataUseCase(
      this.attendanceRepository,
      functions.logger,
    );
  }
}

/**
 * Global factory function to create a new DI container instance.
 * This should be called at the beginning of each Cloud Function invocation.
 * @returns {DIContainer} A new instance of the DIContainer.
 */
export const createContainer = (): DIContainer => {
  return new DIContainer();
};