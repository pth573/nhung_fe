import 'dart:convert';
import 'package:hotel_app/features/home/model/sensor_data.dart';
import 'package:http/http.dart' as http;
Future<void> sendSensorData() async {
  final url = Uri.parse('http://172.28.160.1:8000/api/receive-data/');

  final Map<String, dynamic> body = {
    "timestamp": "0", // Set timestamp as '0' or any appropriate value
    "latitude": 0.0,
    "longitude": 0.0,
    "AccX": 0.0,
    "AccY": 0.0,
    "AccZ": 0.0,
    "GyroX": 0.0,
    "GyroY": 0.0,
    "GyroZ": 0.0,
    "temperature": 0.0,
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully');
  } else {
    print('Failed to send data: ${response.statusCode}');
  }
}
