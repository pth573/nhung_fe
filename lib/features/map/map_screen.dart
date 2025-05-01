import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/home/provider/sensor_provider.dart';
import 'package:latlong2/latlong.dart';
import '../main/presentation/provider/floating_bar_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(10.7769, 106.7009);
  final List<LatLng> _polylinePoints = [];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = ref.watch(sensorListProvider);
    final isTracking = ref.watch(floatingBarProvider);

    if (!isTracking) {
      _polylinePoints.clear();
    }

    if (sensorData.isNotEmpty && isTracking) {
      _polylinePoints.add(LatLng(sensorData.last.latitude, sensorData.last.longitude));
    }

    _center = LatLng(sensorData.last.latitude, sensorData.last.longitude);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_center, 16);
    });

    print('Center: $_center, Polyline points: $_polylinePoints');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ vị trí', style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 16,
          keepAlive: false,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (_polylinePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _polylinePoints,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: _center,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ] ,
          ),
        ],
      ),
    );
  }
}