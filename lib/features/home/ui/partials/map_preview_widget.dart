import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/home/provider/sensor_provider.dart';
import 'package:hotel_app/widgets/view_more_widget.dart';
import 'package:latlong2/latlong.dart';

class MapPreviewWidget extends ConsumerStatefulWidget {
  const MapPreviewWidget({super.key});

  @override
  _MapPreviewWidgetState createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends ConsumerState<MapPreviewWidget> {
  final MapController _mapController = MapController();
  LatLng _fakeLocation = const LatLng(10.7769, 106.7009); // Vị trí mặc định (TP.HCM)

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = ref.watch(sensorListProvider);

    if (sensorData.isNotEmpty) {
      _fakeLocation = LatLng(sensorData.last.latitude, sensorData.last.longitude);
      // Cập nhật vị trí bản đồ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_fakeLocation, 16);
      });
    }

    print('Fake location: $_fakeLocation');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _fakeLocation,
                  initialZoom: 16,
                  keepAlive: false,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none, // Không cho tương tác
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: _fakeLocation,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ViewMoreWidget(),
        ],
      ),
    );
  }
}