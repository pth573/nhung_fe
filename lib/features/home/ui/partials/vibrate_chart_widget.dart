import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataChartWidget extends StatelessWidget {
  final double minX;
  final double minY;
  final double maxY;
  final String label1;
  final String label2;
  final String label3;
  final List<FlSpot> spots1;
  final List<FlSpot> spots2;
  final List<FlSpot> spots3;

  const DataChartWidget({
    super.key,
    this.minX = 0,
    this.minY = 0,
    this.maxY = 1,
    required this.label1,
    required this.label2,
    required this.label3,
    required this.spots1,
    required this.spots2,
    required this.spots3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          // Legend
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.red, label1),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.blue, label2),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.black, label3),
              ],
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true, // Ẩn lưới dọc
                  horizontalInterval: 1, // Chỉ
                  verticalInterval: 1,// hiển thị lưới ngang mỗi 2 đơn vị
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.25), // Màu lưới nhạt hơn
                      strokeWidth: 0.5, // Độ dày lưới mỏng hơn
                    );
                  },
                ), // Ẩn lưới
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, // Chỉ hiển thị tiêu đề trục trái
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0) { // nếu value chia 1 dư 0 => là số nguyên
                          return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                        }
                        return const SizedBox(); // không phải int thì ẩn đi
                      },
            
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Ẩn trục phải
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Ẩn trục trên
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))
                  // bottomTitles: AxisTitles(
                  //   sideTitles: SideTitles(
                  //     showTitles: true, // Chỉ hiển thị tiêu đề trục dưới
                  //     interval: 1, // Hiển thị tiêu đề mỗi 2 đơn vị (ít điểm hơn)
                  //     getTitlesWidget: (value, meta) {
                  //       if (value == 0) {
                  //         return const SizedBox();
                  //       } else {
                  //         return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                  //       }
                  //     },
                  //   ),
                  // ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                    left: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                  ), // Viền biểu đồ
                ),
                minX: minX,
                maxX: spots1.length.toDouble() - 1,
                minY: minY,
                maxY : maxY,
            
                lineBarsData: [
                  LineChartBarData(
                    spots: spots1,
                    isCurved: false, // Làm mượt đường
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true, // Đổ bóng từ line xuống
                      color: Colors.blue.withValues(alpha: 0.3), // Màu đổ bóng
                      gradient: LinearGradient(
                        colors: [Color(0xFF93AAFD).withValues(alpha: 0.5), Color(0xFFC6D2FD).withValues(alpha: 0.2)], // Hiệu ứng mờ dần
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: true), // Hiển thị các điểm
                  ),
                  LineChartBarData(
                    spots: spots2,
                    isCurved: false, // Làm mượt đường
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true, // Đổ bóng từ line xuống
                      color: Colors.blue.withValues(alpha: 0.3), // Màu đổ bóng
                      gradient: LinearGradient(
                        colors: [Color(0xFF93AAFD).withValues(alpha: 0.5), Color(0xFFC6D2FD).withValues(alpha: 0.2)], // Hiệu ứng mờ dần
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: true), // Hiển thị các điểm
                  ),
                  LineChartBarData(
                    spots: spots3,
                    isCurved: false, // Làm mượt đường
                    color: Colors.black,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true, // Đổ bóng từ line xuống
                      color: Colors.blue.withValues(alpha: 0.3), // Màu đổ bóng
                      gradient: LinearGradient(
                        colors: [Color(0xFF93AAFD).withValues(alpha: 0.5), Color(0xFFC6D2FD).withValues(alpha: 0.2)], // Hiệu ứng mờ dần
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: true), // Hiển thị các điểm
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => Color(0xFF1E1B39),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          touchedSpot.y.toString(),
                          const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, height: 18/14),
                        );
                      }).toList();
                    },
                  )
                )
              ),
            ),
          ),
        ],
      ),
    );

  }
}

Widget _buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}