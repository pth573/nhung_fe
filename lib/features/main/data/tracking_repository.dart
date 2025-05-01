import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/main/data/tracking_service.dart';
import 'package:hotel_app/features/main/presentation/model/only_message_response.dart';

import '../../../core/base_response.dart';

final trackingRepository = Provider<TrackingRepository>(
      (ref) => TrackingRepositoryImpl(api: ref.read(trackingService)),
);

abstract class TrackingRepository {
  Future<BaseResponse<OnlyMessageResponse>> startTrip();
  Future<BaseResponse<OnlyMessageResponse>> endTrip();
}

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingService api;

  TrackingRepositoryImpl({required this.api});

  @override
  Future<BaseResponse<OnlyMessageResponse>> startTrip() async {
    return await api.startTrip();
  }

  @override
  Future<BaseResponse<OnlyMessageResponse>> endTrip() async {
    return await api.endTrip();
  }
}