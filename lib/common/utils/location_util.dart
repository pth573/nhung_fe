// import 'package:dio/dio.dart';
// import 'package:geocoding/geocoding.dart';
//
// class LocationUtil {
//   static Future<String> getAddressFromNominatim(double latitude, double longitude) async {
//     final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
//     final dio = Dio();
//
//     try {
//       final response = await dio.get(
//         url,
//         options: Options(
//           headers: {'User-Agent': 'YourAppName'},
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final data = response.data; // Dio tự động parse JSON nếu response là JSON
//         return data['display_name'] ?? 'No address found';
//       }
//       return 'Error: Unable to fetch address';
//     } catch (e) {
//       print('Nominatim error: $e');
//       return 'Error: Unable to fetch address';
//     }
//   }
//
//   static String convertToString(double latitude, double longitude) {
//     return 'Vĩ độ: $latitude, Kinh độ: $longitude';
//   }
// }