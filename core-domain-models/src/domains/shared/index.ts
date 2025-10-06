import { z } from 'zod';
import { geoPointSchema } from './geo.schema';
import {
  idSchema,
  tenantIdSchema,
  firestoreTimestampSchema,
} from './primitives.schema';

// Re-exporting schemas for easy access from other domains
export * from './primitives.schema';
export * from './geo.schema';

// Exporting inferred types
export type GeoPoint = z.infer<typeof geoPointSchema>;