class Alert {
  String startTime;
  String? endTime; // Có thể null
  double latitude;
  double longitude;
  bool isActive;
  String location;

  // Constructor
  Alert({
    required this.startTime,
    this.endTime,
    required this.latitude,
    required this.longitude,
    this.isActive = true, // Giá trị mặc định là true
    this.location = "-"
  });

  // Phương thức từ JSON
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      startTime: json['start_time'],
      endTime: json['end_time'], // Có thể null
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'] ?? "-", // Nếu không có thì mặc định là "-"
      isActive: json['is_active'] ?? true, // Nếu không có thì mặc định là true
    );
  }


  // Phương thức chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'is_active': isActive,
    };
  }
}
