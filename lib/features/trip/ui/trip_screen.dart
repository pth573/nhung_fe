import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/trip/provider/trip_provider.dart';
import 'package:hotel_app/widgets/error_widget.dart';

import '../../../common/utils/location_util.dart';
import '../model/trip.dart';
import 'package:geocoding/geocoding.dart';

class TripScreen extends ConsumerWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Material(
      color: Color(0xFFF3F3F3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripHeaderWidget(),
          Expanded(child: TripListWidget()),
        ],
      ),
    );
  }
}

class TripListWidget extends ConsumerStatefulWidget {
  const TripListWidget({super.key});

  @override
  ConsumerState<TripListWidget> createState() => _TripListWidgetState();
}

class _TripListWidgetState extends ConsumerState<TripListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(tripListViewModel.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ref.read(tripListViewModel.notifier).refresh(),
      child: ref.watch(tripListViewModel).when(
        none: () => const Center(
          child: Text(
            "Không có dữ liệu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ),
        success: (data) {
          final tripList = ref.read(tripListViewModel).listData;
          return ListView.separated(
            controller: _scrollController,
            itemCount: tripList.length + 1,
            itemBuilder: (context, index) {
              if (index == tripList.length) {
                return ref.read(tripListViewModel).canLoadMore
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : const SizedBox();
              }
              else {
                return TripItem(trip: tripList[index]);
              }
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                color: const Color(0xFFC7C1C1),
              );
            },
          );
        },
        error: (error) {
          return CustomErrorWidget(
            errorMessage: error,
            onRetry: () {
              ref.read(tripListViewModel.notifier).getData();
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        orElse: () {
          return CustomErrorWidget(
            errorMessage: "An error occurred",
            onRetry: () {
              ref.read(tripListViewModel.notifier).getData();
            },
          );
        },
      ),
    );
  }
}


Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
    return 'Không rõ địa điểm';
  } catch (e) {
    // Return '0 - 0' in case of error
    return '0 - 0';
  }
}

//
//
// class TripItem extends StatelessWidget {
//   final Trip trip;
//
//   const TripItem({
//     super.key,
//     required this.trip,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       borderRadius: BorderRadius.circular(12),
//       elevation: 2,
//       color: Colors.white,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         child: Ink(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Bắt đầu: ${trip.startRoute.latitude} ${trip.startRoute.location} ${trip.startRoute.longitude} ',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF555555),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 'Kết thúc: '
//                     '${trip.endRoute?.latitude ?? ''} '
//                     '${trip.endRoute?.location ?? ''} '
//                     '${trip.endRoute?.longitude ?? ''}',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF555555),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 trip.distance != null
//                     ? 'Khoảng cách: ${trip.distance} km'
//                     : 'Khoảng cách: -',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 trip.duration != null
//                     ? 'Thời gian: ${trip.duration}'
//                     : 'Thời gian: -',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TripItem extends StatefulWidget {
  final Trip trip;

  const TripItem({super.key, required this.trip});

  @override
  State<TripItem> createState() => _TripItemState();
}

class _TripItemState extends State<TripItem> {
  String startAddress = '';
  String endAddress = '';

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final start = await getAddressFromCoordinates(
        widget.trip.startRoute.latitude, widget.trip.startRoute.longitude);
    final end = widget.trip.endRoute != null
        ? await getAddressFromCoordinates(
        widget.trip.endRoute!.latitude, widget.trip.endRoute!.longitude)
        : '';

    setState(() {
      startAddress = start;
      endAddress = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bắt đầu: $startAddress',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 6),
              Text(
                'Kết thúc: $endAddress',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 10),
              Text(
                trip.distance != null ? 'Khoảng cách: ${trip.distance} km' : 'Khoảng cách: -',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                trip.duration != null ? 'Thời gian: ${trip.duration}' : 'Thời gian: -',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TripHeaderWidget extends ConsumerStatefulWidget {
  const TripHeaderWidget({super.key});

  @override
  ConsumerState<TripHeaderWidget> createState() => _TripHeaderWidgetState();
}

class _TripHeaderWidgetState extends ConsumerState<TripHeaderWidget> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lịch sử chuyến đi",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE0E0E0)),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm theo vị trí',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8D8D8D),
                      ),
                    ),
                    onChanged: (text) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        ref.read(tripListViewModel.notifier).setSearchState(query: text, page: 0);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  ref.read(tripListViewModel.notifier).changeSort();
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: ref.watch(tripListViewModel).order == "asc" ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.sort, color: Colors.black, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}


