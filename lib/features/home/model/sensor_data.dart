class SensorData {
  final double accX;
  final double accY;
  final double accZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double latitude;
  final double longitude;
  final double temperature;
  final bool vibrationDetected;
  final String timestamp;

  SensorData({
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.latitude,
    required this. longitude,
    required this.temperature,
    required this.vibrationDetected,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      accX: (json['AccX'] as num).toDouble(),
      accY: (json['AccY'] as num).toDouble(),
      accZ: (json['AccZ'] as num).toDouble(),
      gyroX: (json['GyroX'] as num).toDouble(),
      gyroY: (json['GyroY'] as num).toDouble(),
      gyroZ: (json['GyroZ'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      vibrationDetected: json['vibration_detected'] as bool,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccX': accX,
      'AccY': accY,
      'AccZ': accZ,
      'GyroX': gyroX,
      'GyroY': gyroY,
      'GyroZ': gyroZ,
      'latitude': latitude,
      'longitude': longitude,
      'temperature': temperature,
      'vibration_detected': vibrationDetected,
      'timestamp': timestamp,
    };
  }
}
