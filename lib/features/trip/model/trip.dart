import 'package:hotel_app/features/trip/model/route.dart';

class Trip {
  final int id;
  final Route startRoute;
  final Route? endRoute;
  final double? distance;
  final String? duration;

  Trip({
    required this.id,
    required this.startRoute,
    this.endRoute,
    this.distance,
    this.duration,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      startRoute: Route.fromJson(json['start_route']),
      endRoute: json['end_route'] != null
          ? Route.fromJson(json['end_route'])
          : null,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      duration: json['duration'],
    );
  }
}