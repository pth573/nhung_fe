import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/alert/model/search_data.dart';
import 'package:hotel_app/features/trip/data/trip_repository.dart';
import 'package:hotel_app/features/trip/model/trip.dart';
import '../../../core/base_state.dart';


final tripListViewModel = AutoDisposeNotifierProvider<TripProvider, SearchData<Trip>>(() => TripProvider());

class TripProvider extends AutoDisposeNotifier<SearchData<Trip>> {
  @override
  SearchData<Trip> build() {
    state = SearchData();
    getData();
    return state;
  }

  Future<void> refresh() async {
    state = SearchData();
    await getData();
  }

  Future<void> getData() async {
    try {
      if (state.page == 0) {
        state = state.copyWith(status: BaseStatus.loading, canLoadMore: true);
      }

      final response = await ref.read(tripRepository).getTripHistory(
        offset: state.page * state.limit,
        limit: state.limit,
        order: state.order,
        query: state.query,
      );

      print("OKKKK2123");
      print(response);
      
      if (response.isSuccessful) {
        final List<Trip> alerts = response.sucessfulData!;

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
    getData();
  }

  Future<void> loadMore() async {
    if (state.canLoadMore) {
      await getData();
    }
  }

  void changeSort() {
    if (state.order == "desc") {
      state = state.copyWith(order: "asc", page: 0);
    } else {
      state = state.copyWith(order: "desc", page: 0);
    }
    getData();
  }
}