// ignore_for_file: avoid_dynamic_calls

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/http/client.dart';
import '../data/http/path.dart';
import '../extensions/extensions.dart';
import '../model/station_stamp.dart';
import '../utility/utility.dart';

////////////////////////////////////////////////
final stationStampProvider =
    StateNotifierProvider.autoDispose<StationStampNotifier, List<StationStamp>>(
        (ref) {
  final client = ref.read(httpClientProvider);

  final utility = Utility();

  return StationStampNotifier([], client, utility)..getStationStamp();
});

class StationStampNotifier extends StateNotifier<List<StationStamp>> {
  StationStampNotifier(super.state, this.client, this.utility);

  final HttpClient client;
  final Utility utility;

  Future<void> getStationStamp() async {
    await client.post(path: APIPath.getStationStamp).then((value) {
      final list = <StationStamp>[];

      for (var i = 0; i < value['data'].length.toString().toInt(); i++) {
        list.add(
            StationStamp.fromJson(value['data'][i] as Map<String, dynamic>));
      }

      state = list;
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}

////////////////////////////////////////////////
