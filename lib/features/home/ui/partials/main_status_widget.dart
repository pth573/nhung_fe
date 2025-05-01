import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/home/ui/partials/status_chart.dart';
import 'package:hotel_app/widgets/view_more_widget.dart';

import '../../model/sensor_data.dart';
import 'details_metric_screen.dart';

class MainStatusWidget extends StatelessWidget {
  final String updatedTime;
  final List<SensorData> sensorList;

  const MainStatusWidget({
    super.key,
    required this.updatedTime,
    required this.sensorList
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tình trạng rung lắc',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  SvgPicture.asset('assets/icons/icon_time.svg'),
                  Text(
                    TimeUtil.epochToVietnamTime(int.parse(updatedTime)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StatusChart(
            spots: sensorList.asMap().entries.map((entry) {
              int index = entry.key;
              var sensor = entry.value;
              return FlSpot(index.toDouble(), sensor.vibrationDetected ? 1 : 0);
            }).toList(),
          ),
          const SizedBox(height: 8),
          ViewMoreWidget(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsMetricScreen(),
              ),
            )
          ),
        ],
      ),
    );
  }
}

Widget _buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}
