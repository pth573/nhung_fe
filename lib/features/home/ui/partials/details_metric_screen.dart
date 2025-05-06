import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/home/ui/partials/vibrate_chart_widget.dart';
import '../../provider/sensor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsMetricScreen extends ConsumerStatefulWidget {
  const DetailsMetricScreen({super.key});

  @override
  ConsumerState<DetailsMetricScreen> createState() => _DetailsMetricScreenState();
}

class _DetailsMetricScreenState extends ConsumerState<DetailsMetricScreen> {
  bool showAccelerometer = true;

  @override
  Widget build(BuildContext context) {
    print("decodedMessage00");
    final sensorList = ref.watch(sensorListProvider);
    final lastSensorData = sensorList.isNotEmpty ? sensorList.last : null;

    // Spots for accelerometer
    final accXSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.accX)).toList();
    final accYSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.accY)).toList();
    final accZSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.accZ)).toList();

    final accValues = [...accXSpots, ...accYSpots, ...accZSpots].map((s) => s.y);
    final accMinY = accValues.isNotEmpty ? accValues.reduce((a, b) => a < b ? a : b) : -10.0;
    final accMaxY = accValues.isNotEmpty ? accValues.reduce((a, b) => a > b ? a : b) : 10.0;
    final accRange = accMaxY - accMinY;
    final accMinYPad = accMinY - accRange * 0.1;
    final accMaxYPad = accMaxY + accRange * 0.1;

    // Spots for gyroscope
    final gyroXSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.gyroX)).toList();
    final gyroYSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.gyroY)).toList();
    final gyroZSpots = sensorList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.gyroZ)).toList();

    final gyroValues = [...gyroXSpots, ...gyroYSpots, ...gyroZSpots].map((s) => s.y);
    final gyroMinY = gyroValues.isNotEmpty ? gyroValues.reduce((a, b) => a < b ? a : b) : -10.0;
    final gyroMaxY = gyroValues.isNotEmpty ? gyroValues.reduce((a, b) => a > b ? a : b) : 10.0;
    final gyroRange = gyroMaxY - gyroMinY;
    final gyroMinYPad = gyroMinY - gyroRange * 0.1;
    final gyroMaxYPad = gyroMaxY + gyroRange * 0.1;

    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Data'), backgroundColor: Colors.white),
      body: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: lastSensorData != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metric cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard('Acc X', '${lastSensorData.accX.toStringAsFixed(2)} m/s²'),
                  _buildMetricCard('Acc Y', '${lastSensorData.accY.toStringAsFixed(2)} m/s²'),
                  _buildMetricCard('Acc Z', '${lastSensorData.accZ.toStringAsFixed(2)} m/s²'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard('Gyro X', '${lastSensorData.gyroX.toStringAsFixed(2)} rad/s'),
                  _buildMetricCard('Gyro Y', '${lastSensorData.gyroY.toStringAsFixed(2)} rad/s'),
                  _buildMetricCard('Gyro Z', '${lastSensorData.gyroZ.toStringAsFixed(2)} rad/s'),
                ],
              ),
              const SizedBox(height: 16),
              _buildMetricTile('Latitude', '${lastSensorData.latitude.toStringAsFixed(6)}°'),
              _buildMetricTile('Longitude', '${lastSensorData.longitude.toStringAsFixed(6)}°'),
              _buildMetricTile('Temperature', '${lastSensorData.temperature.toStringAsFixed(1)}°C'),
              _buildMetricTile('Vibration', lastSensorData.vibrationDetected ? 'Detected' : 'Not Detected'),
              _buildMetricTile('Timestamp', TimeUtil.epochToVietnamTime(int.parse(lastSensorData.timestamp))),
              const SizedBox(height: 16),
              // Switch buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTypeButton('Accelerometer', showAccelerometer),
                  const SizedBox(width: 8),
                  _buildTypeButton('Gyroscope', !showAccelerometer),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              DataChartWidget(
                minX: 0,
                minY: showAccelerometer ? accMinYPad : gyroMinYPad,
                maxY: showAccelerometer ? accMaxYPad : gyroMaxYPad,
                label1: showAccelerometer ? 'Acc X' : 'Gyro X',
                label2: showAccelerometer ? 'Acc Y' : 'Gyro Y',
                label3: showAccelerometer ? 'Acc Z' : 'Gyro Z',
                spots1: showAccelerometer ? accXSpots : gyroXSpots,
                spots2: showAccelerometer ? accYSpots : gyroYSpots,
                spots3: showAccelerometer ? accZSpots : gyroZSpots,
              ),
            ],
          )
              : const Center(child: Text('No sensor data')),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected) {
   return GestureDetector(
     onTap: () {
       setState(() {
         showAccelerometer = !showAccelerometer;
       });
     },
     child: Container(
       padding: EdgeInsets.all(10),
       decoration: BoxDecoration(
         color: isSelected ? Colors.black : Colors.grey[300],
         borderRadius: BorderRadius.circular(8),
       ),
       child: Text(
         label,
         style: TextStyle(
           color: isSelected ? Colors.white : Colors.black,
           fontWeight: FontWeight.bold,
         ),
       ),
     ),
   );
  }
}
