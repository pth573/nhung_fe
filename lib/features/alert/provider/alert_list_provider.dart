import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/alert/model/search_data.dart';
import '../../../common/utils/location_util.dart';
import '../../../core/base_state.dart';
import '../data/alert_repository.dart';
import '../model/alert.dart';

final alertListViewModel = AutoDisposeNotifierProvider<AlertProvider, SearchData<Alert>>(() => AlertProvider());

class AlertProvider extends AutoDisposeNotifier<SearchData<Alert>> {
  @override
  SearchData<Alert> build() {
    state = SearchData();
    getAlertHistory();
    return state;
  }

  Future<void> refresh() async {
    state = SearchData();
    await getAlertHistory();
  }

  Future<void> getAlertHistory() async {
    print('Day la ketqua: ${state.page * state.limit}');
    try {
      if (state.page == 0) {
        state = state.copyWith(status: BaseStatus.loading, canLoadMore: true);
      }

      final response = await ref.read(alertRepository).getAlertHistory(
        offset: state.page * state.limit,
        limit: state.limit,
        order: state.order,
        query: state.query,
      );

      if (response.isSuccessful) {
        final List<Alert> alerts = response.sucessfulData!;

        // print(alerts);
        if (alerts.length < state.limit) {
          state = state.copyWith(canLoadMore: false);
        }

        final currentList = state.listData;
        final resultList = state.page == 0 ? alerts : [...currentList, ...alerts];

        state = state.copyWith(
          status: BaseStatus.success,
          listData: resultList,
          page: state.page + 1,
        );

      } else {
        state = state.copyWith(status: BaseStatus.error);
      }
    } catch (e) {
      state = state.copyWith(
        status: BaseStatus.error,
      );
    }
  }

  Future<void> setSearchState({
    String? query,
    String? order,
    int? startDate,
    int? endDate,
    int? page,
    int? limit,
  }) async {
    state = state.copyWith(
      query: query ?? state.query,
      order: order ?? state.order,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      page: page ?? state.page,
      limit: limit ?? state.limit,
    );
    getAlertHistory();
  }

  Future<void> loadMore() async {
    if (state.canLoadMore) {
      await getAlertHistory();
    }
  }

  void changeSort() {
    if (state.order == "desc") {
      state = state.copyWith(order: "asc", page: 0);
    } else {
      state = state.copyWith(order: "desc", page: 0);
    }
    getAlertHistory();
  }
}