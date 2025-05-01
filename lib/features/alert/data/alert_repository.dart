import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/alert/model/alert.dart';

import '../../../core/base_response.dart';
import 'alert_service.dart';

final alertRepository = Provider<AlertRepository>(
      (ref) => AlertRepositoryImpl(api: ref.read(alertService)),
);

abstract class AlertRepository {
  Future<BaseResponse<List<Alert>>> getAlertHistory({int offset, int limit, String order, String query});
}

class AlertRepositoryImpl implements AlertRepository {
  final AlertService api;

  AlertRepositoryImpl({required this.api});

  @override
  Future<BaseResponse<List<Alert>>> getAlertHistory({
        int offset = 0,
        int limit = 10,
        String order = "desc",
        String query = ""
      }) async {
    return await api.getAlertHistory(
        offset: offset,
        limit: limit,
        order: order,
        query: query,
    );
  }
}