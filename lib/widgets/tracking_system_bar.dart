import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/main/presentation/provider/tracking_provider.dart';
import '../features/main/presentation/provider/floating_bar_provider.dart';
import '../features/main/presentation/provider/time_provider.dart';
import 'custom_dialog.dart';

class TrackingSystemBar extends ConsumerStatefulWidget {
  const TrackingSystemBar({super.key});

  @override
  ConsumerState<TrackingSystemBar> createState() => _TrackingSystemBarState();
}

class _TrackingSystemBarState extends ConsumerState<TrackingSystemBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timerProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final seconds = ref.watch(timerProvider);

    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return "$minutes:$secs";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D9D8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đang di chuyển',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatTime(seconds),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      content: 'Bạn có muốn kết thúc chuyen đi không?',
                      title: 'Xác nhận',
                      leftTitle: "Hủy",
                      rightTitle: 'Kết thúc',
                      onTap: () {
                        ref.read(timerProvider.notifier).stop();
                        ref.read(trackingProvider.notifier).endTrip();
                      },
                    );
                  },
                );
              },
              child: const Text(
                "Kết thúc",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}