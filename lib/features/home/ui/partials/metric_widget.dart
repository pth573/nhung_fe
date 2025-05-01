import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MetricWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final double value;
  final String rate;

  const MetricWidget({
    super.key,
    this.backgroundColor = Colors.white,
    this.title = "",
    this.value = 0.0,
    this.rate = "Unknown",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/icon_metric.svg'),
                const SizedBox(width: 8),
                Text(
                  rate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 22 / 14,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w400,
                height: 22 / 48,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 22 / 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
