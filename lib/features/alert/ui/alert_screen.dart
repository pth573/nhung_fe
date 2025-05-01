import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/widgets/error_widget.dart';

import '../../../common/utils/location_util.dart';
import '../model/alert.dart';
import '../provider/alert_list_provider.dart';
import 'alert_details_screen.dart';

class AlertScreen extends ConsumerWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Material(
      color: Color(0xFFF3F3F3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AlertHeaderWidget(),
          Expanded(child: AlertListWidget()),
        ],
      ),
    );
  }
}

class AlertListWidget extends ConsumerStatefulWidget {
  const AlertListWidget({super.key});

  @override
  ConsumerState<AlertListWidget> createState() => _AlertListWidgetState();
}

class _AlertListWidgetState extends ConsumerState<AlertListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(alertListViewModel.notifier).loadMore();
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
      onRefresh: () => ref.read(alertListViewModel.notifier).refresh(),
      child: ref.watch(alertListViewModel).when(
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
          final alertList = ref.read(alertListViewModel).listData;
          return ListView.separated(
            controller: _scrollController,
            itemCount: alertList.length + 1,
            itemBuilder: (context, index) {
              if (index == alertList.length) {
                return ref.read(alertListViewModel).canLoadMore
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox();
              }
              else {
                return AlertItem(alert: alertList[index]);
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
              ref.read(alertListViewModel.notifier).getAlertHistory();
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
              ref.read(alertListViewModel.notifier).getAlertHistory();
            },
          );
        },
      ),
    );
  }
}

class AlertItem extends StatelessWidget {
  final Alert alert;

  const AlertItem({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlertDetailsScreen(alert: alert),
          ),
        ),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bắt đầu: ${TimeUtil.epochToVietnamTime(int.parse(alert.startTime))}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kết thúc: ${alert.endTime != null ? TimeUtil.epochToVietnamTime(int.parse(alert.endTime!)) : '-'}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon_location.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.location,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AlertHeaderWidget extends ConsumerStatefulWidget {
  const AlertHeaderWidget({super.key});

  @override
  ConsumerState<AlertHeaderWidget> createState() => _AlertHeaderWidgetState();
}

class _AlertHeaderWidgetState extends ConsumerState<AlertHeaderWidget> {
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
            "Danh sách cảnh báo",
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
                        ref.read(alertListViewModel.notifier).setSearchState(query: text, page: 0);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  ref.read(alertListViewModel.notifier).changeSort();
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: ref.watch(alertListViewModel).order == "asc" ? Colors.grey : Colors.white,
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


