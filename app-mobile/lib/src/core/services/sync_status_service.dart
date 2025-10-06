import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines the contract for a service that tracks the status of offline data synchronization.
///
/// This service is crucial for fulfilling REQ-1-009 and US-035, which require
/// notifying the user of persistent sync failures (older than 24 hours).
abstract class ISyncStatusService {
  /// Tracks a new record that was created offline.
  ///
  /// Stores the record's ID and creation timestamp locally.
  Future<void> trackNewOfflineRecord(String recordId);

  /// Removes a record from tracking, typically after it has been successfully synced.
  Future<void> untrackSyncedRecord(String recordId);

  /// Removes a list of records from tracking.
  Future<void> untrackSyncedRecords(List<String> recordIds);

  /// Checks for locally stored records older than 24 hours and returns their IDs.
  Future<List<String>> getStaleRecordIds();

  /// A utility method to clear all tracked records, e.g., on user logout.
  Future<void> clearAllTrackedRecords();
}

/// Concrete implementation of [ISyncStatusService] using `shared_preferences`.
///
/// It stores a map of offline record IDs to their creation timestamps as a JSON
/// string under a single key for efficiency.
class SyncStatusService implements ISyncStatusService {
  final SharedPreferences _prefs;

  static const _offlineTrackerKey = 'offline_record_tracker';
  static const _staleDuration = Duration(hours: 24);

  SyncStatusService(this._prefs);

  /// Reads the current map of tracked records from local storage.
  ///
  /// Returns an empty map if no records are tracked or if there's a parsing error.
  Future<Map<String, String>> _getTrackedRecords() async {
    final jsonString = _prefs.getString(_offlineTrackerKey);
    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }
    try {
      final decodedMap = json.decode(jsonString);
      if (decodedMap is Map) {
        return Map<String, String>.from(decodedMap);
      }
    } catch (e) {
      // If JSON is corrupted, log the error and start fresh.
      // In a real app, this would use a proper logging service.
      print('Error decoding offline record tracker: $e');
      await clearAllTrackedRecords();
    }
    return {};
  }

  /// Saves the updated map of tracked records to local storage.
  Future<bool> _saveTrackedRecords(Map<String, String> records) {
    final jsonString = json.encode(records);
    return _prefs.setString(_offlineTrackerKey, jsonString);
  }

  @override
  Future<void> trackNewOfflineRecord(String recordId) async {
    final records = await _getTrackedRecords();
    records[recordId] = DateTime.now().toIso8601String();
    await _saveTrackedRecords(records);
  }

  @override
  Future<void> untrackSyncedRecord(String recordId) async {
    final records = await _getTrackedRecords();
    if (records.containsKey(recordId)) {
      records.remove(recordId);
      await _saveTrackedRecords(records);
    }
  }
  
  @override
  Future<void> untrackSyncedRecords(List<String> recordIds) async {
    if (recordIds.isEmpty) return;
    final records = await _getTrackedRecords();
    bool wasModified = false;
    for (final recordId in recordIds) {
      if (records.containsKey(recordId)) {
        records.remove(recordId);
        wasModified = true;
      }
    }
    if (wasModified) {
       await _saveTrackedRecords(records);
    }
  }

  @override
  Future<List<String>> getStaleRecordIds() async {
    final records = await _getTrackedRecords();
    if (records.isEmpty) {
      return [];
    }

    final staleIds = <String>[];
    final now = DateTime.now();

    records.forEach((recordId, timestampStr) {
      try {
        final timestamp = DateTime.parse(timestampStr);
        if (now.difference(timestamp) > _staleDuration) {
          staleIds.add(recordId);
        }
      } catch (e) {
        // Log bad data but don't crash.
        print('Could not parse timestamp for record $recordId: $timestampStr');
      }
    });

    return staleIds;
  }

  @override
  Future<void> clearAllTrackedRecords() async {
    await _prefs.remove(_offlineTrackerKey);
  }
}