import { z } from 'zod';

/**
 * @description A Zod schema for representing geographic coordinates (latitude and longitude).
 * This schema enforces the valid ranges for latitude (-90 to 90) and longitude (-180 to 180).
 * This value object is used for capturing GPS locations for attendance records as per REQ-1-004.
 */
export const geoPointSchema = z
  .object(
    {
      latitude: z
        .number({
          required_error: 'Latitude is required.',
          invalid_type_error: 'Latitude must be a number.',
        })
        .min(-90, { message: 'Latitude must be between -90 and 90.' })
        .max(90, { message: 'Latitude must be between -90 and 90.' }),
      longitude: z
        .number({
          required_error: 'Longitude is required.',
          invalid_type_error: 'Longitude must be a number.',
        })
        .min(-180, { message: 'Longitude must be between -180 and 180.' })
        .max(180, { message: 'Longitude must be between -180 and 180.' }),
    },
    {
      description: 'A geographic point with latitude and longitude.',
      required_error: 'GPS coordinates are required.',
      invalid_type_error: 'GPS coordinates must be an object.',
    },
  )
  .strict();

/**
 * @description The TypeScript type inferred from the `geoPointSchema`.
 * Provides static type safety for geographic coordinate objects throughout the application.
 * This type should be used wherever GPS data is handled.
 */
export type GeoPoint = z.infer<typeof geoPointSchema>;