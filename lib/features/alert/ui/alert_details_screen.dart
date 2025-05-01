import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:latlong2/latlong.dart';

import '../model/alert.dart';

class AlertDetailsScreen extends StatefulWidget {
  final Alert alert;

  const AlertDetailsScreen({super.key, required this.alert});

  @override
  State<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.alert.latitude, widget.alert.longitude),
              initialZoom: 16,
              keepAlive: false,
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
                    point: LatLng(widget.alert.latitude, widget.alert.longitude),
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
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi tiết cảnh báo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12), // Tăng khoảng cách giữa tiêu đề và các thông tin
              _buildDetailRow('Vị trí:', widget.alert.location),
              _buildDetailRow('Thời gian bắt đầu:', TimeUtil.epochToVietnamTime(int.parse(widget.alert.startTime))),
              _buildDetailRow('Thời gian kết thúc:', widget.alert.endTime == null ? "-" : TimeUtil.epochToVietnamTime(int.parse(widget.alert.endTime!))),
              _buildDetailRow('Tổng thời gian:', widget.alert.endTime == null ? "-" : TimeUtil.calcTotalTime(int.parse(widget.alert.startTime), int.parse(widget.alert.endTime!))),
              const SizedBox(height: 16), // Khoảng cách cuối cùng
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black, // Màu nền nút
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
