import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/main/presentation/model/only_message_response.dart';

import '../../data/tracking_repository.dart';
import 'floating_bar_provider.dart';

final trackingProvider = AutoDisposeNotifierProvider<TrackingNotifier, BaseState<OnlyMessageResponse>>(
  () => TrackingNotifier(),
);

class TrackingNotifier extends AutoDisposeNotifier<BaseState<OnlyMessageResponse>> {
  @override
  BaseState<OnlyMessageResponse> build() {
    state = BaseState.none();
    return state;
  }

  Future<void> startTrip() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(trackingRepository).startTrip();
      if (response.isSuccessful) {
        state = BaseState.success(response.sucessfulData!);
        ref.read(floatingBarProvider.notifier).state = true;
      } else {
        state = BaseState.error(response.errorMessage ?? "Failed to start trip");
      }
    } catch (e) {
      state = BaseState.error("Failed to start trip");
    }
  }

  Future<void> endTrip() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(trackingRepository).endTrip();
      if (response.isSuccessful) {
        state = BaseState.success(response.sucessfulData!);
        ref.read(floatingBarProvider.notifier).state = false;
      } else {
        state = BaseState.error(response.errorMessage ?? "Failed to end trip");
      }
    } catch (e) {
      state = BaseState.error("Failed to end trip");
    }
  }
}