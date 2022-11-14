
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_devicess/live_data_model.dart';
import '../../services/apiservices.dart';
import '../../state/live_data.dart';

final liveDataNotifier =
StateNotifierProvider<LiveDataNotifierProvider, LiveDataState>((ref) {
  return LiveDataNotifierProvider(ref);
});

class LiveDataNotifierProvider extends StateNotifier<LiveDataState> {

  Ref ref;

  LiveDataNotifierProvider(this.ref)
      : super(LiveDataState(false, const AsyncLoading(), 'initial'));

  getLiveData(var request) async {
    state = _loading();
    final apiResponse = await ref.read(apiProvider).getLiveData(request);
    if (apiResponse.data!=null) {
      print(jsonDecode(jsonEncode(apiResponse.data)));
      final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(apiResponse.data));

      state = _dataState(LiveDataSensors.fromJson(convertedData));
    } {
      state = _errorState('Timeout');
    }
    return state;
  }

  LiveDataState _dataState(LiveDataSensors entity) {
    return LiveDataState(false, AsyncData(entity), '');
  }

  LiveDataState _loading() {
    return LiveDataState(true, state.id, '');
  }

  LiveDataState _errorState(String errMsg) {
    return LiveDataState(false, state.id, errMsg);
  }

}
