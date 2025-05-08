import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/home/provider/send_sensor_data.dart';
import 'package:hotel_app/features/home/ui/partials/info_card_widget.dart';
import 'package:hotel_app/features/home/ui/partials/main_status_widget.dart';
import 'package:hotel_app/features/home/ui/partials/map_preview_widget.dart';
import 'package:hotel_app/features/home/ui/partials/metric_widget.dart';
import '../../../core/base_state.dart';
import '../../main/presentation/model/only_message_response.dart';
import '../../main/presentation/provider/tracking_provider.dart';
import '../model/sensor_data.dart';
import '../provider/sensor_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<BaseState<OnlyMessageResponse>>(trackingProvider, (previous, next)
    {
      if (next.status.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusWidget(),
              const SizedBox(height: 21),
              HomeBodyWidget(),
            ],
          ),
        )
      ],
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App XYZ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 22 / 17,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          InfoCardWidget(),
        ],
      ),
    );
  }
}



class HomeBodyWidget extends ConsumerWidget {
  const HomeBodyWidget ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensor2 = ref.watch(sensorViewModel);
    final sensorList = ref.watch(sensorListProvider);
    final SensorData sensorData = sensorList.last;
    // sendSensorData();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Tình trạng',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              MetricWidget(
               title: "Rung lắc",
                value: sensorData.vibrationDetected ? 1 : 0,
                rate: sensorData.vibrationDetected ? "Ổn định" : "Phat hiện",
                backgroundColor: Color(0xFFACE08D),
              ),
              SizedBox(width: 12),
              MetricWidget(
                title: "Nhiệt độ",
                value: sensorData.temperature,
                rate: "Trung bình",
                backgroundColor: Color(0xFFECEDB2),
              ),
            ],
          ),
          MainStatusWidget(
            updatedTime: sensorData.timestamp,
            sensorList: sensorList,
          ),
          const SizedBox(height: 20),
          const Text(
            'Vị trí hiện tại',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 22 / 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          MapPreviewWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}




// class HomeBodyWidget extends ConsumerStatefulWidget {
//   const HomeBodyWidget({super.key});
//
//   @override
//   _HomeBodyWidgetState createState() => _HomeBodyWidgetState();
// }
//
// class _HomeBodyWidgetState extends ConsumerState<HomeBodyWidget> {
//   @override
//   void initState() {
//     super.initState();
//     sendSensorData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sensorList = ref.watch(sensorListProvider);
//     final SensorData sensorData = sensorList.last;
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       width: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 12),
//           const Text(
//             'Tình trạng',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               MetricWidget(
//                 title: "Rung lắc",
//                 value: sensorData.vibrationDetected ? 1 : 0,
//                 rate: sensorData.vibrationDetected ? "Ổn định" : "Phat hiện",
//                 backgroundColor: Color(0xFFACE08D),
//               ),
//               SizedBox(width: 12),
//               MetricWidget(
//                 title: "Nhiệt độ",
//                 value: sensorData.temperature,
//                 rate: "Trung bình",
//                 backgroundColor: Color(0xFFECEDB2),
//               ),
//             ],
//           ),
//           MainStatusWidget(
//             updatedTime: sensorData.timestamp,
//             sensorList: sensorList,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Vị trí hiện tại',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               height: 22 / 20,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
//           MapPreviewWidget(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
