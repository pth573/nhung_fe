import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/main/presentation/provider/tracking_provider.dart';

import '../../../main/presentation/provider/floating_bar_provider.dart';

class InfoCardWidget extends ConsumerStatefulWidget {
  const InfoCardWidget({
    super.key,
  });

  @override
  ConsumerState<InfoCardWidget> createState() => _InfoCardWidgetState();
}

class _InfoCardWidgetState extends ConsumerState<InfoCardWidget> {

  final List<LinearGradient> gl = [
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF74CC77),
        Color(0xFF3A663B),
      ],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 255, 255, 0.25),
        Colors.black,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isTracking = ref.watch(floatingBarProvider);

    return GestureDetector(
      onTap: () {
        ref.read(trackingProvider.notifier).startTrip();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isTracking ? gl[0] : gl[1],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/icon_car.svg'),
                        const SizedBox(width: 24),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tracking app',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 22 / 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 14),
                            Row(
                              children: [
                                Text(
                                  'Hệ thống vận chuyển thông minh',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 22 / 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SvgPicture.asset('assets/icons/icon_untracking.svg'),
                  const SizedBox(height: 14),
                  Text(
                    isTracking ?'Tracking' : 'Untracking',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 22 / 12,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
