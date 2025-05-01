import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/main/presentation/model/only_message_response.dart';

import '../../../common/network/dio_client.dart';
import '../../../core/base_response.dart';
import '../../../di/injector.dart';

final trackingService = Provider<TrackingService>((ref) => TrackingService());

class TrackingService {
  Future<BaseResponse<OnlyMessageResponse>> startTrip() async {
    try {
      Response json = await injector<DioClient>().post("/trip/start");
      final OnlyMessageResponse data = OnlyMessageResponse.fromJson(json.data);
      return BaseResponse(isSuccessful: true, sucessfulData: data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<OnlyMessageResponse>> endTrip() async {
    try {
      Response json = await injector<DioClient>().post("/trip/end");
      final OnlyMessageResponse data = OnlyMessageResponse.fromJson(json.data);
      return BaseResponse(isSuccessful: true, sucessfulData: data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}