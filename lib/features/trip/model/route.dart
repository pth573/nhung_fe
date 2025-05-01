class Route {
  final double latitude;
  final double longitude;
  final String location;
  final String time;

  Route({
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.time,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] ?? '',
      time: json['time'] as String,
    );
  }
}

