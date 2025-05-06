// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hotel_app/common/network/dio_client.dart';
// import 'package:hotel_app/constants/api_url.dart';
// import 'package:hotel_app/core/base_response.dart';
// import 'package:hotel_app/features/home/model/sensor_data.dart';
// import 'package:hotel_app/models/example_model.dart';
//
// import '../../../di/injector.dart';
//
// final sensorService = Provider<SensorService>((ref) => SensorService());
//
// class SensorService {
//   Future<BaseResponse<SensorData>> getSensorData() async {
//     try {
//       Response json = await injector<DioClient>().get("/current-sensor-data");
//       final SensorData data = SensorData.fromJson(json.data);
//       return BaseResponse(isSuccessful: true, sucessfulData: data);
//
//     } on DioException catch (e) {
//       final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
//       return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
//     } catch (e) {
//       return BaseResponse(isSuccessful: false, errorMessage: e.toString());
//     }
//   }
// }


//
//
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:hotel_app/core/base_response.dart';
// import 'package:hotel_app/features/home/model/sensor_data.dart';
//
// final sensorService = Provider<SensorService>((ref) => SensorService());
//
// class SensorService {
//   final WebSocketChannel channel = WebSocketChannel.connect(
//     Uri.parse('ws://172.28.160.1:8000/ws/current-sensor-data/'),
//   );
//
//   Future<BaseResponse<SensorData>> getSensorData() async {
//     try {
//       // Lắng nghe dữ liệu từ WebSocket
//       final responseStream = channel.stream;
//
//       await for (final message in responseStream) {
//         final decodedMessage = jsonDecode(message);
//         print("NHAN DUOC0");
//         print(decodedMessage);
//
//         // Kiểm tra nếu dữ liệu trả về hợp lệ
//         if (decodedMessage != null && decodedMessage['data'] != null) {
//           final SensorData data = SensorData.fromJson(decodedMessage['data']);
//           print("NHAN DUOC");
//           print(data);
//           return BaseResponse(isSuccessful: true, sucessfulData: data);
//         } else {
//           return BaseResponse(
//               isSuccessful: false,
//               errorMessage: "Dữ liệu không hợp lệ hoặc không có.");
//         }
//       }
//     } catch (e) {
//       return BaseResponse(isSuccessful: false, errorMessage: e.toString());
//     } finally {
//       // Nếu kết nối WebSocket kết thúc mà không có dữ liệu, trả về lỗi
//       return BaseResponse(isSuccessful: false, errorMessage: "Kết nối WebSocket đã kết thúc mà không có dữ liệu.");
//     }
//   }
// }




import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/home/model/sensor_data.dart';

final sensorService = Provider<SensorService>((ref) => SensorService());

class SensorService {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://172.28.160.1:8000/ws/current-sensor-data/'),
  );

  Stream<BaseResponse<SensorData>> getSensorData() async* {
    print("NHAN DUOC0000");
    try {
      // Lắng nghe dữ liệu từ WebSocket liên tục
      await for (final message in channel.stream) {
        final decodedMessage = jsonDecode(message);
        print("NHAN DUOC0");
        print(decodedMessage);
        print(decodedMessage['data']);

        if (decodedMessage != null && decodedMessage['data'] != null) {
          final SensorData data = SensorData.fromJson(decodedMessage['data']);
          print("NHAN DUOC");
          print(data);
          yield BaseResponse(isSuccessful: true, sucessfulData: data);
        } else {
          yield BaseResponse(
              isSuccessful: false,
              errorMessage: "Dữ liệu không hợp lệ hoặc không có.");
        }
      }
    } catch (e) {
      yield BaseResponse(isSuccessful: false, errorMessage: e.toString());
    } finally {
      yield BaseResponse(isSuccessful: false, errorMessage: "Kết nối WebSocket đã kết thúc mà không có dữ liệu.");
    }
  }
}
