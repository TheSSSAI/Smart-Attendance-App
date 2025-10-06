import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/attendance/application/providers/attendance_providers.dart';

class AttendanceDetailScreen extends ConsumerWidget {
  final String id;
  const AttendanceDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(attendanceRecordDetailProvider(id));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Details'),
      ),
      body: recordAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (record) {
          if (record == null) {
            return const Center(child: Text('Record not found.'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard(context, record),
                  const SizedBox(height: 16),
                  if (record.checkInGps != null || record.checkOutGps != null)
                    _buildMapCard(context, record),
                  const SizedBox(height: 24),
                  if (record.status == 'approved' || record.status == 'rejected')
                    Center(
                      child: FilledButton.tonal(
                        onPressed: () => context.goNamed(
                          AppRoutes.correctionRequest.name,
                          pathParameters: {'id': id},
                        ),
                        child: const Text('Request Correction'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, AttendanceRecord record) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${record.checkInTime.toLocal()}', style: textTheme.titleMedium), // Format properly
            const Divider(height: 24),
            _buildDetailRow('Status:', record.status.toUpperCase(), context),
            if (record.rejectionReason != null)
              _buildDetailRow('Rejection Reason:', record.rejectionReason!, context, isWarning: true),
            _buildDetailRow('Check-in:', record.checkInTime.toLocal().toString(), context), // Format
            _buildDetailRow('Check-out:', record.checkOutTime?.toLocal().toString() ?? 'N/A', context), // Format
            if (record.flags.isNotEmpty)
              _buildDetailRow('Flags:', record.flags.join(', '), context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context, {bool isWarning = false}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyLarge),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isWarning ? colorScheme.error : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, AttendanceRecord record) {
    final markers = <Marker>{};
    LatLng? initialCameraPosition;

    if (record.checkInGps != null) {
      final latLng = LatLng(record.checkInGps!.latitude, record.checkInGps!.longitude);
      initialCameraPosition = latLng;
      markers.add(
        Marker(
          markerId: const MarkerId('check-in'),
          position: latLng,
          infoWindow: InfoWindow(title: 'Check-in', snippet: record.checkInTime.toLocal().toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (record.checkOutGps != null) {
      final latLng = LatLng(record.checkOutGps!.latitude, record.checkOutGps!.longitude);
      initialCameraPosition ??= latLng;
      markers.add(
        Marker(
          markerId: const MarkerId('check-out'),
          position: latLng,
          infoWindow: InfoWindow(title: 'Check-out', snippet: record.checkOutTime!.toLocal().toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    
    if (initialCameraPosition == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialCameraPosition,
            zoom: 15,
          ),
          markers: markers,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}