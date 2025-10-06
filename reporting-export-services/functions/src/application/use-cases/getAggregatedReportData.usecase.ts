import * as functions from "firebase-functions";
import { IUseCase } from "../ports/IUseCase";
import { IAttendanceRepository } from "../../domain/repositories/IAttendanceRepository";
import { IIntegrationRepository } from "../../domain/repositories/IIntegrationRepository"; // Assuming this repo can fetch tenant config
import { AttendanceRecord } from "../../domain/entities/AttendanceRecord"; // Assuming a shared entity definition
import { User } from "../../domain/entities/User"; // Assuming a shared entity definition

// Define a more structured report type
export interface AttendanceSummaryReport {
    date: string;
    totalActiveUsers: number;
    presentUsers: number;
    absentUsers: number;
    attendancePercentage: number;
}

export interface ReportFilters {
    dateStart: Date;
    dateEnd: Date;
    userIds?: string[];
    teamIds?: string[];
    statuses?: string[];
}

/**
 * @implements {IUseCase<ReportFilters, AttendanceSummaryReport>}
 * @description Use case for generating aggregated attendance summary reports.
 * This is a foundational reporting use case that can be expanded for other report types.
 * It demonstrates fetching data based on filters and performing calculations.
 * Supports requirements: REQ-1-057, US-059
 */
export class GetAggregatedReportDataUseCase implements IUseCase<ReportFilters, AttendanceSummaryReport> {
    private readonly logger = functions.logger;

    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly integrationRepository: IIntegrationRepository, // Used for fetching user counts, etc.
    ) { }

    /**
     * Executes the report generation logic.
     * @param tenantId The ID of the tenant for which to generate the report.
     * @param filters The filters to apply to the report (date range, users, teams).
     * @returns {Promise<AttendanceSummaryReport>} A promise that resolves with the report data.
     */
    async execute(tenantId: string, filters: ReportFilters): Promise<AttendanceSummaryReport> {
        this.logger.info(`[GetAggregatedReportDataUseCase] Starting report generation for tenant: ${tenantId}`, {
            tenantId,
            filters,
        });

        if (!tenantId) {
            this.logger.error("[GetAggregatedReportDataUseCase] Tenant ID is required.");
            throw new functions.https.HttpsError("invalid-argument", "Tenant ID is required.");
        }

        if (!filters.dateStart || !filters.dateEnd) {
            this.logger.error("[GetAggregatedReportDataUseCase] Date range is required.");
            throw new functions.https.HttpsError("invalid-argument", "A valid date range is required.");
        }

        try {
            // In a real scenario, getting total active users for a date range would be complex.
            // This might involve querying a separate 'user_snapshots' collection or a more complex user query.
            // For this implementation, we'll fetch the current total active user count as a representative number.
            const totalActiveUsers = await this.integrationRepository.getActiveUserCount(tenantId);
            if (totalActiveUsers === 0) {
                this.logger.warn(`[GetAggregatedReportDataUseCase] No active users found for tenant ${tenantId}.`);
                return this.buildEmptyReport(filters.dateStart);
            }

            const attendanceRecords: AttendanceRecord[] = await this.attendanceRepository.findRecordsByDateRange(
                tenantId,
                filters.dateStart,
                filters.dateEnd,
                { userIds: filters.userIds, teamIds: filters.teamIds },
            );

            // Get the unique number of users who checked in during this period
            const presentUserIds = new Set(attendanceRecords.map((record) => record.userId));
            const presentUsersCount = presentUserIds.size;
            const absentUsersCount = totalActiveUsers - presentUsersCount;

            const attendancePercentage = totalActiveUsers > 0
                ? parseFloat(((presentUsersCount / totalActiveUsers) * 100).toFixed(2))
                : 0;

            const report: AttendanceSummaryReport = {
                date: filters.dateStart.toISOString().split("T")[0], // Assuming a single-day report for simplicity
                totalActiveUsers: totalActiveUsers,
                presentUsers: presentUsersCount,
                absentUsers: absentUsersCount,
                attendancePercentage: attendancePercentage,
            };

            this.logger.info(`[GetAggregatedReportDataUseCase] Successfully generated report for tenant: ${tenantId}`, {
                tenantId,
                report,
            });

            return report;
        } catch (error) {
            this.logger.error(
                `[GetAggregatedReportDataUseCase] Error generating report for tenant: ${tenantId}`,
                {
                    tenantId,
                    error: (error as Error).message,
                    stack: (error as Error).stack,
                },
            );
            // Re-throw as a standard error for the trigger to handle.
            throw new functions.https.HttpsError("internal", "An unexpected error occurred while generating the report.");
        }
    }

    private buildEmptyReport(date: Date): AttendanceSummaryReport {
        return {
            date: date.toISOString().split("T")[0],
            totalActiveUsers: 0,
            presentUsers: 0,
            absentUsers: 0,
            attendancePercentage: 0,
        };
    }
}