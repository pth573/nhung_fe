// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hotel_app/core/base_state.dart';
// import 'package:hotel_app/features/home/data/sensor_repository.dart';
// import 'package:hotel_app/features/home/model/sensor_data.dart';
//
// final sensorViewModel = AutoDisposeNotifierProvider<SensorProvider, BaseState<SensorData>>(() => SensorProvider());
//
// final sensorListProvider = StateProvider<List<SensorData>>((ref) => [
//   SensorData(accX: 0, accY: 0, accZ: 0, gyroX: 0, gyroY: 0, gyroZ: 0, latitude: 10.7769, longitude: 105.7009, temperature: 0, vibrationDetected: true, timestamp: '000000')
// ]);
//
// class SensorProvider extends AutoDisposeNotifier<BaseState<SensorData>> {
//   Timer? _timer;
//
//   @override
//   BaseState<SensorData> build() {
//     state = BaseState.none();
//     _startFetching();
//     return state;
//   }
//
//   void _startFetching() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       getSensorData();
//     });
//   }
//
//   Future<void> getSensorData() async {
//     print("call provider");
//
//     try {
//       final response = await ref.read(sensorRepository).getSensorData();
//
//       if (response.isSuccessful) {
//         final SensorData newData = response.sucessfulData!;
//
//         state = BaseState.success(newData);
//
//         final currentList = ref.read(sensorListProvider);
//
//         if (currentList.length == 7) {
//           currentList.removeAt(0);
//         }
//
//         final updatedList = List<SensorData>.from(currentList)..add(newData);
//
//         ref.read(sensorListProvider.notifier).state = updatedList;
//       } else {
//         state = BaseState.error(response.errorMessage ?? "");
//       }
//     } catch (e) {
//       state = BaseState.error(e.toString());
//     }
//   }
// }
//
//
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/home/data/sensor_repository.dart';
import 'package:hotel_app/features/home/model/sensor_data.dart';
import 'package:hotel_app/core/base_response.dart';

final sensorViewModel = StateNotifierProvider<SensorProvider, BaseState<SensorData>>(
      (ref) => SensorProvider(ref),
);

final sensorListProvider = StateProvider<List<SensorData>>(
      (ref) => [
    SensorData(accX: 0, accY: 0, accZ: 0, gyroX: 0, gyroY: 0, gyroZ: 0, latitude: 10.7769, longitude: 105.7009, temperature: 0, vibrationDetected: true, timestamp: '000000')
  ],
);

class SensorProvider extends StateNotifier<BaseState<SensorData>> {
  final Ref ref;
  late final StreamSubscription<BaseResponse<SensorData>> _sensorDataSubscription;

  SensorProvider(this.ref) : super(BaseState.none()) {
    _startFetching();
  }

  void _startFetching() {
    _sensorDataSubscription = ref
        .read(sensorRepository)
        .getSensorData()
        .listen((response) {
      if (response.isSuccessful) {
        final SensorData newData = response.sucessfulData!;
        state = BaseState.success(newData);

        final currentList = ref.read(sensorListProvider);
        if (currentList.length == 7) {
          currentList.removeAt(0);
        }
        final updatedList = List<SensorData>.from(currentList)..add(newData);
        ref.read(sensorListProvider.notifier).state = updatedList;
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    }, onError: (error) {
      state = BaseState.error(error.toString());
    });
  }

  @override
  void dispose() {
    _sensorDataSubscription.cancel();
    super.dispose();
  }
}
