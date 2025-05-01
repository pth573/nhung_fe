import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/home/data/sensor_service.dart';
import 'package:hotel_app/features/home/model/sensor_data.dart';

final sensorRepository = Provider<SensorRepository>(
    (ref) => SensorRepositoryImpl(sensorService: ref.watch(sensorService)),
);

abstract class SensorRepository {
  Future<BaseResponse<SensorData>> getSensorData();
}

class SensorRepositoryImpl implements SensorRepository {
  final SensorService sensorService;

  SensorRepositoryImpl({required this.sensorService});

  @override
  Future<BaseResponse<SensorData>> getSensorData() async {
    return await sensorService.getSensorData();
    // print('call repo');
    // // Khởi tạo random
    // final random = Random();
    //
    // // Tạo dữ liệu giả ngẫu nhiên
    // final fake = SensorData(
    //   accX: random.nextDouble() * 10 - 5,
    //   // random giá trị trong khoảng -5 đến 5
    //   accY: random.nextDouble() * 10 - 5,
    //   accZ: random.nextDouble() * 10 - 5,
    //   gyroX: random.nextDouble() * 5 - 2.5,
    //   // giá trị từ -2.5 đến 2.5
    //   gyroY: random.nextDouble() * 5 - 2.5,
    //   gyroZ: random.nextDouble() * 5 - 2.5,
    //   longitude: 105.853881 + random.nextDouble() * 0.01,
    //   // gần với giá trị thật
    //   latitude: 21.028279 + random.nextDouble() * 0.01,
    //   // gần với giá trị thật
    //   temperature: random.nextDouble() * 40 + 10,
    //   // nhiệt độ từ 10 đến 50 độ
    //   vibrationDetected: random.nextBool(),
    //   // ngẫu nhiên true/false
    //   timestamp: TimeUtil.getTime(DateTime.now()), // thời gian hiện tại
    // );
    //
    // await Future.delayed(const Duration(seconds: 4));
    // return BaseResponse(isSuccessful: true, sucessfulData: fake);
  }
}
