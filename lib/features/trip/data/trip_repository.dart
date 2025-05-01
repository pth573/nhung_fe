import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/alert/model/alert.dart';
import 'package:hotel_app/features/trip/data/trip_service.dart';
import 'package:hotel_app/features/trip/model/trip.dart';

import '../../../core/base_response.dart';

final tripRepository = Provider<TripRepository>(
      (ref) => TripRepositoryImpl(api: ref.read(tripService)),
);

abstract class TripRepository {
  Future<BaseResponse<List<Trip>>> getTripHistory({int offset, int limit, String order, String query});
}

class TripRepositoryImpl implements TripRepository {
  final TripService api;

  TripRepositoryImpl({required this.api});

  @override
  Future<BaseResponse<List<Trip>>> getTripHistory({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = ""
  }) async {
    return await api.getTripHistory(
      offset: offset,
      limit: limit,
      order: order,
      query: query,
    );
  }
}