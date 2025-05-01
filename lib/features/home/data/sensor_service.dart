import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/home/model/sensor_data.dart';
import 'package:hotel_app/models/example_model.dart';

import '../../../di/injector.dart';

final sensorService = Provider<SensorService>((ref) => SensorService());

class SensorService {
  Future<BaseResponse<SensorData>> getSensorData() async {
    try {
      Response json = await injector<DioClient>().get("/current-sensor-data");
      final SensorData data = SensorData.fromJson(json.data);
      return BaseResponse(isSuccessful: true, sucessfulData: data);

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
